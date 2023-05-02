provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = var.event_rule_name
  description = var.event_rule_description
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = var.lambda_function_arn
}

resource "aws_lambda_permission" "eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}
