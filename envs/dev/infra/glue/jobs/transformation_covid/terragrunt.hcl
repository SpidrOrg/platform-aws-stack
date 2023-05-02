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
  config_path = "../../../iam/glue-roles/covid"
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
        name                            = "dev_krny_trnsf_covid_tf"
        description                     = "Glue transformation job for source covid"
        glue_version                    = "3.0"
        python_version                  = "3.9"
        worker_type                     = "G.1X"
        #execution_class                 = "STANDARD"
        role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
        #role_arn                        = "arn:aws:iam::287882505924:role/glue_transformation_job_role"
        max_retries                     = 0
        timeout                         = 2880
        max_concurrent_runs             = 1
        script_object_key               = "dev-krny-external-sources-tf/glue-python-shell-scripts/dev_krny_trnsf_covid.py"
        default_arguments =         {
                                "--enable-job-insights": "false",
                                "--job-language": "python",
                                "--job-type": "pythonshell",
                                "--max_capacity": 1.0,
                                "--TempDir": "s3://dev-krny-external-sources-tf/glue-python-shell-scripts/temp-dir/",
                                "--enable-glue-datacatalog": "true",
                                "--library-set": "analytics",
                                "--bucket": "dev-krny-external-sources-tf",
                                "--irm_file": "raw-data/covid/covidexternal/covidexternal3.csv",
                                "--crawler_cleaneddata": "crawler-cleaneddata-krny",
                                "--crawler_transformeddata": "crawler-transformeddata-krny",
                                "--folder": "raw-data/covid"  ,
                                "--dpu": "1"                    
                                }
                        
      }
    ]                        
  },
)
 

