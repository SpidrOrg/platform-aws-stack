include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../_terraform_modules/terraform-aws-krny-lambda-v1//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  lambda_vars = read_terragrunt_config(find_in_parent_folders("lambda_vars.hcl"))
}

dependency "s3_bucket_id_external_sources" {
  config_path = "../../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

# dependency "s3_bucket_id" {
#   config_path = "../../../../s3/lambdacode//."
#   mock_outputs = {
#     s3_bucket_id = "bucket-name"
#   }
# }


dependency "dynamodb_table_id" {
  config_path = "../../../../09-dynamodb/03-google-trends"
  mock_outputs = {
    dynamodb_table_id = "dynamo-name"
  }
}

dependency "pytrends_layers" {
  config_path = "../../../03-layers/03-pytrends"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
  }
}

dependency "google_iam_roles" {
  config_path = "../../../../07-iam/01-lambda_roles/03-google-trends-roles/02-child"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::396112814485:role/terraform"
  }
}

dependency "security_group_id" {
  config_path = "../../../../02-securitygroup/01-lambda_sg"
  mock_outputs = {
    security_group_id = ["sg-1234"]
  }
}

dependency "pvt_subnet" {
  config_path = "../../../../01-vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}
    
inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "ingestion-googletrends-child"
    s3_key                                  = "functions/googletrendschild/lambda_function.py.zip"
    runtime                                 = "python3.7"
    layer_arns                              = [dependency.pytrends_layers.outputs.id]
    # layer_arns                              = ["arn:aws:lambda:us-east-1:396112814485:layer:pytrends-tf:1"]
    role_arn                                = dependency.google_iam_roles.outputs.iam_role_arn
    environment_variables                   = { bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, dynamo_table = dependency.dynamodb_table_id.outputs.dynamodb_table_id, file_path = "raw-data/google_trends1/1900-01-01/" }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})