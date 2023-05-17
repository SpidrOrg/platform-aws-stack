 include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-glue/glue_db_&_ctlg_tbl//."
}

locals {
  # Automatically load input variables..
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}



inputs = merge(
  local.common_vars.inputs,
  {
    catalog = {
  database_name        = "aws_athena"
  database_description = "Glue aws-athena Catalog database"
  tables = [
    {
      name                  = "tfdata_covid"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/covid"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_ihs_historical"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/ihs/data/ihs-historical"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_ihs_pp"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/ihs/data/ihs-pp"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_google_trends"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/google_trends"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_fred"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/fred"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_meteostat"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/meteostat"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_similar_web"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/similar_web"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_moodys"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/moodys_all/data"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_moodys_188"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/moodys_188/data"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_yahoo_finance"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/yahoo_finance"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "tfdata_mnemonics"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/transformed-data/mnemonics"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_covid"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/covid"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_ihs_historical"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/ihs/data/ihs-historical"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe" 
    },
    {
      name                  = "cldata_ihs_pp"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/ihs/data/ihs-pp"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe" 
    },
    {
      name                  = "cldata_google_trends"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/google_trends"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_fred"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/fred"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_meteostat"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/meteostat"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_similar_web"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/similar_web"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_moodys"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/moodys_all/data"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_moodys_188"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/moodys_188/data"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    },
    {
      name                  = "cldata_yahoo_finance"
      description           = ""
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://dev-krny-external-sources-tf/cleaned-data/yahoo_finance"
      input_format          = "org.apache.hadoop.mapred.TextInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
      ser_de_name           = ""
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }
  ]
}
  }
)