# # enable_sagemaker_notebook_instance        = true
# # sagemaker_notebook_instance_name          = "test-krny"
# # sagemaker_notebook_instance_role_arn      = "arn:aws:iam::287882505924:role/sagemaker-role-tf"
# # sagemaker_notebook_instance_instance_type = "ml.t2.medium"

# # enable_sagemaker_code_repository = true
# # sagemaker_code_repository_name   = "testr"
# # sagemaker_code_repository_git_config = [{
# #   repository_url = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/testr"
# #   }

# # ] 


# enable_sagemaker_domain     = true
# sagemaker_domain_name       = "krny-studio"
# sagemaker_domain_auth_mode  = "IAM"
# sagemaker_domain_vpc_id     = "vpc-0f58d5e918f8fd45b"
# sagemaker_domain_subnet_ids = ["subnet-0a5a086932659c00e"]
# // optional
# # sagemaker_domain_kms_key_id=


# sagemaker_domain_default_user_settings = {
#   execution_role = "arn:aws:iam::287882505924:role/service-role/AmazonSageMaker-ExecutionRole-20230209T094668"
  
# }

# # enable_sagemaker_user_profile    = true
# # sagemaker_user_profile_name      = "krny-user"
# # sagemaker_user_profile_domain_id = "d-swaqtqip6fz3"
# # # sagemaker_user_profile_single_sign_on_user_value = "IAM"
# # sagemaker_user_profile_user_settings = {
# #   execution_role = "arn:aws:iam::287882505924:role/service-role/AmazonSageMaker-ExecutionRole-20230209T094668"
# # }