# Lambda Layer
output "lambda_layer_arn" {
  description = "The ARN of the Lambda Layer with version"
  value       = try(module.lambda_layer_local.lambda_layer_arn, "")
}