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

# inputs = merge(
#     local.common_vars.inputs,    
#     {
#     description         = "Request S3 fs Pandas library"
#     create_layer        = true
#     filename            = "layers_data/request_s3fs_pandas.zip"
#     source_path         = ["layers_data/request_s3fs_pandas.zip"]
#     layer_name          = "test_request_s3_fs_pandas_tf"
#     compatible_runtimes = ["python3.8"]
# })

inputs = merge(
    local.common_vars.inputs,    
    {
    create_layer        = true
    s3_bucket           = "699967727511-codebase"
    s3_key              = "layers/request_s3_fs_pandas.zip"
    layer_name          = "request_s3_fs_pandas"
    compatible_runtimes = ["python3.8"]
})