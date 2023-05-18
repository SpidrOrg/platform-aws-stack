
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-s3-folders//."
}

locals {
  # Automatically load input variables.
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    region                 = "us-east-1"
    bucket_name            = "krny-spi-codebase-:ENV_NAME:"
    force_destroy          = "true"
    attach_policy          = "true"
    deny_insecure          = "true"
    # project                = "krny"
    # environment_class      = "dev"
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
    # owner="devops"
    data_folders_list = ["functions/covid/","functions/fred/","functions/google_trends/","functions/ihs/","functions/moodys/","functions/similar_web/","functions/yahoo_function/","glue/python-shell-scripts","glue/python-shell-scripts/temp-dir/","glue/python-packages/","dashboards"]
  })
