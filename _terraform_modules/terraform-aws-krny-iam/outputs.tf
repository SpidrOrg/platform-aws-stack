################################################################################
# IAM Role
################################################################################

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = var.create_role ? aws_iam_role.this[0].arn : null
}
output "iam_role_name" {
  description = "Name of IAM role"
  value       = var.create_role ? aws_iam_role.this[0].name : null
}

################################################################################
# IAM Policy
################################################################################

output "iam_policy_arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = var.create_policy ? aws_iam_policy.this[0].arn : null
}
output "iam_policy_name" {
  description = "The name of the policy."
  value       = var.create_policy ? aws_iam_policy.this[0].name : null
}

################################################################################
# OIDC Role
################################################################################

output "oidc_role_arn" {
  description = "ARN of IAM role"
  value       = var.create_oidc_role ? aws_iam_role.oidc_role[0].arn : null
}
output "oidc_role_name" {
  description = "Name of IAM role"
  value       = var.create_oidc_role ? aws_iam_role.oidc_role[0].name : null
}