provider "aws" {
  region = "us-east-1"
}

################################################################
# Create Glue Crawler 1
################################################################ 
resource "aws_glue_crawler" "crawler1" {
  database_name = var.database_name
  name          = var.crawler1.name
  description   = var.crawler1.description
  role          = var.crawler1.role_arn
  classifiers   = var.classifier1

  catalog_target {
    database_name = var.database_name
    tables        = var.crawler1.catalog_target_tables
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  lifecycle {
    ignore_changes = [configuration]
  }


}

################################################################
# Create Glue Crawler 2
################################################################ 
resource "aws_glue_crawler" "crawler2" {
  database_name = var.database_name
  name          = var.crawler2.name
  description   = var.crawler2.description
  role          = var.crawler2.role_arn
  classifiers   = var.classifier2

  catalog_target {
    database_name = var.database_name
    tables        = var.crawler2.catalog_target_tables
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  lifecycle {
    ignore_changes = [configuration]
  }
}
