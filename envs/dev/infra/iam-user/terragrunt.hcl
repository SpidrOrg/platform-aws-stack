/* include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../_terraform_modules/terraform-aws-krny-iam-user//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "policy_arn" {
  config_path = "../iam/lake-formation/"
  mock_outputs = {
    iam_policy_arn = "arn:aws:iam::111122223333:policy/name"
  }
}

dependency "policy_name" {
  config_path = "../iam/lake-formation/"
  mock_outputs = {
    iam_policy_name = "name"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    name = "spi-ext-sources-da-grp-tf"
    user_names = ["spi-da-1","spi-da-2"]
    policy_attachment = dependency.policy_name.outputs.iam_policy_name//"spi-ext-sources-da-policy-tf"
    policy_arn = dependency.policy_arn.outputs.iam_policy_arn//"arn:aws:iam::287882505924:policy/spi-ext-sources-da-policy-tf"
  }
) */