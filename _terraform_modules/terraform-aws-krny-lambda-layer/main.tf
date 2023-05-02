provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}


# resource "local_file" "values" {
#   filename = "${path.module}/values.txt"
#   content  = "Sample content"
# }

resource "aws_lambda_layer_version" "this" {
  filename            = var.filename
  layer_name          = var.layer_name
  compatible_runtimes = var.compatible_runtimes
}

