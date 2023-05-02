provider "aws" {
  region = var.region
  default_tags {
    tags = var.extra_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

module "lake-formation" {
  source                       = "./modules"
  s3_bucket_arn                = var.s3_bucket_arn
  role_arn                     = var.role_arn
  catalog_id                   = var.catalog_id
  admin_arn_list               = var.admin_arn_list
  trusted_resource_owners      = var.trusted_resource_owners
  database_default_permissions = var.database_default_permissions
  table_default_permissions    = var.table_default_permissions
  lf_tags                      = var.lf_tags
  resources                    = var.resources
}