provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = var.statement_id
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = var.events
    filter_prefix       = var.filter_prefix
    filter_suffix       = var.filter_suffix
  }

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = var.events
    filter_prefix       = var.filter_prefix_1
    filter_suffix       = var.filter_suffix
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
