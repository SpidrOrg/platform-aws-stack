output "key_arn" {
  value       = aws_kms_key.kms_key.arn
  description = "Key ARN"
}
output "key_id" {
  value       = aws_kms_key.kms_key.key_id
  description = "Key ID"
}
output "alias_arn" {
  value       = aws_kms_alias.kms_key_alias.arn
  description = "Alias ARN"
}
output "alias_name" {
  value       = aws_kms_alias.kms_key_alias.name
  description = "Alias name"
}