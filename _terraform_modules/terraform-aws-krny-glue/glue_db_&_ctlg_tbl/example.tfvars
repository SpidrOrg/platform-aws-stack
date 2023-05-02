catalog = {
  database_name        = "aws-athena"
  database_description = "Glue aws-athena Catalog database"
  tables = [
    {
      name                  = "table1"
      description           = "This is table 1"
      table_type            = "EXTERNAL_TABLE"
      storage_location      = "s3://my-bucket/table1"
      input_format          = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
      output_format         = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
      ser_de_name           = "my-serde"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }
  ]
}
