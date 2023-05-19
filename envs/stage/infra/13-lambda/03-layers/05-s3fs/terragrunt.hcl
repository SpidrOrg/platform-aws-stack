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
    create_layer        = true
    # filename            = "s3fs.zip"
    s3_bucket           = "699967727511-codebase"
    s3_key              = "layers/s3fs.zip"
    layer_name          = "s3fs"
    compatible_runtimes = ["python3.9"]
})