include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../_terraform_modules/terraform-aws-krny-vpc-endpoints//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}
#vpc-0677asdab275bhsd5 
dependency "vpc_id" {
  config_path = "../01-vpc"
  mock_outputs = {
    vpc_id = "vpc-0c00705c65f78f12c"
  }
}

dependency "vpc_private_route_table" {
  config_path = "../01-vpc"
  mock_outputs = {
    vpc_private_route_table = ["rtb-09b4216a15daca679"]
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    vpc_id     = dependency.vpc_id.outputs.vpc_id
    route_table_id = dependency.vpc_private_route_table.outputs.vpc_private_route_table[0]
    endpoints = [
      {
        service_name        = "com.amazonaws.us-east-1.s3"
        private_dns_enabled = true
        tags = {
          Name = "krny-s3-vpc-endpoints"
        }
      },
      {
        service_name        = "com.amazonaws.us-east-1.dynamodb"
        private_dns_enabled = true
        tags = {
          Name = "krny-dynamo-vpc-endpoints"
        }
      }
    ]
  })