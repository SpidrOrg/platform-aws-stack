output "base_url" {
  value = aws_api_gateway_deployment.deploy_api.invoke_url
}

output "api_name" {
  value = "${var.project}-apigateway-${var.env}"
}

output "api_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "api_resource_policy_json" {
  value = data.template_file.api_policy_json.rendered
}

output "api_allowlist_ips" {
  value = var.api_allowlist_ips
}

output "api_allowlist_ips_enabled" {
  value = var.use_api_allowed_ips
}

output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

