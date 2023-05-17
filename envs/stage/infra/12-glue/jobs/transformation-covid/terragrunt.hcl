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

dependency "glue_transformation_job_role" {
  config_path = "../../../07-iam/02-glue-roles/01-covid"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/role_name"
  }
}

# dependency "pvt_subnet" {
#   config_path = "../../../vpc"
#   mock_outputs = {
#     private_subnets = ["subnet-1234"]
#   }
# }


inputs = merge(
  local.common_vars.inputs,
  {
    jobs = [
      {
        name                            = "transformation-covid"
        description                     = "Glue transformation job for source covid"
        glue_version                    = "3.0"
        python_version                  = "3.9"
        #worker_type                     = "G.1X"
        execution_class                 = "STANDARD"
        role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
        #role_arn                        = "arn:aws:iam::287882505924:role/glue_transformation_job_role"
        max_retries                     = 0
        timeout                         = 2880
        max_concurrent_runs             = 1
        script_object_key               = "krny-spi-codebase-uat/glue/python-shell-scripts/krny_trnsf_covid.py"
        default_arguments =         {
                                "--enable-job-insights": "false",
                                "--job-language": "python",
                                "--job-type": "pythonshell",
                                "--max_capacity": "1",
                                "--TempDir": "s3://krny-spi-codebase-uat/glue/python-shell-scripts/temp-dir/",
                                "--enable-glue-datacatalog": "true",
                                "--library-set": "analytics",
                                "--bucket": "krny-spi-ext-sources-uat",
                                "--irm_file": "raw-data/covid/covidexternal/covidexternal3.csv",
                                "--crawler_cleaneddata": "cleaneddata-crawler",
                                "--crawler_transformeddata": "transformeddata-crawler",
                                "--folder": "raw-data/covid" ,
                                "--dpu": "1"        
                                }
                        
      }
    ]                        
  },
)
 

