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
    filename            = "meteostat-1.6.5-py3-none-any.whl"
    layer_name          = "metostat"
    compatible_runtimes = ["python3.8"]
})