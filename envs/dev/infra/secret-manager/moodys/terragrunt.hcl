include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-secret-manager//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "kms-arn" {
  config_path = "../../kms"
  mock_outputs = {
    key_arn = "kms-1234"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    secret_name = "krny-moodys-secret"
    kms_key_id  = dependency.kms-arn.outputs.key_arn
    secret_data = {
      accKey = "200E3684-2AB5-4F5C-BC85-8236F753F652",
      encKey = "52CC409B-14E4-454E-B143-7F55C7C09B19"
    }
  }
)
