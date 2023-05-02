variable "region" {
  description = "This is the region in which resources will be created"
  type        = string
  default     = "ap-south-1"
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

################################################################################
# KMS KEY
################################################################################

variable "description" {
  type        = string
  default     = ""
  description = "The description of the key"
}
variable "alias" {
  type        = string
  default     = ""
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash"
}
variable "policy" {
  type        = string
  default     = ""
  description = "A valid KMS policy JSON document"
}
variable "key_usage" {
  type        = string
  default     = "ENCRYPT_DECRYPT"
  description = "Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY`."
}
variable "deletion_window_in_days" {
  type        = number
  default     = 30
  description = "The waiting period for key deletion"
}
variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Whether key rotation should be enabled or not"
}
variable "customer_master_key_spec" {
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`"
}
variable "multi_region" {
  type        = bool
  default     = false
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key"
}
