include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-triggers//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "function_arn" {
  config_path = "../../01-functions/05-similar-web"
  mock_outputs = {
    lambda_function_arn = "arn:aws:lambda:us-east-1:1111222233:function:test-2"
  }
}

dependency "s3_bucket_id" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "s3_bucket_arn" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_arn = "bucket-name"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    lambda_function_arn = dependency.function_arn.outputs.lambda_function_arn
    statement_id        = "SimilarWebAllowExecutionFromS3Bucket"
    s3_bucket_arn       = dependency.s3_bucket_arn.outputs.s3_bucket_arn
    s3_bucket           = dependency.s3_bucket_id.outputs.s3_bucket_id
    filter_prefix       = "raw-data/similar_web/manual_upload/raw_conversion_dashboard/"
    filter_suffix       = ".xlsx"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix_1     = "raw-data/similar_web/manual_upload/raw_totaltraffic_sources/"
})
