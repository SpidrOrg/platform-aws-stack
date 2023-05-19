include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../_terraform_modules/terraform-aws-krny-event-bridge//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "function_arn" {
  config_path = "../../01-functions/02-fred"
  mock_outputs = {
    lambda_function_arn = "arn:aws:lambda:us-east-1:111122223333:function:test-2"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    lambda_function_name   = "ingestion-fred"
    lambda_function_arn    = "arn:aws:lambda:us-east-1::123456789012::function:ingestion-fred"
    event_rule_name        = "fred-event-rule"
    event_rule_description = "A rule to trigger yahoo function on a schedule i.e 30 days"
    schedule_expression    = "rate(30 days)"
})
