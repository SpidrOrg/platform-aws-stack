################################################################
# Create Glue Job
################################################################ 
resource "aws_glue_job" "main" {
  count = length(var.jobs)

  name              = element(var.jobs.*.name, count.index)
  description       = element(var.jobs.*.description, count.index)
  glue_version      = element(var.jobs.*.glue_version, count.index)
  execution_class   = element(var.jobs.*.execution_class, count.index)
  max_retries       = element(var.jobs.*.max_retries, count.index)
  timeout           = element(var.jobs.*.timeout, count.index)
 # worker_type       = element(var.jobs.*.worker_type, count.index)
  #number_of_workers = element(var.jobs.*.number_of_workers, count.index)
  #max_capacity      = element(var.jobs.*.max_capacity, count.index)
  role_arn          = element(var.jobs.*.role_arn,count.index)
  

  #role_arn = var.job_role_arn

  execution_property {
    max_concurrent_runs = element(var.jobs.*.max_concurrent_runs, count.index)
  }

  command {
    script_location = "s3://${element(var.jobs.*.script_object_key, count.index)}"
    python_version = "3.9"
    name = "pythonshell"
  }

  default_arguments = merge(
    {
      "--job-bookmark-option": "job-bookmark-disable"
      "--enable-job-insights": "false"
      "--job-language": "python"
      "--job-type": "pythonshell"
      "--enable-glue-datacatalog": "true"
      "--library-set": "analytics"
    },
    element(var.jobs.*.default_arguments, count.index),
    {
      "--security-configuration": "your_security_configuration_name"
    }
  )
}
