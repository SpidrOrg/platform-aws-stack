include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../_terraform_modules/terraform-aws-krny-vpc//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

inputs = merge(
  local.common_vars.inputs,
  {
    name = "sensing-solution-vpc"
    cidr = "10.0.0.0/16"
    public_subnets = [{
      "name"              = "krny-ss-public-1a",
      "cidr_block"        = "10.0.0.0/20",
      "availability_zone" = "us-east-1a",
      "tags" = {
        "Type" = "Public"
      }
      },
      {
        "name"              = "krny-ss-public-1b",
        "cidr_block"        = "10.0.16.0/20",
        "availability_zone" = "us-east-1b",
        "tags" = {
          "Type" = "Public"
        }
      }
    ]
    private_subnets = [
      {
        "name"              = "krny-ss-private-1a",
        "cidr_block"        = "10.0.32.0/20",
        "availability_zone" = "us-east-1a",
        "tags" = {
          "Type" = "Private"
        }
      },
      {
        "name"              = "krny-ss-private-1b",
        "cidr_block"        = "10.0.48.0/20",
        "availability_zone" = "us-east-1b"
        "tags" = {
          "Type" = "Private"
        }
      }
    ]
    create_igw                    = true
    enable_nat_gateway            = true
    single_nat_gateway            = true
    create_public_route           = true
    manage_default_security_group = true
    # default_security_group_ingress = [
    #   {
    #     protocol  = -1
    #     self      = true
    #     from_port = 0
    #     to_port   = 0
    #   },
    #   {
    #     cidr_blocks = "10.53.61.0/24"
    #     from_port   = "0"
    #     to_port     = "0"
    #     protocol    = "-1"
    #     description = "allow access to public vpc"
    #   }
    # ]
    # default_security_group_egress = [
    #   {
    #     cidr_blocks = "0.0.0.0/0"
    #     from_port   = "0"
    #     to_port     = "0"
    #     protocol    = "-1"
    #   }
    # ]
  }
)
