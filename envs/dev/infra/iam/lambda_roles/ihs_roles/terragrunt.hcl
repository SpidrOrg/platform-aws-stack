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
    role_name               = "ihs_role"
    assume_role_policy_path = "templates/assume_role_policy.json"
    # role_policy_arns   = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
    // IAM Policy
    create_policy = true
    policy_name   = "ihs_policy"
    policy_path   = "templates/access_policy.json"
  }
)
