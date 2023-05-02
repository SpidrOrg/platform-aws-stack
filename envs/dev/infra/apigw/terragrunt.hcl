include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../_terraform_modules/terraform-aws-krny-apigw//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    env                                        = "dev"
    project                                    = "krny"
    apigateway_domain_name                     = "dev-krny"
    apigateway_domain_application_mapping_path = "dev"
    rendered_api_swagger_config                = "dev"
    api_throttling_burst_limit                 = "450"
    api_throttling_rate_limit                  = "1000000"
  }
)
