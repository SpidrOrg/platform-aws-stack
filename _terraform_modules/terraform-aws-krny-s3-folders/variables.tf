# PROVIDER CONFIGURATION

variable "region" {
  type        = string
  description = "Provide region name"
}
variable "assume_role_arn" {
  description = "Assume role in which account to create"
  type        = string
  default     = ""
}
variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Add extra tags to your resource"
}

# S3 CONFIGURATION

variable "versioning" {
  type        = bool
  description = "Provide input to Enable versioning True / false"
  default     = true
}

variable "bucket_name" {
  type        = string
  description = "Provide S3-bucket name"
}
variable "force_destroy" {
  type        = bool
  default     = true
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
}
variable "attach_policy" {
  type        = bool
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  default     = true
}
variable "deny_insecure" {
  type        = bool
  default     = true
  description = "Controls if S3 bucket should have deny non-SSL transport policy attached"
}


# STATIC WEBSITE HOSTING CONFIGURATION

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(string)
  default     = {}
}

# TAGS FOR S3

variable "owner" {
  type        = string
  default     = "Xebia"
  description = "Owner of the s3 bucket being provisioned"
}
variable "environment_class" {
  type        = string
  default     = "dev"
  description = "Environment of the bucket (e.g dev, uat, prod)"
}

# ENCRYPTION

variable "disable_server_side_encryption" {
  type        = bool
  description = "Whether server side encryption should be disabled or not"
  default     = false
}
variable "kms_key_arn" {
  type        = string
  description = "Enter AWS KMS key arn for server side encryption"
  default     = null
}

# VERSIONING

# LIFECYLE RULE

variable "lifecycle_rule_enabled" {
  type        = bool
  description = "If you need to enable lifecycle rule set 'true', default its false"
  default     = false
}

variable "current_transition" {
  type = list(object({
    days          = number
    storage_class = string
  }))
  description = "Specify the current transition"
  default = [
    {
      days          = 30
      storage_class = "ONEZONE_IA"
    },
    {
      days          = 60
      storage_class = "GLACIER"
    }
  ]
}
variable "expiration_days" {
  type        = number
  default     = 30
  description = "Enter the expiration days for current transition"
}

# ACCESS CONTROL

variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public ACLs for this bucket."
}
variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
}
variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
}
variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
}

variable "data_folders_list" {
  description = "The list of data folder names"
  type        = list(string)
  default     = []
}

# variable "file_names" {
#   type = list(string)
# }