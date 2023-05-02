# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-triggers//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "function_arn" {
#   config_path = "../../function/ihs/"
#   mock_outputs = {
#     lambda_function_arn = "arn:aws:lambda:us-east-1:1111222233:function:test-2"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     lambda_function_arn = dependency.function_arn.outputs.lambda_function_arn
#     statement_id = "IHSAllowExecutionFromS3Bucket"
#     s3_bucket_arn = "arn:aws:s3:::dev-krny-ext-sources"
#     s3_bucket = "dev-krny-ext-sources"
#     filter_prefix = "raw-data/ihs/manual-upload/ihs-historical/"
#     filter_prefix_1 = "raw-data/ihs/manual-upload/ihs-pp/"
#     filter_suffix =".xlsx"
#     events = ["s3:ObjectCreated:*"]
# })
