variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "The name of the secret to create"
  type        = string
}

variable "kms_key_id" {
  description = "kms_key_id"
  type        = string
  default     = ""
}


variable "secret_data" {
  description = "The secret data to store"
  type        = map(string)
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to add to resources."
}


variable "assume_role_arn" {
  type        = string
  default     = ""
  description = "The role to be assumed while creating resources."
}