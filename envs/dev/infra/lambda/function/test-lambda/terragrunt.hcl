# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../../_terraform_modules/terraform-aws-krny-lambda-v1//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "yahoo_layers" {
#   config_path = "../../layers/yahoo_fin_package"
#   mock_outputs = {
#     lambda_layer_arn = "layer-1234"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     region = "us-east-1"
#     function_name = "test-2"
#     s3_bucket     = "krny-lambda-code"
#     s3_key        = "function-1/test.zip"
#     handler       = "test.lambda_handler"
#     runtime       = "python3.8"
#     memory_size   = 1024
#     timeout       = 30
#     role_arn      = "arn:aws:iam::287882505924:role/TerraformAdmin"
#     # function_name   = "test-lambda-simple"
#     # handler         = "index.lambda_handler"
#     # runtime         = "python3.8"
#     # # source_path                             = ["code/test.py"]
#     layer_arns                                  = [dependency.yahoo_layers.outputs.lambda_layer_arn]
#     # description                             = "test function"
#     # lambda_role                             = [dependency.iam-roles.outputs.iam_role_arn]
#     # create_current_version_allowed_triggers = true
#     # memory_size                             = 1024
#     # timeout                                 = 30
#     # s3_bucket                               = "test-lambda-code-1"
#     # s3_key                                  = "lambda/test.zip"
#     # s3_object_version                       = data.aws_s3_object.package.version_id
#     # s3_object_version = dependency.s3_object_version_id.outputs.id

#     # vpc_subnet_ids                          = ["subnet-04b7960f300312134", "subnet-0e3eece9a3ea6a19d"]
#     # vpc_security_group_ids                  = ["sg-0e8b4bb9f13739ffc", "sg-0f0ccbff7b9115cf3"]
#   })
#   # s3://krny-lambda-code/function-1/