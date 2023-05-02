# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../_terraform_modules/terraform-aws-krny-glue/glue_crawler//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "glue_transformation_job_role" {
#   config_path = "../../iam/glue-roles/glue_transformation_job_role"
#   mock_outputs = {
#     iam_role_arn = "iam-1234"
#   }
# }


# dependency "database_catalog_table" {
#   config_path = "../database_catalog_and_ctlg_tables"
#   mock_outputs = {
#     database_name = "aws_athena_tf"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     crawler = {
#     name = "my-crawler"
#     description = "Transformed data Glue Crawler"
#     role_arn = dependency.glue_transformation_job_role.outputs.iam_role_arn  
#     catalog_target_tables = [
#         "tfd covid_tf",
#         "tfd_ihs_tf",
#         "tfd_google_trends_tf",
#         "tfd_fred_tf",
#         "tfd_meteostat_tf",
#         "tfd_similar_web_tf"
#                     ]
# }
 
# database_name = dependency.database_catalog_table.outputs.database_name

#   }
# )
