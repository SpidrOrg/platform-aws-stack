 include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-glue/glue_jobs//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "s3_bucket_id_external_sources" {
  config_path = "../../../08-s3/01-externalsources//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "glue_transformation_job_role" {
  config_path = "../../../07-iam/02-glue-roles/09-meteostat-ingestion"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam:::123456789012::role/role_name"
  }
}


inputs = merge(
  local.common_vars.inputs,
  {
    jobs = [
      {
        name                            = "ingestion-meteostat"
        description                     = "Glue transformation job for source ingestion meteostat"
        glue_version                    = "3.0"
        python_version                  = "3.9"
        role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
        max_retries                     = 0
        timeout                         = 2880
        max_concurrent_runs             = 1
        script_object_key               = "krny-spi-codebase-:ENV_NAME:/glue/python-shell-scripts/krny-meteostat.py"
        default_arguments =         {
                                "--enable-job-insights": "false",
                                "--job-language": "python",
                                "--job-type": "pythonshell",
                                "--TempDir": "s3://krny-spi-codebase-:ENV_NAME:/glue/python-shell-scripts/temp-dir/",
                                "--enable-glue-datacatalog": "true",
                                "--extra-py-files": "s3://krny-spi-codebase-:ENV_NAME:/glue/python-packages/meteostat-1.6.5-py3-none-any.whl",
                                "--library-set": "analytics",
                                "--bucket": "krny-spi-ext-sources-:ENV_NAME:",
                                "--folder": "raw-data/meteostat/data/",
                                "--file_name": "Meteostat_clean",
                                "--gluejobname": "transformation-meteostat",
                                "--crawler_cleaneddata": "cleaneddata-crawler",
                                "--crawler_transformeddata": "transformeddata-crawler",
                                "--mapper": "s3://krny-spi-ext-sources-:ENV_NAME:/raw-data/meteostat/config/Mappedweatherstation_by_City.csv",
                                "--dpu": "1"
                                }
      }
    ]
  },
)


