# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../_terraform_modules/terraform-aws-krny-lakeformation/modules//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "s3_bucket_arn" {
#   config_path = "../08-s3/03-lake-formation"
#   mock_outputs = {
#     s3_bucket_arn = "arn:aws:s3:::krny-lakeformation-database"
#   }
# }

# dependency "iam_policy_arn" {
#   config_path = "../07-iam/04-lakeformation-role/01-lake-main-user/"
#   mock_outputs = {
#     iam_policy_arn = "arn:aws:iam:::123456789012::policy/policy-name"
#   }
# }

# dependency "iam_user_arn" {
#   config_path = "../07-iam/05-iam-user/01-lakeformation-user"
#   mock_outputs = {
#     iam_user_arn = "arn:aws:iam:::123456789012::user/lakeuser"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     # assume_role_arn = "arn:aws:iam::287882505924:role/admin_role_lake"
#     region          = "us-east-1"
#     s3_bucket_arn   = dependency.s3_bucket_arn.outputs.s3_bucket_arn
#     admin_arn_list  = [dependency.iam_user_arn.outputs.iam_user_arn ] //, dependency.iam_policy_arn.outputs.iam_policy_arn]//["arn:aws:iam::287882505924:user/admin_lake","arn:aws:iam::287882505924:role/admin_role_lake"]//["arn:aws:iam::287882505924:role/admin_role_lake"]//
#     database_default_permissions = [
#       {
#         permissions = ["ALL"]
#         principal   = "IAM_ALLOWED_PRINCIPALS"
#       }
#     ]
#     lf_tags = {
#       env     = [":ENV_NAME:"]
#       project = ["krny"]
#     }
#     resources = {
#       database = {
#         name = "aws_athena"
#         tags = {
#           env = ":ENV_NAME:"
#         }
#       }
#     }
#     extra_tags = { "ManagedBy" : "Terraform", "Environment" : ":ENV_NAME:", "Account" : ":ENV_NAME:" }
# })
