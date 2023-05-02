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

variable "lambda_function_name" {
  type = string
}

variable "lambda_function_arn" {
  type = string
}

variable "event_rule_name" {
  type = string
}

variable "event_rule_description" {
  type = string
}

variable "schedule_expression" {
  type = string
}