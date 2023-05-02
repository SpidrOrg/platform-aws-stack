output "secret_arn" {
  value = aws_secretsmanager_secret.git_secret.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.git_secret.name
}