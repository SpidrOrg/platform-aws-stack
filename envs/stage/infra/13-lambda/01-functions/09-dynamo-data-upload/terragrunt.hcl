include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-v1//."
}


locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  lambda_vars = read_terragrunt_config(find_in_parent_folders("lambda_vars.hcl"))
}

dependency "load_s3_dynamodb_roles" {
  config_path = "../../../07-iam/01-lambda_roles/09-load_s3_dynamodb"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam:::123456789012::role/terraform"
  }
}

dependency "pvt_subnet" {
  config_path = "../../../01-vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

dependency "security_group_id" {
  config_path = "../../../02-securitygroup/01-lambda_sg"
  mock_outputs = {
    security_group_id = "sg-1234"
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name = "krny-load-s3-dynamodb"
    # s3_bucket                               = dependency.s3_bucket_id.outputs.s3_bucket_id
    s3_key   = "functions/dynamodb-upload/lambda_function.py.zip"
    runtime  = "python3.9"
    role_arn = dependency.load_s3_dynamodb_roles.outputs.iam_role_arn
    environment_variables                   = {  file_name_PP = "Pricing and Purchasing Historical Price-Building Material_v1116", file_name_historical = "IHS_Economic_History_v1116", folder_path_PP = "raw-data/ihs/data/ihs-pp/", folder_path_historical = "raw-data/ihs/data/ihs-historical/", prefix_PP = "raw-data/ihs/manual-upload/ihs-pp/", prefix_historical = "raw-data/ihs/manual-upload/ihs-historical/", gluejobname = "test" }//gluejobname = dependency.job_name.outputs.glue_job_name[0] }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})
