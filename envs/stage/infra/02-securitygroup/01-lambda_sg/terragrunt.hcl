 include {
  path = find_in_parent_folders()
 }

 terraform {
   source = "../../../../../_terraform_modules/terraform-aws-krny-sg//."
 }

 locals {
   # Automatically load input variables
   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
 }

 dependency "vpc_id" {
   config_path = "../../01-vpc"
   mock_outputs = {
     vpc_id = "vpc-0a78757115e951e16"
   }
 }

 inputs = merge(
   local.common_vars.inputs,
   {
     create_sg           = true
     vpc_id              = dependency.vpc_id.outputs.vpc_id
     name                = "lambda-sg"
     description         = "Lambda Security Group"
     ingress_rules       = ["http-80-tcp"]
     ingress_cidr_blocks = ["0.0.0.0/0"]
     egress_with_cidr_blocks = [
       {
         from_port   = 0
         to_port     = 65535
         protocol    = "tcp"
         description = "All outbound port is opened"
         cidr_blocks = "0.0.0.0/0"
       },
     ]
   }
 )