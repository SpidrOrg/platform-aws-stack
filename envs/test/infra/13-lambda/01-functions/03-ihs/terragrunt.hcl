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


dependency "s3_bucket_id_external_sources" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

# dependency "s3_bucket_id" {
#   config_path = "../../../s3/lambdacode//."
#   mock_outputs = {
#     s3_bucket_id = "bucket-name"
#   }
# }

dependency "ihs_roles" {
  config_path = "../../../07-iam/01-lambda_roles/04-ihs-roles"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::396112814485:role/terraform"
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
  config_path = "../../../01-vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

# dependency "security_group_id" {
#   config_path = "../../../02-securitygroup/01-lambda_sg"
#   mock_outputs = {
#     security_group_id = ["sg-1234"]
#   }
# }

dependency "job_name" {
  config_path = "../../../12-glue/jobs/transformation-ihs"
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "ingestion-ihs"
    s3_key                                  = "functions/ihs/lambda_function.py.zip"
    runtime                                 = "python3.9"
    # layer_arns                              = [dependency.yahoo_fin_layers.outputs.id, dependency.openpyxl_layers.outputs.id, dependency.s3fs_layers.outputs.id]
    #layer_arns                              = ["arn:aws:lambda:us-east-1:396112814485:layer:yahoo-fin-package-tf:1","arn:aws:lambda:us-east-1:396112814485:layer:openpyxl-tf:1","arn:aws:lambda:us-east-1:396112814485:layer:s3fs-tf:1"]
    role_arn                                = dependency.ihs_roles.outputs.iam_role_arn
    environment_variables                   = { bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id , file_name_PP = "Pricing and Purchasing Historical Price-Building Material_v1116", file_name_historical = "IHS_Economic_History_v1116", folder_path_PP = "raw-data/ihs/data/ihs-pp/", folder_path_historical = "raw-data/ihs/data/ihs-historical/", prefix_PP = "raw-data/ihs/manual-upload/ihs-pp/", prefix_historical = "raw-data/ihs/manual-upload/ihs-historical/", gluejobname = dependency.job_name.outputs.glue_job_name[0] }//gluejobname = dependency.job_name.outputs.glue_job_name[0] }
    # vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    # vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})
