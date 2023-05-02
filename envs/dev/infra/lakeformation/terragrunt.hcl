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

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     # assume_role_arn = "arn:aws:iam::287882505924:role/admin_role_lake"
#     region          = "us-east-1"
#     s3_bucket_arn   = "arn:aws:s3:::krny-lakeformation-database"
#     admin_arn_list  = ["arn:aws:iam::287882505924:user/admin_lake","arn:aws:iam::287882505924:role/admin_role_lake"]//["arn:aws:iam::287882505924:role/admin_role_lake"]//
#     database_default_permissions = [
#       {
#         permissions = ["ALL"]
#         principal   = "IAM_ALLOWED_PRINCIPALS"
#       }
#     ]
#     lf_tags = {
#       env     = ["dev"]
#       project = ["test"]
#     }
#     resources = {
#       database = {
#         name = "aws-athena"
#         tags = {
#           env = "dev"
#         }
#       }
#     }
#     extra_tags = { "ManagedBy" : "Terraform", "Environment" : "Dev", "Account" : "Test" }
# })
