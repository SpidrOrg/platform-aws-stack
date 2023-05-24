variable "region" {
  description = "This is the region in which resources will be created"
  type        = string
  default     = "ap-south-1"
}
variable "assume_role_arn" {
  description = "ARN of the role to be assumed while creating resources"
  type        = string
  default     = ""
}
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to be added to all resources"
}

################################################################################
# ENDPOINTS
################################################################################

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
}

variable "endpoints" {
  description = "A list of interface and/or gateway endpoints containing their properties and configurations"
  type        = list(any)
  default     = []
}
variable "additional_security_group_ids" {
  description = "Additional security group IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}
variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}

variable "route_table_id" {
  description = "The ID of the route table to associate with the S3 Gateway endpoint"
  type        = string
  default     = ""
}
