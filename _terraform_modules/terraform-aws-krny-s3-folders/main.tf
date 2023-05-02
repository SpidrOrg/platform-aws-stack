provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
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


  ##------lifecycle_rule for current and Noncurrent_transition -----------
  lifecycle_rule = [
    {
      id      = "current_transition"
      enabled = var.lifecycle_rule_enabled
      #prefix  = var.lifecycle_rule_prefix

      tags = {
        rule      = "log"
        autoclean = "true"
      }

      ##-------transition----------

      transition = var.current_transition

      expiration = {
        days = var.expiration_days
      }
    },
  ]

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}

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

module "sensing-bucket-folders" {
  source                  = "./modules/terraform-aws-s3-bucket-2.14.1/modules/folders/data-store/sensing-data-buckets"
  bucket_name             = module.s3_bucket.s3_bucket_id
  data_folders_list       = var.data_folders_list

    depends_on = [
    module.s3_bucket
  ]  
}