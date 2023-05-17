remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "319925118739-statefile"
    dynamodb_table = "tf-statelock"
    key            = "stage/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}







# terraform scan
/* terraform {
  after_hook "after_hook" {
    commands = ["plan"]
    execute  = ["terrascan", "scan", "--non-recursive", "-i", "terraform", "-t", "aws"]
  }
} */
