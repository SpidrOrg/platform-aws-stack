# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../_terraform_modules/terraform-aws-krny-sagemaker//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# dependency "pvt_subnet" {
#   config_path = "../../01-vpc"
#   mock_outputs = {
#     private_subnets = ["subnet-1234"]
#   }
# }

# dependency "vpc_id" {
#   config_path = "../../01-vpc"
#   mock_outputs = {
#     vpc_id = "vpc-11112222333344445"
#   }
# }

# dependency "security_group_id" {
#   config_path = "../../02-securitygroup/02-sagemaker_sg"
#   mock_outputs = {
#     security_group_id = ["sg-1234"]
#   }
# }

# dependency "sagemaker_roles" {
#   config_path = "../../07-iam/03-sagemaker-roles/01-domain-role"
#   mock_outputs = {
#     iam_role_arn = "arn:aws:iam::993809450021:role/terraform"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     enable_sagemaker_domain     = true
#     sagemaker_domain_name       = "krny-studio"
#     sagemaker_domain_auth_mode  = "IAM"
#     sagemaker_domain_vpc_id     = dependency.vpc_id.outputs.vpc_id
#     sagemaker_domain_subnet_ids = dependency.pvt_subnet.outputs.private_subnets
#     sagemaker_domain_default_user_settings = {
#     execution_role = dependency.sagemaker_roles.outputs.iam_role_arn//"arn:aws:iam::287882505924:role/service-role/AmazonSageMaker-ExecutionRole-20230209T094668"
#     security_groups = [dependency.security_group_id.outputs.security_group_id]
#     }
#   }
# )
