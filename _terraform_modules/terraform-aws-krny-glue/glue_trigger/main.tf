resource "aws_glue_trigger" "example" {
  name     = var.trigger_name
  schedule = var.schedule_expression
  type     = "SCHEDULED"

  actions {
    job_name = var.job_name
  }
}
