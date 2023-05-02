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
  config_path = "../../../s3/externalsources//."
  mock_outputs = {
    s3_bucket_id = "bucket-name"
  }
}

dependency "glue_transformation_job_role" {
  config_path = "../../../iam/glue-roles/glue_transformation_job_role"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/role_name"
  }
}


inputs = merge(
  local.common_vars.inputs,
  {
    jobs = [
      {
        name                            = "dev_krny_meteostat_tf"
        description                     = "Glue transformation job for source ingestion meteostat"
        glue_version                    = "3.0"
        python_version                  = "3.9"
        worker_type                     = "G.1X"
        role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
        #role_arn                        = "arn:aws:iam::287882505924:role/glue_transformation_job_role"
        max_retries                     = 0
        timeout                         = 2880
        max_concurrent_runs             = 1
        script_object_key               = "dev-krny-external-sources-tf/raw-data/meteostat/script/dev-krny-meteostat.py"
        default_arguments =         {
                                "--enable-job-insights": "false",
                                "--job-language": "python",
                                "--job-type": "pythonshell",
                                "--max_capacity": 1.0,
                                "--TempDir": "s3://dev-krny-external-sources-tf/raw-data/meteostat/temporary/",
                                "--enable-glue-datacatalog": "true",
                                "--extra-py-files": "s3://dev-krny-external-sources-tf/python-packages/meteostat-1.6.5-py3-none-any.whl",
                                "--library-set": "analytics",
                                "--bucket": "dev-krny-external-sources-tf",
                                "--folder": "raw-data/meteostat/data/",
                                "--file_name": "Meteostat_clean",
                                "--gluejobname": "dev_krny_trnsf_meteostat_tf",
                                "--crawler_cleaneddata": "crawler-cleaneddata-krny",
                                "--crawler_transformeddata": "crawler-transformeddata-krny",
                                "--mapper": "s3://dev-krny-external-sources-tf/raw-data/meteostat/config/Mappedweatherstation_by_City.csv",
                                "--dpu": "1"
                                }
      }
    ]                        
  },
)
 
