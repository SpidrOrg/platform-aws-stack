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
  config_path = "../../01-functions/03-ihs"
  mock_outputs = {
    lambda_function_arn = "arn:aws:lambda:us-east-1:993809450021:function:test-2"
  }
}

dependency "s3_bucket_id" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_id = "arn:aws:s3:::993809450021-test-statefiles"
  }
}

dependency "s3_bucket_arn" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_arn = "arn:aws:s3:::993809450021-test-statefiles"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    lambda_function_arn = "arn:aws:lambda:us-east-1::123456789012::function:ingestion-ihs"
    statement_id        = "IHSAllowExecutionFromS3Bucket"
    s3_bucket_arn       = dependency.s3_bucket_arn.outputs.s3_bucket_arn
    s3_bucket           = dependency.s3_bucket_id.outputs.s3_bucket_id
    filter_prefix       = "raw-data/ihs/manual-upload/ihs-historical/"
    filter_prefix_1     = "raw-data/ihs/manual-upload/ihs-pp/"
    filter_suffix       = ".xlsx"
    events              = ["s3:ObjectCreated:*"]
})

"krny-spi-ext-sources-:ENV_NAME:"