variable "trigger_name" {
  description = "Name of the AWS Glue trigger"
  type        = string
}

variable "schedule_expression" {
  description = "Cron expression for the trigger schedule"
  type        = string
  default     = "cron(15 12 * * ? *)" # you can set a default value or leave it empty
}

variable "job_name" {
  description = "Name of the AWS Glue job to trigger"
  type        = string
}
