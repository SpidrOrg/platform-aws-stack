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

dependency "covid_iam_roles" {
  config_path = "../../../07-iam/01-lambda_roles/01-covid-roles"
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

dependency "yahoo_fin_layers" {
  config_path = "../../03-layers/06-yahoo-fin-package"
  mock_outputs = {
    id = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
  }
}

# dependency "s3_bucket_id" {
#   config_path = "../../../s3/lambdacode//."
#   mock_outputs = {
#     s3_bucket_id = "bucket-name"
#   }
# }

dependency "s3_bucket_id_external_sources" {
  config_path = "../../../08-s3/01-externalsources"
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "security_group_id" {
  config_path = "../../../02-securitygroup/01-lambda_sg"
  mock_outputs = {
    security_group_id = ["sg-1234"]
  }
}

dependency "job_name" {
  config_path = "../../../12-glue/jobs/transformation-covid"
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  local.lambda_vars.inputs,
  {
    function_name                           = "ingestion-covid"
    s3_key                                  = "functions/covid/lambda_function.py.zip"
    runtime                                 = "python3.9"
    # layer_arns                              = ["arn:aws:lambda:us-east-1::123456789012::layer:yahoo-fin-package-tf:1"]
    layer_arns                              = [dependency.yahoo_fin_layers.outputs.id]
    role_arn                                = dependency.covid_iam_roles.outputs.iam_role_arn
    environment_variables                   = { gluejobname = dependency.job_name.outputs.glue_job_name[0], bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, base_url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/", covidcases_filename = "covidcases.csv", prefix = "raw-data/covid/data/", url = "https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/us_data/time_series/time_series_covid19_vaccine_us.csv", vaccine_filename = "vaccinedata.csv" }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id[0]]
})


