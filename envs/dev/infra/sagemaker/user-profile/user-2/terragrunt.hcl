include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-sagemaker//."
}

dependency "domain_id" {
  config_path = "../../domain"
  mock_outputs = {
    sagemaker_domain_id = "d-111122223333"
  }
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    enable_sagemaker_user_profile    = true
    sagemaker_user_profile_name      = "krny-user-2"
    sagemaker_user_profile_domain_id = dependency.domain_id.outputs.sagemaker_domain_id
    sagemaker_user_profile_user_settings = {
      execution_role = "arn:aws:iam::287882505924:role/service-role/AmazonSageMaker-ExecutionRole-20230209T094668"
    }
  }
)