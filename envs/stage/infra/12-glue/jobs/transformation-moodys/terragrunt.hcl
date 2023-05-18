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
  config_path = "../../../07-iam/02-glue-roles/06-moodys"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam:::123456789012::role/role_name"
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
        name                            = "transformation-moodys"
        description                     = "Glue transformation job for source moodys all"
        glue_version                    = "3.0"
        python_version                  = "3.9"
        execution_class                 = "STANDARD"
        role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
        max_retries                     = 0
        timeout                         = 2880
        max_concurrent_runs             = 1
        script_object_key               = "krny-spi-codebase-:ENV_NAME:/glue/python-shell-scripts/krny_trnsf_moodys.py"
        default_arguments =         {
                                "--enable-job-insights": "false",
                                "--job-language": "python",
                                "--job-type": "pythonshell",
                                "--max_capacity": 1.0,
                                "--TempDir": "s3://krny-spi-codebase-:ENV_NAME:/glue/python-shell-scripts/temp-dir/",
                                "--enable-glue-datacatalog": "true",
                                "--library-set": "analytics",
                                "--bucket": "krny-spi-ext-sources-:ENV_NAME:",
                                "--folder": "raw-data/moodys_all/data",
                                "--config": "raw-data/moodys_all/config"
                                "--crawler_cleaneddata": "cleaneddata-crawler",
                                "--crawler_transformeddata": "transformeddata-crawler"
                                }
      }
    ]
  },
)

