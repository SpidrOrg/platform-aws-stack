variable "catalog" {
  description = "Catalog"
  type = object({
    database_name        = string
    database_description = string
    tables = list(object({
      name                  = string
      description           = string
      table_type            = optional(string, "EXTERNAL_TABLE")
      storage_location      = string
      input_format          = optional(string, "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat")
      output_format         = optional(string, "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat")
      ser_de_name           = string
      serialization_library = optional(string, "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe")
    }))
  })
}


