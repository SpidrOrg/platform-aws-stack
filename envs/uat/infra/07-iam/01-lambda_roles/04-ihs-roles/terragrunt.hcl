include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-iam//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    create_role             = true
    role_name               = "ihs-func-role"
    assume_role_policy_path = "templates/assume_role_policy.json"

    // IAM Policy
    create_policy = true
    policy_name   = "ihs-func-policy"
    policy_path   = "templates/access_policy.json"
  }
)
