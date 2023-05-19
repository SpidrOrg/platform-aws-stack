include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../_terraform_modules/terraform-aws-krny-event-bridge//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "function_arn" {
  config_path = "../../../01-functions/04-moodys/03-yearly"
  mock_outputs = {
    lambda_function_arn = "arn:aws:lambda:us-east-1:287882505924:function:test"
  }
}

# dependency "function_name" {
#   config_path = "../../../01-functions/04-moodys/03-yearly"
#   mock_outputs = {
#     function_name = "function_name"
#   }
# }

inputs = merge(
  local.common_vars.inputs,
  {
    lambda_function_name   = "ingestion-moodys-yearly" //dependency.function_name.outputs.function_name
    lambda_function_arn    = "arn:aws:lambda:us-east-1::123456789012::function:ingestion-moodys-yearly"//dependency.function_arn.outputs.lambda_function_arn
    event_rule_name        = "moodys_event_rule_yearly"
    event_rule_description = "A rule to trigger my lambda function on a schedule"
    schedule_expression    = "cron(0 0 10 JAN ? *)"
})
