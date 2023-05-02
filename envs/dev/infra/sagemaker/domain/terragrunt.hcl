include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-sagemaker//."
}

dependency "pvt_subnet" {
  config_path = "../../vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234"]
  }
}

dependency "vpc_id" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id = "vpc-11112222333344445"
  }
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    enable_sagemaker_domain     = true
    sagemaker_domain_name       = "krny-studio"
    sagemaker_domain_auth_mode  = "IAM"
    sagemaker_domain_vpc_id     = dependency.vpc_id.outputs.vpc_id
    sagemaker_domain_subnet_ids = dependency.pvt_subnet.outputs.private_subnets
    sagemaker_domain_default_user_settings = {
    execution_role = "arn:aws:iam::287882505924:role/service-role/AmazonSageMaker-ExecutionRole-20230209T094668"
    security_groups = ["sg-06773a7674c47fd1f","sg-0b7126688a4cf1d1d"]
    }
  }
)
