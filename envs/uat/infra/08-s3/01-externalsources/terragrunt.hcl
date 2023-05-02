
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
    bucket_name            = "krny-spi-ext-sources-uat"
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
    data_folders_list = ["raw-data","raw-data/covid/data/","raw-data/covid/covidexternal/","raw-data/fred/","raw-data/ihs/","raw-data/ihs/data/","raw-data/ihs/manual-upload/","raw-data/ihs/manual-upload/ihs-historical/","raw-data/ihs/manual-upload/ihs-pp/","raw-data/moodys/","raw-data/meteostat/config/","raw-data/meteostat/data/","raw-data/meteostat/script/","raw-data/similar_web/","raw-data/similar_web/manual_upload/","raw-data/similar_web/manual_upload/raw_conversion_dashboard/","raw-data/similar_web/manual_upload/raw_totaltraffic_sources/","cleaned-data/","raw-data/yahoo_finance/","transformed-data/","reference-data/ingestion/ihs","reference-data/ingestion/similarweb","reference-data/transformation/variable-treatment","reference-data/feature_no_ihs"]
  })
