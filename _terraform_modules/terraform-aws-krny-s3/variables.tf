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
variable "object_lock" {
  type        = bool
  default     = false
  description = "If you want to enable object lock, by default its disabled"
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
  description = "Owner of the s3 bucket being provisioned"
}
variable "environment_class" {
  type        = string
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

variable "versioning" {
  type        = bool
  description = "Provide input to Enable versioning True / false"
  default     = true
}

# REPLICATION

variable "enable_replication" {
  type        = bool
  description = "Whether replication should be enabled for s3 bucket or not"
  default     = true
}
variable "replication_region" {
  type        = string
  description = "Provide region name where we need to replicate"
  default     = "ap-southeast-1"
}

# LIFECYLE RULE

variable "lifecycle_rule_enabled" {
  type        = bool
  description = "If you need to enable lifecycle rule set 'true', default its false"
  default     = false
}
variable "lifecycle_rule_prefix" {
  type        = string
  description = "Enter lifecycle rule prefix"
  default     = "log"
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
variable "noncurrent_version_transition" {
  type = list(object({
    days          = number
    storage_class = string
  }))
  description = "specify the non-current version transition"
  default = [
    {
      days          = 30
      storage_class = "STANDARD_IA"
    },
    {
      days          = 60
      storage_class = "ONEZONE_IA"
    },
    {
      days          = 90
      storage_class = "GLACIER"
    }
  ]
}
variable "noncurrent_version_expiration_days" {
  type        = number
  default     = 30
  description = "Enter the noncurrent version expiration days"
}
variable "abort_incomplete_multipart_upload_days" {
  type        = number
  description = "Number of days to abort incomplete multipart upload"
  default     = 7
}

# LOG BUCKET

variable "log_bucket" {
  type        = bool
  description = "If you want log bucket put as true"
  default     = false
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

# VPC ENDPOINT

variable "vpc_endpoint" {
  default     = false
  type        = bool
  description = "Set to true if want to create a S3 VPC endpoint"
}
variable "vpc_id" {
  type        = string
  description = "Provide vpc_id"
  default     = ""
}
variable "vpc_endpoint_name" {
  type        = string
  description = "Name of the vpc_endpoint"
  default     = ""
}
variable "route_table_id" {
  type        = string
  description = "Provide Private route_table_id"
  default     = ""
}

# S3 METRICS

variable "metrics" {
  type = list(object({
    name   = string
    prefix = string
    tags   = map(string)
  }))
  default     = []
  description = "The s3 bucket metrics you want to create"
}

# S3 sub folders
variable "data_folders_list" {
  description = "The list of data folder names"
  type        = list(string)
  default     = []
}
