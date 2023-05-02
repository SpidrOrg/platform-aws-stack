provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_secretsmanager_secret" "git_secret" {
  name       = var.secret_name
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id = aws_secretsmanager_secret.git_secret.id

  secret_string = jsonencode(var.secret_data)
}

