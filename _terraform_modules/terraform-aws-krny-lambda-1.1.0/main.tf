provider "aws" {
  region = var.region
  credentials_chain_verbose_errors = true
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}


module "lambda_layer_local" {
  source = "./terraform-aws-lambda"

  create_layer = true

  layer_name          = var.layer_name
  description         = var.description
  compatible_runtimes = var.compatible_runtimes
  source_path         = var.source_path
}
