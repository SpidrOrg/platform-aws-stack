region      = "ap-south-1"
common_tags = { "Environmet" : "Dev" }
create_distribution = true
comment = "Example CloudFront distribution"
default_root_object = "index.html"
enabled = true
http_version = "http2"
is_ipv6_enabled = true
price_class = "PriceClass_100"
retain_on_delete = true
wait_for_deployment = true
tags = {
  Environment = "dev"
  Project = "Example Project"
}

logging_config = {
  bucket = "example-logs-dev.s3.amazonaws.com"
  prefix = "logs/"
  include_cookies = false
}

origin = {
  "example-origin-1" = {
    domain_name = "example-origin-dev-delight.s3.amazonaws.com"
    origin_id = "example-origin-1"
    origin_path = ""
    s3_origin_config = {}
    custom_origin_config = {}
    custom_header = []
  }
}

origin_group = {}

default_cache_behavior = {
  target_origin_id = "example-origin-1"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods = ["GET", "HEAD", "OPTIONS"]
  cached_methods = ["GET", "HEAD"]
  compress = false
  field_level_encryption_id = null
  smooth_streaming = false
  trusted_signers = null
  trusted_key_groups = null
  cache_policy_id = null
  origin_request_policy_id = null
  min_ttl = 0
  default_ttl = 3600
  max_ttl = 86400
  use_forwarded_values = true
  query_string_cache_keys = []
  headers = []
  cookies_forward = "none"
  cookies_whitelisted_names = null
  lambda_function_association = {}
  function_association = {}
}

create_origin_access_identity = true
origin_access_identities = {
  "example-origin-1" = "Example CloudFront Origin Access Identity for origin 1"
}
