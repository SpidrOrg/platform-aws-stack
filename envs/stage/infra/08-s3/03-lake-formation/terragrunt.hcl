
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
    bucket_name            = "krny-spi-:123456789012:-lakeformation-:ENV_NAME:"
    force_destroy          = "true"
    attach_policy          = "true"
    deny_insecure          = "true"
    object_lock            = "false"
    lifecycle_rule_enabled = "false"
    lifecycle_rule_prefix  = "log/"
    versioning             = "true"
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
    data_folders_list       = []
})
