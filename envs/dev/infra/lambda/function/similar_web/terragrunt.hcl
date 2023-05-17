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
  config_path = "../../../s3/externalsources//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "s3_bucket_id" {
  config_path = "../../../s3/lambdacode//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "similar_web_roles" {
  config_path = "../../../iam/lambda_roles/similar_role"
  mock_outputs = {
    iam_role_arn = "arn:aws:lambda:us-east-1:111122223312:function:test-2"
  }
}

# dependency "yahoo_fin_layers" {
#   config_path = "../../layers/dev_yahoo_fin_package"
#   mock_outputs = {
#     id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:1"
#   }
# }

# dependency "openpyxl_layers" {
#   config_path = "../../layers/dev_openpyxl"
#   mock_outputs = {
#     id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:1"
#   }
# }

# dependency "s3fs_layers" {
#   config_path = "../../layers/dev_s3fs"
#   mock_outputs = {
#     id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:1"
#   }
# }

dependency "pvt_subnet" {
  config_path = "../../../vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

dependency "security_group_id" {
  config_path = "../../../securitygroup/lambda_sg"
  mock_outputs = {
    security_group_id = ["sg-1234"]
  }
}

dependency "job_name" {
  config_path = "../../../glue/jobs/transformation-similarweb//."
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "dev-krny-similar-web-tf"
    s3_bucket                               = dependency.s3_bucket_id.outputs.s3_bucket_id
    s3_key                                  = "functions/similar_web/lambda_function.py.zip"
    runtime                                 = "python3.9"
    # layer_arns                              = [dependency.yahoo_fin_layers.outputs.id, dependency.openpyxl_layers.outputs.id, dependency.s3fs_layers.outputs.id]
    layer_arns                              = ["arn:aws:lambda:us-east-1:287882505924:layer:yahoo_fin:1","arn:aws:lambda:us-east-1:287882505924:layer:openpyxl:1","arn:aws:lambda:us-east-1:287882505924:layer:s3fs:1"]
    role_arn                                = dependency.similar_web_roles.outputs.iam_role_arn
    environment_variables                   = { bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id , conversion_filename = "conversion_dashboard.csv", conversion_sheet = "Direct", gluejobname = dependency.job_name.outputs.glue_job_name[0], path = "raw-data/similar_web/data/", prefix_conversion = "raw-data/similar_web/manual_upload/raw_conversion_dashboard/", prefix_totaltraffic = "raw-data/similar_web/manual_upload/raw_totaltraffic_sources/", totaltraffic_filename = "totaltraffic_sources.csv" }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})
