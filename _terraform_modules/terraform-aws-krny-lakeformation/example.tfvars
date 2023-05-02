region         = "us-east-1"
s3_bucket_arn  = "arn:aws:s3:::krny-lakeformation-database"
admin_arn_list = ["arn:aws:iam::287882505924:user/admin_lake"]
database_default_permissions = [
  {
    permissions = ["ALL"]
    principal   = "IAM_ALLOWED_PRINCIPALS"
  }
]
lf_tags = {
  env     = ["dev", "uat"]
  project = ["test"]
}
resources = {
  database = {
    name = "aws-athena"
    tags = {
      env = "dev"
    }
  }
}
extra_tags = { "ManagedBy" : "Terraform", "Environment" : "Dev", "Account" : "Test" }