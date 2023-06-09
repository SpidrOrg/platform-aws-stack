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
  config_path = "../../01-functions/08-google-trends/02-parent"
  mock_outputs = {
    lambda_function_arn = "arn:aws:lambda:us-east-1:111122223333:function:test-2"
  }
}

dependency "function_name" {
  config_path = "../../01-functions/08-google-trends/02-parent"
  mock_outputs = {
    function_name = "function-name"
  }
}

inputs = merge(
  local.common_vars.inputs,
  {
    lambda_function_name        = dependency.function_name.outputs.function_name
    lambda_function_arn         = dependency.function_arn.outputs.lambda_function_arn
    event_rule_name             = "fred_event_rule"
    event_rule_description      = "A rule to trigger yahoo function on a schedule i.e 30 days"
    schedule_expression         = "rate(30 days)"
})
