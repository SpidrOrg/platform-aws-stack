include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-dynamodb//."
}

dependency "kms-arn" {
  config_path = "../../04-kms"
  mock_outputs = {
    key_arn = "arn:aws:kms:us-east-1:287882505924:key/0b3213d1-a19b-4425-b7a3-196cf3c58879"
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
    name         = "krny-google-trends"
    billing_mode = "PAY_PER_REQUEST" #On-demand
    hash_key     = "Category"
    server_side_encryption_enabled = true
    server_side_encryption_kms_key_arn = dependency.kms-arn.outputs.key_arn
    point_in_time_recovery_enabled = true
    attributes = [
        {
        name = "Category"
        type = "S"
        }
    ]
  })

