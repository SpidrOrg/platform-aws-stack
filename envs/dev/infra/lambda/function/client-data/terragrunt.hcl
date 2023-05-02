include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-v1//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "covid_iam_roles" {
  config_path = "../../../iam/lambda_roles/covid_roles"
  mock_outputs = {
    iam_role_arn = "arn:aws:lambda:us-east-1:111122223312:function:test-1"
  }
}

dependency "pvt_subnet" {
  config_path = "../../../vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

# dependency "yahoo_fin_layers" {
#   config_path = "../../lambda-layers/layer-yahoo-fin//."
#   mock_outputs = {
#     lambda_layer_arn = "arn:aws:lambda:us-east-1:287882505924:layer:demo:14"
#   }
# }

dependency "s3_bucket_id" {
  config_path = "../../../s3/lambdacode//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "s3_bucket_id_external_sources" {
  config_path = "../../../s3/externalsources//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "security_group_id" {
  config_path = "../../../securitygroup/lambda_sg"
  mock_outputs = {
    security_group_id = ["sg-1234"]
  }
}

dependency "job_name" {
  config_path = "../../../glue/jobs/transformation_covid//."
  mock_outputs = {
    glue_job_name  = ["jobname"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    function_name                           = "client-data-transformation-tf"
    s3_bucket                               = dependency.s3_bucket_id.outputs.s3_bucket_id
    s3_key                                  = "functions/client-data/lambda_function.zip"
    runtime                                 = "nodejs18.x"
    region                                  = "us-east-1"
    memory_size                             = 3008
    timeout                                 = 900
    ephemeral_storage_size                  = 10000
    description                             = "Lambda Function"
    handler                                 = "index.handler"
    create_current_version_allowed_triggers = true
    layer_arns                              = ["arn:aws:lambda:us-east-1:287882505924:layer:node18essential1:9"]//[dependency.yahoo_fin_layers.outputs.lambda_layer_arn]
    role_arn                                = "arn:aws:iam::287882505924:role/client-data-transformation-lambda-service-role"//dependency.covid_iam_roles.outputs.iam_role_arn
    environment_variables                   = { gluejobname = dependency.job_name.outputs.glue_job_name[0], bucket = dependency.s3_bucket_id_external_sources.outputs.s3_bucket_id, base_url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/", covidcases_filename = "covidcases.csv", prefix = "raw-data/covid/data/", url = "https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/us_data/time_series/time_series_covid19_vaccine_us.csv", vaccine_filename = "vaccinedata.csv" }
    vpc_subnet_ids                          = dependency.pvt_subnet.outputs.private_subnets
    vpc_security_group_ids                  = [dependency.security_group_id.outputs.security_group_id]
})

