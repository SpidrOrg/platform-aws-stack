database_name = "aws_athena"

crawler1 = {
  name                  = "transformeddata_crawler"
  description           = "transformeddata Glue Crawler"
  role_arn              = "arn:aws:iam::123456789012:role/my-role"
  catalog_target_tables = ["table1", "table2"]
}

crawler2 = {
  name                  = "cleaneddata_crawler"
  description           = "cleaneddata Glue Crawler"
  role_arn              = "arn:aws:iam::123456789012:role/my-role"
  catalog_target_tables = ["table3", "table4"]
}
