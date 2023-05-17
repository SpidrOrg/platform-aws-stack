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

dependency "new-pytrends-layer" {
  config_path = "../../../03-layers/08-new-pytrends"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
  }
}


dependency "dynamodb_table_id" {
  config_path = "../../../../09-dynamodb/06-google-trends-client"
  mock_outputs = {
    dynamodb_table_id = "dynamo-name"
  }
}

dependency "google_iam_roles" {
  config_path = "../../../../07-iam/01-lambda_roles/03-google-trends-roles/03-client"
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

dependency "child_arn" {
  config_path = "../01-child"
  mock_outputs = {
    lambda_function_arn = "arn:aws:lambda:us-east-1:111122223411:function:name"
  }
}

dependency "job_name" {
  config_path = "../../../../12-glue/jobs/transformation-google"
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "ingestion-googletrends-client"
    s3_key                                  = "functions/googletrendsclient/lambda_function.py.zip"
    runtime                                 = "python3.8"
    layer_arns                              = ["arn:aws:lambda:us-east-1:396112814485:layer:new_pytrends:1"]
    role_arn                                = dependency.google_iam_roles.outputs.iam_role_arn
    environment_variables                   = { dynamodb = dependency.dynamodb_table_id.outputs.dynamodb_table_id, env = "uat", krny_bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})