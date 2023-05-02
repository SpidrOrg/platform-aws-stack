include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-dynamodb//."
}

dependency "kms-arn" {
  config_path = "../../kms"
  mock_outputs = {
    key_arn = "kms-1234"
  }
}


locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    create_table = true
    name         = "dev_krny_fred"
    billing_mode = "PAY_PER_REQUEST" #On-demand
    hash_key     = "index"
    server_side_encryption_enabled = true
    server_side_encryption_kms_key_arn = dependency.kms-arn.outputs.key_arn
    point_in_time_recovery_enabled = true
    attributes = [
        {
        name = "index"
        type = "S"
        }
    ]
  })

