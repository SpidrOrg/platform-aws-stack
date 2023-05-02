variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region in which resources are to be created"
}
variable "assume_role_arn" {
  type        = string
  default     = ""
  description = "ARN of the IAM role to be assumed while creating the resources"
}
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to associate with resources"
}

################################################################################
# IAM ROLE
################################################################################

variable "create_role" {
  type        = bool
  default     = false
  description = "Whether to create an IAM role"
}
variable "role_name" {
  type        = string
  default     = ""
  description = "Name of the role to be created"
}
variable "max_session_duration" {
  type        = number
  default     = 3600
  description = "Maximum session duration (in seconds) that you want to set for the role"
}
variable "role_description" {
  type        = string
  default     = ""
  description = "Description of the role"
}
variable "force_detach_policies" {
  type        = bool
  default     = true
  description = "Whether to force detaching any policies the role has before destroying it"
}
variable "role_permissions_boundary_arn" {
  type        = string
  default     = ""
  description = "ARN of the policy that is used to set the permissions boundary for the role"
}
variable "assume_role_policy_path" {
  type        = string
  default     = ""
  description = "Path of the assume role policy to be applied to the role"
}
variable "assume_role_policy_vars" {
  type        = map(string)
  default     = {}
  description = "Assume role policy variables to substitue in policy document(if any)"
}
variable "role_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs of existing policies to associate with the role"
}

################################################################################
# IAM POLICY
################################################################################

variable "create_policy" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy or not"
}
variable "policy_name" {
  type        = string
  default     = ""
  description = "Name of the policy"
}
variable "policy_description" {
  type        = string
  default     = ""
  description = "Description of the policy"
}
variable "policy_path" {
  type        = string
  default     = ""
  description = "The path of the policy document to be used to create policy"
}
variable "policy_vars" {
  type        = map(string)
  default     = {}
  description = "Policy variables to substitue in policy document(if any)"
}

################################################################################
# IAM ROLE WITH OIDC
################################################################################

variable "create_oidc_role" {
  type        = bool
  default     = false
  description = "Whether to create OIDC role"
}
variable "oidc_role_name" {
  type        = string
  default     = ""
  description = "Name of the OIDC role"
}
variable "oidc_role_description" {
  type        = string
  default     = ""
  description = "Description of the OIDC role"
}
variable "oidc_max_session_duration" {
  type        = number
  default     = 3600
  description = "Maximum session duration (in seconds) that you want to set for the OIDC role"
}
variable "oidc_force_detach_policies" {
  type        = bool
  default     = true
  description = "Whether to force detaching any policies the OIDC role has before destroying it"
}
variable "oidc_role_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs of IAM policies to attach to OIDC role"
}

################################################################################
# OIDC POLICY
################################################################################

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "The AWS account ID where the OIDC provider lives, leave empty to use the account for the AWS provider"
}
variable "provider_urls" {
  type        = list(string)
  default     = []
  description = "List of URLs of the OIDC providers"
}
variable "oidc_fully_qualified_subjects" {
  type        = set(string)
  default     = []
  description = "The fully qualified OIDC subjects to be added to the role policy"
}
variable "oidc_subjects_with_wildcards" {
  type        = set(string)
  default     = []
  description = "The OIDC subject using wildcards to be added to the role policy"
}