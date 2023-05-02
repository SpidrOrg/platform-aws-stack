output "iam_user_arn" {
  description = "Name of IAM User ARN"
  value       = aws_iam_user.users[0].arn
}

output "iam_user_name" {
  description = "Name of IAM User Name"
  value       = aws_iam_user.users[0].name
}