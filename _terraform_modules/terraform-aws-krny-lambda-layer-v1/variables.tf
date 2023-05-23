variable "region" {
  description = "This is the region in which resources will be created"
  type        = string
  default     = "us-east-1"
}
variable "assume_role_arn" {
  description = "ARN of the IAM role to be assumed while creating resources"
  type        = string
  default     = ""
}
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to associate to resources"
}

variable "s3_bucket" {
  description = "Lambda Layers bucket"
  type        = string
  default     = ""
}

variable "s3_key" {
  description = "Lambda Layers bucket path"
  type        = string
  default     = ""
}

variable "layer_name" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "compatible_runtimes" {
  description = "Lambda Function entrypoint in your code"
  type        = list(string)
  default     = []
}


# variable "filename" {
#   description = "Lambda Function entrypoint in your code"
#   type        = string
#   default     = ""
# }
