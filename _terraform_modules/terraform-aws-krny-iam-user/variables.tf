variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where resources will be created."
}

variable "assume_role_arn" {
  type        = string
  default     = ""
  description = "The role to be assumed while creating resources."
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to add to resources."
}

variable "name" {
  type        = string
  default     = ""
  description = "Name of the role to be created"
}

variable "user_names" {
  type        = list(string)
  default     = []
  description = "Name of the role to be created"
}

variable "policy_attachment" {
  type        = string
  default     = ""
  description = "Name of the role to be created"
}

variable "policy_arn" {
  type        = string
  default     = ""
  description = "Name of the role to be created"
}