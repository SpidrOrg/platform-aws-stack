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
    s3_bucket           = "699967727511-codebase"
    s3_key              = "layers/s3fs.zip"
    layer_name          = "s3fs"
    compatible_runtimes = ["python3.9"]
})
