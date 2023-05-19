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
  config_path = "../../../../08-s3/01-externalsources//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "s3_bucket_id" {
  config_path = "../../../../08-s3/02-codebase//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "moodys_roles" {
  config_path = "../../../../07-iam/01-lambda_roles/05-moodys-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam:::123456789012::role/aws-role"
  }
}

dependency "yahoo_fin_layers" {
  config_path = "../../../03-layers/06-yahoo-fin-package"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
  }
}

dependency "openpyxl_layers" {
  config_path = "../../../03-layers/02-openpyxl"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
  }
}

dependency "s3fs_layers" {
  config_path = "../../../03-layers/05-s3fs"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
  }
}

dependency "pvt_subnet" {
  config_path = "../../../../01-vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

dependency "security_group_id" {
  config_path = "../../../../02-securitygroup/01-lambda_sg"
  mock_outputs = {
    security_group_id = "sg-1234"
  }
}

dependency "dynamodb_table" {
  config_path = "../../../../09-dynamodb/05-moodys"
  mock_outputs = {
    dynamodb_table_id = "db-name"
  }
}

dependency "job_name" {
  config_path = "../../../../12-glue/jobs/transformation-moodys"
  mock_outputs = {
    glue_job_name = ["jobname"]
  }
}

dependency "request_s3_fs_pandas" {
  config_path = "../../../03-layers/04-request_s3_fs_pandas"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1::123456789012::layer:request_s3fs_pandas_layers:1"
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name          = "ingestion-moodys-monthly"
    s3_key                 = "functions/moodys-monthly/lambda_function.py.zip"
    runtime                = "python3.8"
    layer_arns             = [dependency.request_s3_fs_pandas.outputs.id]
    role_arn               = dependency.moodys_roles.outputs.iam_role_arn
    environment_variables  = { secret_name = "krny-moodys-secret", dynamodb_table = "krny-moodys", bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, date_column = "monthly_date", file_name = "moodys_monthly.csv", file_path = "raw-data/moodys_all/data/monthly/", freq_code = 128, gluejobname = "transformation-moodys", mapping_file_name = "moodys_all_mnemonics.csv", mapping_file_path = "raw-data/moodys_all/config/" }
    vpc_subnet_ids         = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids = [dependency.security_group_id.outputs.security_group_id]
})
