provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

provider "aws" {
  region = var.replication_region
  alias  = "replica"
}

data "aws_caller_identity" "current" {}
##------s3_Bucket_module-------------

module "s3_bucket" {
  source                                = "./modules/terraform-aws-s3-bucket-2.14.1"
  bucket                                = var.bucket_name
  acl                                   = "private"
  force_destroy                         = var.force_destroy
  attach_policy                         = var.attach_policy
  policy                                = data.aws_iam_policy_document.bucket_policy.json
  attach_deny_insecure_transport_policy = var.deny_insecure
  website                               = var.website

  versioning = {
    enabled = var.versioning
  }

  tags = {
    Name             = var.bucket_name,
    Owner            = var.owner,
    EnvironmentClass = var.environment_class,
    ManagedBy        = "terraform"
  }

  ##------Keep this feature if want to use--------------

  server_side_encryption_configuration = var.disable_server_side_encryption == true ? {} : {
    rule = { ##-------Encryption key type (Amazon S3 key (SSE-S3))-------
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  #----------Replication-Configuration----------------

  replication_configuration = var.enable_replication == true ? {
    role = aws_iam_role.replication[0].arn

    rules = [
      {
        id     = "everything-without-filters"
        status = "Enabled"

        destination = {
          bucket        = module.replica_bucket.s3_bucket_id
          storage_class = "STANDARD"
        }
      },
    ]
  } : {}


  ##------lifecycle_rule for current and Noncurrent_transition -----------
  lifecycle_rule = [
    {
      id      = "current_transition"
      enabled = var.lifecycle_rule_enabled
      prefix  = var.lifecycle_rule_prefix

      tags = {
        rule      = "log"
        autoclean = "true"
      }

      ##-------transition----------

      transition = var.current_transition

      expiration = {
        days = var.expiration_days
      }
      noncurrent_version_expiration = {
        days = var.noncurrent_version_expiration_days
      }
    },
    {
      id                                     = "noncurrent_transition"
      enabled                                = var.lifecycle_rule_enabled
      prefix                                 = var.lifecycle_rule_prefix
      abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days

      ##---------noncurrent_version_transition---------

      noncurrent_version_transition = var.noncurrent_version_transition

      noncurrent_version_expiration = {
        days = var.noncurrent_version_expiration_days
      }
    },
  ]
  #---bucket_logging---------

  ///////// Enable(uncomment) this block if s3 is used for static website hosting 
  //////// if enabled , it will create 2 s3 buckets log bucket and its replication.
  logging = {
    count         = var.log_bucket ? 1 : 0
    target_bucket = module.log_bucket[0].s3_bucket_id
    target_prefix = "log/"
  }

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}
##--------s3_log_bucket-----------

module "log_bucket" {
  source = "./modules/terraform-aws-s3-bucket-2.14.1"
  count  = var.log_bucket ? 1 : 0

  bucket                                = "logs-${var.bucket_name}"
  acl                                   = "log-delivery-write"
  force_destroy                         = true
  attach_elb_log_delivery_policy        = true
  attach_lb_log_delivery_policy         = true
  attach_deny_insecure_transport_policy = true

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  versioning = {
    enabled = var.versioning
  }

  #-------Replication-Configuration-------------------
  replication_configuration = var.enable_replication == true ? {
    role = aws_iam_role.replication_logs[0].arn

    rules = [
      {
        id     = "everything-without-filters"
        status = "Enabled"

        destination = {
          bucket        = module.log-replica_bucket.s3_bucket_id
          storage_class = "STANDARD"
        }
      },
    ]
  } : {}

}

#-------Aws_vpc_endpoint------------

resource "aws_vpc_endpoint" "s3" {
  count        = var.vpc_endpoint ? 1 : 0
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  tags = {
    Name             = var.vpc_endpoint_name,
    Owner            = var.owner,
    EnvironmentClass = var.environment_class,
    ManagedBy        = "terraform"
  }

}
#-------- associate route table with VPC endpoint----

resource "aws_vpc_endpoint_route_table_association" "route_table_association" {
  count           = var.vpc_endpoint ? 1 : 0
  route_table_id  = var.route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id

}

#-----KMS-Replica------------------------------
resource "aws_kms_key" "replica" {
  #skipping rotation enable terrascan
  #ts:skip=AC_AWS_0160
  count    = var.enable_replication == true ? 1 : 0
  provider = aws.replica

  description             = "S3 bucket replication KMS key"
  deletion_window_in_days = 7
}
##------IAM Role and Bucket Policy--------------

resource "aws_iam_role" "s3-role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.s3-role.arn]
    }
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }
}
#----------Replicatio--------------
//Origin-Bucket
module "replica_bucket" {
  count  = var.enable_replication == true ? 1 : 0
  source = "./modules/terraform-aws-s3-bucket-2.14.1"

  providers = {
    aws = aws.replica
  }

  bucket = "replica-${var.bucket_name}"
  acl    = "private"

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  versioning = {
    enabled = var.versioning
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

//Log-Bucket
module "log-replica_bucket" {
  source = "./modules/terraform-aws-s3-bucket-2.14.1"
  count  = var.log_bucket == true && var.enable_replication == true ? 1 : 0

  providers = {
    aws = aws.replica
  }

  bucket = "replica-logs-${var.bucket_name}"
  acl    = "private"

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  versioning = {
    enabled = var.versioning
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

#-----IAM-For-Replication--------------
//Main-Bucket
resource "aws_iam_role" "replication" {
  count = var.enable_replication == true ? 1 : 0
  name  = "replica-${var.bucket_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  count = var.enable_replication == true ? 1 : 0
  name  = "replica-${var.bucket_name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": [
      "arn:aws:s3:::replica-${var.bucket_name}/*"
      ]

    }
  ]
}
POLICY
}

//Log-Bucket
resource "aws_iam_role" "replication_logs" {
  count = var.enable_replication == true ? 1 : 0
  name  = "replica-logs-${var.bucket_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication_logs" {
  count = var.enable_replication == true ? 1 : 0
  name  = "replica-logs-${var.bucket_name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::logs-${var.bucket_name}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::logs-${var.bucket_name}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": [
      "arn:aws:s3:::replica-logs-${var.bucket_name}/*"
      ]

    }
  ]
}
POLICY
}
resource "aws_iam_policy_attachment" "replication" {
  count      = var.enable_replication == true ? 1 : 0
  name       = "replica-${var.bucket_name}"
  roles      = [aws_iam_role.replication[0].name]
  policy_arn = aws_iam_policy.replication[0].arn
}

resource "aws_iam_policy_attachment" "replication_logs" {
  count      = var.enable_replication == true ? 1 : 0
  name       = "replica-logs-${var.bucket_name}"
  roles      = [aws_iam_role.replication_logs[0].name]
  policy_arn = aws_iam_policy.replication_logs[0].arn
}

module "object_locked" {
  source = "./modules/terraform-aws-s3-bucket-2.14.1"
  count  = var.object_lock ? 1 : 0

  bucket = module.s3_bucket.s3_bucket_id

  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }
}

module "s3-bucket-folders" {
  source            = "./modules/terraform-aws-s3-bucket-2.14.1"
  bucket            = module.s3_bucket.s3_bucket_id
  data_folders_list = var.data_folders_list

  depends_on = [
    module.s3_bucket
  ]
}