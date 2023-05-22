include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-layer//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    s3_bucket           = "699967727511-codebase"
    s3_key              = "layers/yahoo_fin_package.zip"
    layer_name          = "yahoo-fin-package"
    compatible_runtimes = ["python3.9"]
})
