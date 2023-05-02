
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-s3-folders//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    region                 = "us-east-1"
    bucket_name            = "dev-krny-external-sources-tf"
    force_destroy          = "true"
    attach_policy          = "true"
    deny_insecure          = "true"
    project                = "krny"
    environment_class      = "dev"
    object_lock            = "false"
    lifecycle_rule_enabled = "false"
    lifecycle_rule_prefix  = "log/"
    versioning = "true"
    #------rule-1-----
    current_transition = [
    {
        days          = "30"
        storage_class = "GLACIER"
    }
    ]
    expiration_days         = "90"
    block_public_acls       = "true"
    block_public_policy     = "true"
    ignore_public_acls      = "true"
    restrict_public_buckets = "true"
    owner="devops"
    data_folders_list = ["glue-script/","glue-temporary/","python-packages/scripts/","raw-data/covid/covidcases/","raw-data/covid/covidexternal/","raw-data/covid/covidexternal/","raw-data/fred/","raw-data/google/","raw-data/ihs/","raw-data/meteostat/config/","raw-data/meteostat/data/","raw-data/meteostat/script/","raw-data/meteostat/temporary/","raw-data/moodys/","raw-data/similar_web/conversion_dashboard_clean/","raw-data/similar_web/conversion_dashboard_raw/","raw-data/similar_web/totaltraffic_sources_clean/","raw-data/similar_web/totaltraffic_sources_raw/","raw-data/yahoo_finance/","transform-data/fred/","transform-data/google/","transform-data/ihs/","transform-data/moody's/","transform-data/similar_web/","transform-data/yahoo_finance/","variable-treatment-file-mapper/"]
  })
