# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../../_terraform_modules/terraform-aws-krny-sagemaker//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "domain_id" {
#   config_path = "../../01-domain"
#   mock_outputs = {
#     sagemaker_domain_id = "d-111122223333"
#   }
# }

# dependency "sagemaker-user-roles" {
#   config_path = "../../../07-iam/03-sagemaker-roles/02-user-profile-role/user-2"
#   mock_outputs = {
#     iam_role_arn = "arn:aws:iam::993809450021:role/terraform"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     enable_sagemaker_user_profile    = true
#     sagemaker_user_profile_name      = "krny-user-2"
#     sagemaker_user_profile_domain_id = dependency.domain_id.outputs.sagemaker_domain_id
#     sagemaker_user_profile_user_settings = {
#       execution_role = dependency.sagemaker-user-roles.outputs.iam_role_arn//"arn:aws:iam::287882505924:role/service-role/AmazonSageMaker-ExecutionRole-20230209T094668"
#     }  
#   }
# )