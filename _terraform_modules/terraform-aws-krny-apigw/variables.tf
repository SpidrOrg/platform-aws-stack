variable "region" {
  description = "This is the region in which resources will be created"
  type        = string
  default     = "us-east-1"
}
# variable "assume_role_arn" {
#   description = "ARN of the role to be assumed while creating resources"
#   type        = string
#   default     = ""
# }
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to be added to all resources"
}

variable "env" {
  description = "The name of the environment"
}

variable "project" {
  description = "The name of the project"
}

variable "apigateway_domain_name" {
  description = "API Gateway Domain name to add path mapping to"
}

variable "apigateway_domain_application_mapping_path" {
  description = "Application mapping path to add to {apigateway_domain_name}"
}

variable "rendered_api_swagger_config" {
  description = "Swagger API rendered"
}

# variable "logging_level" {
#   description = "API logging level"
# }

variable "api_throttling_burst_limit" {
  description = "API throttling burst limit"
}

variable "api_throttling_rate_limit" {
  description = "API throttling rate limit."
}
######

variable "minimum_compression_size" {
  description = "minimum compression size"
  default     = "-1"
}

variable "use_api_allowed_ips" {
  description = "Use API provided api_allowlist_ips or not"
  default     = true
}

variable "api_allowlist_ips" {
  description = "allowlist IPs"
  default     = ["0.0.0.0/0"]
}

variable "api_gateway_name" {
  default     = ""
  description = "api gateway name"
}

variable "endpoint_type" {
  default     = "EDGE"
  description = "API endpoint type: EDGE, REGIONAL or PRIVATE"
}

