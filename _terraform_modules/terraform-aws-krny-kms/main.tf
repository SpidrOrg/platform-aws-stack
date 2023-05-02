provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

resource "aws_kms_key" "kms_key" {
  description              = var.description
  key_usage                = var.key_usage
  policy                   = var.policy
  customer_master_key_spec = var.customer_master_key_spec
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.multi_region
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = var.alias
  target_key_id = aws_kms_key.kms_key.key_id
}