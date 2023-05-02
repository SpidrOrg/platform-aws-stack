region = "us-east-1"
jobs = [
 {       
    name                            = "test_transformation_covid_tf"
    description                     = "Glue transformation job for source covid"
    glue_version                    = "3.0"
    python_version                  = "3.9"
    execution_class                 = "STANDARD"
   # role_arn                        = dependency.glue_transformation_job_role.outputs.iam_role_arn
    role_arn                        = "arn:aws:iam::287882505924:role/glue_transformation_job_rolee"
    max_retries                     = 0
    timeout                         = 2880
    worker_type                     = "G.1X"
    number_of_workers               = 4
    max_concurrent_runs             = 1
    script_object_key               = "bucket-extenalsources/python-packages/scripts/transformation_IHS.py"
    default_arguments =         {
                            "--enable-job-insights": "false",
                            "--job-language": "python",
                            "--job-type": "pythonshell",
                            "--TempDir": "s3://bucket-extenalsources/temp-dir/",
                            "--enable-glue-datacatalog": "true",
                            "--library-set": "analytics"
                            }
 }]