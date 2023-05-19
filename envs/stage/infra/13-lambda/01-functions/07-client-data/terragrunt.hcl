# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-v1//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "client_data_iam_roles" {
#   config_path = "../../../07-iam/01-lambda_roles/08-client-data-roles"
#   mock_outputs = {
#     iam_role_arn = "arn:aws:iam:::123456789012::role/terraform"
#   }
# }

# dependency "pvt_subnet" {
#   config_path = "../../../01-vpc"
#   mock_outputs = {
#     private_subnets = ["subnet-1234"]
#   }
# }

# dependency "node18" {
#   config_path = "../../03-layers/07-node"
#   mock_outputs = {
#     id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
#   }
# }

# # dependency "s3_bucket_id" {
# #   config_path = "../../../s3/lambdacode//."
# #   mock_outputs = {
# #     s3_bucket_id = "bucket-name"
# #   }
# # }

# dependency "s3_bucket_id_external_sources" {
#   config_path = "../../../08-s3/01-externalsources"
#   mock_outputs = {
#     s3_bucket_id = "bucket-name"
#   }
# }

# dependency "security_group_id" {
#   config_path = "../../../02-securitygroup/01-lambda_sg"
#   mock_outputs = {
#     security_group_id = ["sg-1234"]
#   }
# }

# dependency "job_name" {
#   config_path = "../../../12-glue/jobs/transformation-covid"
#   mock_outputs = {
#     glue_job_name = ["jobname"]
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     function_name                           = "client-data-transformation"
#     s3_bucket                               = ":123456789012:-codebase"
#     s3_key                                  = "functions/client-data/lambda_function.zip"
#     runtime                                 = "nodejs18.x"
#     region                                  = "us-east-1"
#     memory_size                             = 3008
#     timeout                                 = 900
#     ephemeral_storage_size                  = 10000
#     description                             = "Lambda Function"
#     handler                                 = "index.handler"
#     create_current_version_allowed_triggers = true
#     layer_arns                              = [dependency.node18.outputs.id] //["arn:aws:lambda:us-east-1::123456789012::layer:node18-tf:1"]
#     role_arn                                = dependency.client_data_iam_roles.outputs.iam_role_arn
#     # environment_variables                   = { gluejobname = dependency.job_name.outputs.glue_job_name[0], bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, base_url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/", covidcases_filename = "covidcases.csv", prefix = "raw-data/covid/data/", url = "https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/us_data/time_series/time_series_covid19_vaccine_us.csv", vaccine_filename = "vaccinedata.csv" }
#     # vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
#     # vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id[0]]
# })

