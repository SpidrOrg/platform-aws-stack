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
  config_path = "../../../07-iam/02-glue-roles/03-google"
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
        name                            = "transformation-google"
        description                     = "Glue transformation job for source google"
        glue_version                    = "3.0"
        python_version                  = "3.9"
        execution_class                 = "STANDARD"
        role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
        #role_arn                        = "arn:aws:iam::287882505924:role/glue_transformation_job_role"
        max_retries                     = 0
        timeout                         = 2880
        max_concurrent_runs             = 1
        script_object_key               = "krny-spi-codebase-uat/glue/python-shell-scripts/krny_trnsf_google.py"
        default_arguments =         {
                                "--enable-job-insights": "false",
                                "--job-language": "python",
                                "--job-type": "pythonshell",
                                "--max_capacity": 1.0,
                                "--TempDir": "s3://krny-spi-codebase-uat/glue/python-shell-scripts/temp-dir/",
                                "--enable-glue-datacatalog": "true",
                                "--bucket": "krny-spi-ext-sources-uat",
                                "--folder": "raw-data/google",
                                "--crawler_cleaneddata": "crawler-cleaneddata-krny",
                                "--crawler_transformeddata": "crawler-transformeddata-krny",
                                "--prefix" : "raw-data/google_trends1/1900-01-01/",
                                "--filepath": "cleaned-data/google_trends/",
                                "--library-set": "analytics"
                                }
      }
    ]                        
  },
)
 
