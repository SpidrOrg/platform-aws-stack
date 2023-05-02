provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

resource "aws_iam_group" "group" {
  name = var.name
}

locals {
  user_names = var.user_names
}

resource "aws_iam_user" "users" {
  count = length(local.user_names)
  name  = local.user_names[count.index]
  path  = "/"
}

resource "aws_iam_group_membership" "group_membership" {
  count = length(local.user_names)
  name  = aws_iam_group.group.name
  users = [aws_iam_user.users[count.index].name]
  group = aws_iam_group.group.name
}


resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = var.policy_attachment
  policy_arn = var.policy_arn
  groups     = [aws_iam_group.group.name]
}