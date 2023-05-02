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

dependency "vpc-id" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-1234"
  }
}

/*dependency "vpc-private-route-table" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_private_route_table = ["rtb-1234"]
  }
}*/

#rtb-0585f1b7b11b91a03
inputs = merge(
  local.common_vars.inputs,
  {
    vpc_id     = dependency.vpc-id.outputs.vpc_id
  #  vpc_private_route_table = [dependency.vpc-private-route-table.outputs.vpc_private_route_table]
    route_table_id = "rtb-0585f1b7b11b91a03"
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

  

  #  vpc_name = "dev-workload"
  #  s3_service_name = "com.amazonaws.ap-south-1.s3"
  #  s3_endpoint_name = "s3_dev_workload_vpc_endpoint"
  #  route_table_ids = ["rtb-0b9a745f051917516","rtb-08649cb646edfcb1d","rtb-097d1095ef14bb617","rtb-098bfa1920d26c1ca","rtb-02be915dec1f784b8"]
  #  s3_vpc_endpoint_type = "Gateway"
  #  s3_private_dns_enabled = false