include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-layer-v1//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    s3_bucket           = ":123456789012:-codebase"
    s3_key              = "layers/openpyxl.zip"
    layer_name          = "openpyxl"
    compatible_runtimes = ["python3.9"]
})
