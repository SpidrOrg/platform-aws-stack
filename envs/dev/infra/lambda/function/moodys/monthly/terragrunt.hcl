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
  config_path = "../../../../s3/externalsources//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "s3_bucket_id" {
  config_path = "../../../../s3/lambdacode//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "moodys_roles" {
  config_path = "../../../../iam/lambda_roles/moodys_role"
  mock_outputs = {
    iam_role_arn = "iam-1234"
  }
}

# dependency "yahoo_fin_layers" {
#   config_path = "../../layers/dev_yahoo_fin_package"
#   mock_outputs = {
#     id = "layer-1234"
#   }
# }

# dependency "openpyxl_layers" {
#   config_path = "../../layers/dev_openpyxl"
#   mock_outputs = {
#     id = "layer-1234"
#   }
# }

# dependency "s3fs_layers" {
#   config_path = "../../layers/dev_s3fs"
#   mock_outputs = {
#     id = "layer-1234"
#   }
# }

dependency "pvt_subnet" {
  config_path = "../../../../vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

dependency "security_group_id" {
  config_path = "../../../../securitygroup/lambda_sg"
  mock_outputs = {
    security_group_id = ["sg-1234"]
  }
}

dependency "dynamodb_table" {
  config_path = "../../../../dynamodb/moodys"
  mock_outputs = {
    dynamodb_table_id = ["db-name"]
  }
}

dependency "secret_name" {
  config_path = "../../../../secret-manager/moodys/"
  mock_outputs = {
    secret_name = ["secret-name"]
  }
}

dependency "job_name" {
  config_path = "../../../../glue/jobs/transformation-moodys"
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}



inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "dev-krny-moodys-monthly-tf"
    s3_bucket                               = dependency.s3_bucket_id.outputs.s3_bucket_id
    s3_key                                  = "functions/moodys-monthly/lambda_function.py.zip"
    runtime                                 = "python3.8"
    # layer_arns                              = [dependency.yahoo_fin_layers.outputs.id, dependency.openpyxl_layers.outputs.id, dependency.s3fs_layers.outputs.id]
    layer_arns                              = ["arn:aws:lambda:us-east-1:287882505924:layer:request_s3fs_pandas:1"]
    role_arn                                = dependency.moodys_roles.outputs.iam_role_arn
    environment_variables                   = {secret_name = dependency.secret_name.outputs.secret_name,dynamodb_table = dependency.dynamodb_table.outputs.dynamodb_table_id, bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, date_column =	"monthly_date", file_name =	"moodys_monthly.csv", file_path	= "raw-data/moodys_all/data/monthly/", freq_code	= 128, gluejobname = dependency.job_name.outputs.glue_job_name[0], mapping_file_name = "moodys_all_mnemonics.csv", mapping_file_path = "raw-data/moodys_all/config/"  }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})
