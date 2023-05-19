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

dependency "dynamodb_table_id" {
  config_path = "../../../09-dynamodb/02-fred"
  mock_outputs = {
    dynamodb_table_id = "dynamo-name"
  }
}

dependency "fred_iam_roles" {
  config_path = "../../../07-iam/01-lambda_roles/02-fred-roles"
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


dependency "s3_bucket_id_external_sources" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "security_group_id" {
  config_path = "../../../02-securitygroup/01-lambda_sg"
  mock_outputs = {
    security_group_id = "sg-1234"
  }
}



dependency "secret_name" {
  config_path = "../../../05-secret-manager/01-krny-sensing-solution/"
  mock_outputs = {
    secret_name = ["secret-name"]
  }
}

dependency "job_name" {
  config_path = "../../../12-glue/jobs/transformation-fred"
  mock_outputs = {
    glue_job_name = ["jobname"]
  }
}

dependency "request_s3_fs_pandas" {
  config_path = "../../03-layers/04-request_s3_fs_pandas"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1::123456789012::layer:request_s3fs_pandas_layers:1"
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name          = "ingestion-fred"
    s3_key                 = "functions/fred/lambda_function.py.zip"
    runtime                = "python3.8"
    layer_arns             = [dependency.request_s3_fs_pandas.outputs.id]
    role_arn               = dependency.fred_iam_roles.outputs.iam_role_arn
    environment_variables  = { secret = "krny-sensing-solution-secret", gluejobname = "transformation-fred", file_path = "raw-data/fred/", bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, dynamodb_table = dependency.dynamodb_table_id.outputs.dynamodb_table_id }
    vpc_subnet_ids         = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids = [dependency.security_group_id.outputs.security_group_id]
})
