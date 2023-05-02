region                 = "us-east-1"
bucket_name            = "devbucket006"
force_destroy          = "true"
attach_policy          = "true"
deny_insecure          = "true"
project                = "krny"
environment_class      = "dev"
object_lock            = false
lifecycle_rule_enabled = "true"
lifecycle_rule_prefix  = "log/"
#------rule-1-----
current_transition = [
  {
    days          = "30"
    storage_class = "GLACIER"
  }
]
expiration_days                        = "90"
block_public_acls       = "true"
block_public_policy     = "true"
ignore_public_acls      = "true"
restrict_public_buckets = "true"
owner="devops"
data_folders_list = ["one/dir1/dir2","two/dir3/dir4"]