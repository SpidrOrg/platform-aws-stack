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
  config_path = "../../../../07-iam/01-lambda_roles/10-moodys-manual-role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::396112814485:role/aws-role"
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
    security_group_id = ["sg-1234"]
  }
}

dependency "dynamodb_table" {
  config_path = "../../../../09-dynamodb/05-moodys"
  mock_outputs = {
    dynamodb_table_id = ["db-name"]
  }
}

dependency "secret_name" {
  config_path = "../../../../05-secret-manager/02-moodys/"
  mock_outputs = {
    secret_name = ["secret-name"]
  }
}

dependency "job_name" {
  config_path = "../../../../12-glue/jobs/transformation-moodys-188"
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "ingestion-moodys-188"
    # s3_bucket                               = dependency.s3_bucket_id.outputs.s3_bucket_id
    s3_key                                  = "functions/moodys-manual/lambda_function.py.zip"
    runtime                                 = "python3.9"
    layer_arns                              = [dependency.yahoo_fin_layers.outputs.id, dependency.openpyxl_layers.outputs.id, dependency.s3fs_layers.outputs.id]
    # layer_arns                              = ["arn:aws:lambda:us-east-1:396112814485:layer:yahoo-fin-package-tf:1", "arn:aws:lambda:us-east-1:396112814485:layer:openpyxl-tf:1", "arn:aws:lambda:us-east-1:396112814485:layer:s3fs-tf:1"]
    role_arn                                = dependency.moodys_roles.outputs.iam_role_arn
    # environment_variables                   = {secret_name = dependency.secret_name.outputs.secret_name,dynamodb_table = dependency.dynamodb_table.outputs.dynamodb_table_id, bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, date_column =	"monthly_date", file_name =	"moodys_monthly.csv", file_path	= "raw-data/moodys/data/monthly/", freq_code	= 128, gluejobname = "dev_krny_trnsf_moodys_tf", mapping_file_name = "moodys_mnemonics.csv", mapping_file_path = "raw-data/moodys/config/"  }
    environment_variables                   = { bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, gluejobname = dependency.job_name.outputs.glue_job_name[0], file_name_monthly =	"moodys_monthly.csv", file_name_quarterly =	"moodys_quarterly.csv", file_name_yearly	= "moodys_yearly.csv", file_prefix = "raw-data/moodys_188/manual_upload/", folder_path = "raw-data/moodys_188/data/", mapping_file_name	= "moodys_188_mnemonics.csv", mapping_file_path =	"raw-data/moodys_188/config/"}
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})
