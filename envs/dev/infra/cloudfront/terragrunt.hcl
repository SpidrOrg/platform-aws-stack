# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../_terraform_modules/terraform-aws-krny-cloudfront//."
# }

# dependency "s3" {
#   config_path = "../s3"
#   mock_outputs = {
#     bucket = "s3-1234"
#   }
# }

# dependency "lambda_edge" {
#   config_path = "../lambda_edge"
#   mock_outputs = {
#     arn = "arn-1234"
#   }
# }



# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }

# inputs = merge(
#   local.common_vars.inputs,
#   {
    

#     create_distribution = true
#     comment = "CloudFront distribution"
#     default_root_object = "index.html"
#     enabled = true
#     http_version = "http2"
#     is_ipv6_enabled = true
#     price_class = "PriceClass_All"
#     retain_on_delete = true
#     wait_for_deployment = true
#     tags = {
#       Environment = "dev"
#       Project = "Krny Sensing Project"
#     }

#     logging_config = {
#       bucket = "krny-sensing-logs-dev-tf.s3.amazonaws.com"
#       prefix = "logs/"
#       include_cookies = false
#     }

#     origin = {
#       "spi-platform.s3.us-east-1.amazonaws.com" = {
#         domain_name = "origin-krny-sensing-dev-tf.s3.amazonaws.com"
#         origin_id = "spi-platform.s3.us-east-1.amazonaws.com"
#         origin_path = ""
#         s3_origin_config = {}
#         custom_origin_config = {}
#         custom_header = []
#       }
#     }

#     origin_group = {}

#     default_cache_behavior = {
#       target_origin_id = "spi-platform.s3.us-east-1.amazonaws.com"
#       viewer_protocol_policy = "redirect-to-https"
#       allowed_methods = ["GET", "HEAD", "OPTIONS"]
#       cached_methods = ["GET", "HEAD"]
#       compress = false
#       field_level_encryption_id = null
#       smooth_streaming = false
#       trusted_signers = null
#       trusted_key_groups = null
#       cache_policy_id = null
#       origin_request_policy_id = null
#       min_ttl = 0
#       default_ttl = 3600
#       max_ttl = 86400
#       use_forwarded_values = true
#       query_string_cache_keys = []
#       headers = []
#       cookies_forward = "none"
#       cookies_whitelisted_names = null
#       lambda_function_association = {}
#       function_association = {}
#     }

#     create_origin_access_identity = true
#     origin_access_identities = {
#       "origin-1" = "CloudFront Origin Access Identity for origin 1"
#     }
        
#   }
# )  