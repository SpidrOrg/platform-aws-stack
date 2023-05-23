output "id" {
  description = "The ARN of the Lambda Layer with version"
  value       = try(aws_lambda_layer_version.lambda_layer.arn, "")
}
