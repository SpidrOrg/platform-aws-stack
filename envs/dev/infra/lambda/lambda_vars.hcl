inputs = {
    region                                  = "us-east-1"
    memory_size                             = 3008
    timeout                                 = 900
    ephemeral_storage_size                  = 10000
    description                             = "Lambda Function"
    handler                                 = "lambda_function.lambda_handler"
    create_current_version_allowed_triggers = true
}
