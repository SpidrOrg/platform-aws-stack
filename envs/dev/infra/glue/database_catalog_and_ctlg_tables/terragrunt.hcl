#  include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../../../_terraform_modules/terraform-aws-krny-glue/glue_db_&_ctlg_tbl//."
# }

# locals {
#   # Automatically load input variables
#   common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
# }



# inputs = merge(
#   local.common_vars.inputs,
#   {
#     catalog = {
#   database_name        = "aws_athena_tf"
#   database_description = "Glue aws-athena Catalog database"
#   tables = [
#     {
#       name                  = "tfd_covid_tf"
#       description           = ""
#       table_type            = "EXTERNAL_TABLE"
#       storage_location      = "s3://dev-krny-ext-sources/transform-data/covid"
#       input_format          = "org.apache.hadoop.mapred.TextInputFormat"
#       output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#       ser_de_name           = ""
#       serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
#     },
#     {
#       name                  = "tfd_ihs_tf"
#       description           = ""
#       table_type            = "EXTERNAL_TABLE"
#       storage_location      = "s3://dev-krny-ext-sources/transform-data/ihs"
#       input_format          = "org.apache.hadoop.mapred.TextInputFormat"
#       output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#       ser_de_name           = ""
#       serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
#     },
#     {
#       name                  = "tfd_google_trends_tf"
#       description           = ""
#       table_type            = "EXTERNAL_TABLE"
#       storage_location      = "s3://dev-krny-ext-sources/transform-data/google_trends"
#       input_format          = "org.apache.hadoop.mapred.TextInputFormat"
#       output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#       ser_de_name           = ""
#       serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
#     },
#     {
#       name                  = "tfd_fred_tf"
#       description           = ""
#       table_type            = "EXTERNAL_TABLE"
#       storage_location      = "s3://dev-krny-ext-sources/transform-data/fred"
#       input_format          = "org.apache.hadoop.mapred.TextInputFormat"
#       output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#       ser_de_name           = ""
#       serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
#     },
#     {
#       name                  = "tfd_meteostat_tf"
#       description           = ""
#       table_type            = "EXTERNAL_TABLE"
#       storage_location      = "s3://dev-krny-ext-sources/transform-data/meteostat"
#       input_format          = "org.apache.hadoop.mapred.TextInputFormatt"
#       output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#       ser_de_name           = ""
#       serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
#     },
#     {
#       name                  = "tfd_similar_web_tf"
#       description           = ""
#       table_type            = "EXTERNAL_TABLE"
#       storage_location      = "s3://dev-krny-ext-sources/transform-data/similar_web"
#       input_format          = "org.apache.hadoop.mapred.TextInputFormatt"
#       output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
#       ser_de_name           = ""
#       serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
#     }
#   ]
# }
#   }
# )