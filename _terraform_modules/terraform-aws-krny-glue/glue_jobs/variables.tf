variable "jobs" {
  description = "Jobs"
  type = list(object({
    name                = string
    description         = string
    glue_version        = optional(string, "3.0")
    execution_class     = optional(string, "STANDARD")
    role_arn            = string
    max_retries         = optional(number, 3)
    timeout             = optional(number, 2880)
    worker_type         = optional(string, "G.1X")
    number_of_workers   = optional(number, 10)
    max_concurrent_runs = optional(number, 1)
    script_object_key   = string
    default_arguments   = map(string)
  }))
}

# variable "job_tmp_bucket_name" {
#   description = "Job Temporary Bucket Name"
#   type        = string
#   default      = ""
# }