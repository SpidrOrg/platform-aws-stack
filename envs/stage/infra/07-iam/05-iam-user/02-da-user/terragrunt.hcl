include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-iam-user//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "policy_arn" {
  config_path = "../../04-lakeformation-role/01-lake-main-user"
  mock_outputs = {
    iam_policy_arn = "arn:aws:iam::111122223333:policy/name"
  }
}

dependency "policy_name" {
  config_path = "../../04-lakeformation-role/01-lake-main-user"
  mock_outputs = {
    iam_policy_name = "name"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    name = "da-grp"
    user_names = ["spi-da-1","spi-da-2"]
    policy_attachment = dependency.policy_name.outputs.iam_policy_name
    policy_arn = dependency.policy_arn.outputs.iam_policy_arn
  }
) 