 include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-glue/glue_trigger//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

#iam role dependency
# dependency "glue_transformation_job_role" {
#   config_path = "../../iam/glue-roles/glue_transformation_job_role"
#   mock_outputs = {
#     iam_role_arn = "iam-1234"
#   }
# }


inputs = merge(
  local.common_vars.inputs,
  {
    trigger_name = "ingestion_meteostat_trigger"
    schedule_expression = "cron(0 0 5 * ? *)" # At 12:00 AM, on day 5 of the month
    job_name = "ingestion-meteostat"
               
  },
)
 
