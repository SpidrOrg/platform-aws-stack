include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../_terraform_modules/terraform-aws-krny-cognito//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    name = "krny-terraform-pool-uat"
  }
)  