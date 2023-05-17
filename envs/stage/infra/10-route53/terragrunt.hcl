# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../_terraform_modules/terraform-aws-krny-route53//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }
 
# dependency "vpc-id" {
#   config_path = "../01-vpc"
#   mock_outputs = {
#     vpc_id = "vpc-0a78757115e951e16"
#   }
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
#     name        = "krny"
#     application = "test"
#     environment = "test"
#     label_order = ["name", "application"]
#     attributes  = ["1", "2"]
#     delimiter   = "-"
#     tags = {
#       Name        = "krny-zone"
#       Environment = "test"
#     }
#     private_enabled     = true
#     record_enabled      = false
#     public_enabled      = false
#     record_set_enabled  = false
#     failover_enabled    = false
#     latency_enabled     = false
#     geolocation_enabled = false
#     weighted_enabled    = false
#     domain_name         = "krny.com"
#     comment             = "krny code"
#     force_destroy       = true
#     delegation_set_id   = ""
#     vpc_id              = dependency.vpc-id.outputs.vpc_id
#     types               = []
#     ttls                = []
#     names               = []
#     values              = []
#     set_identifiers     = []
#     health_check_ids    = []
#     alias = {
#       names                   = []
#       zone_ids                = []
#       evaluate_target_healths = []
#     }
#     failover_routing_policies          = null
#     geolocation_routing_policies       = null
#     latency_routing_policies           = null
#     weighted_routing_policies          = null
#     multivalue_answer_routing_policies = []
#     allow_overwrites                   = []
#     enabled                            = false
#     secondary_vpc_id                   = ""
#     secondary_vpc_region               = ""
#     zone_id                            = ""
#   }
# )