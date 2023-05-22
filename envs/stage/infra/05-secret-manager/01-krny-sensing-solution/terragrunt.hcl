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
  config_path = "../../04-kms"
  mock_outputs = {
    key_arn = "arn:aws:kms:us-east-1:287882505924:key/0b3213d1-a19b-4425-b7a3-196cf3c58879"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    secret_name = "krny-sensing-solution-secret-11"
    kms_key_id  = dependency.kms-arn.outputs.key_arn
    secret_data = {
      key = "0637a1ff8dc238c2bfa9d5a13bce3b4f"
    }
  }
)
