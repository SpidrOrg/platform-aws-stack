provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

data "template_file" "policy_document" {
  count    = var.create_policy ? 1 : 0
  template = file("${path.root}//${var.policy_path}")
  vars     = var.policy_vars
}

data "template_file" "role_document" {
  count    = var.create_role ? 1 : 0
  template = file("${path.root}//${var.assume_role_policy_path}")
  vars     = var.assume_role_policy_vars
}

################################################################################
# IAM Role
################################################################################

resource "aws_iam_role" "this" {
  count                 = var.create_role ? 1 : 0
  name                  = var.role_name
  max_session_duration  = var.max_session_duration
  description           = var.role_description
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.role_permissions_boundary_arn
  assume_role_policy    = data.template_file.role_document[0].rendered
}

resource "aws_iam_role_policy_attachment" "existing_policy_attachment" {
  count      = length(var.role_policy_arns) > 0 && var.create_role ? length(var.role_policy_arns) : 0
  role       = aws_iam_role.this[0].name
  policy_arn = element(var.role_policy_arns, count.index)
}

################################################################################
# IAM Policy
################################################################################

resource "aws_iam_policy" "this" {
  count       = var.create_policy ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  policy      = data.template_file.policy_document[0].rendered
}

resource "aws_iam_role_policy_attachment" "new_policy_attachment" {
  count      = var.create_policy && var.create_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

################################################################################
# IAM Role with OIDC
################################################################################

locals {
  aws_account_id = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.current.account_id
  urls = [
    for url in compact(distinct(var.provider_urls)) :
    replace(url, "https://", "")
  ]
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  count = var.create_oidc_role ? 1 : 0
  dynamic "statement" {
    for_each = local.urls
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals {
        type        = "Federated"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.aws_account_id}:oidc-provider/${statement.value}"]
      }
      dynamic "condition" {
        for_each = length(var.oidc_fully_qualified_subjects) > 0 ? local.urls : []
        content {
          test     = "StringEquals"
          variable = "${statement.value}:sub"
          values   = var.oidc_fully_qualified_subjects
        }
      }
      dynamic "condition" {
        for_each = length(var.oidc_subjects_with_wildcards) > 0 ? local.urls : []
        content {
          test     = "StringLike"
          variable = "${statement.value}:sub"
          values   = var.oidc_subjects_with_wildcards
        }
      }
    }
  }
}

resource "aws_iam_role" "oidc_role" {
  count                 = var.create_oidc_role ? 1 : 0
  name                  = var.oidc_role_name
  description           = var.oidc_role_description
  max_session_duration  = var.oidc_max_session_duration
  force_detach_policies = var.oidc_force_detach_policies
  assume_role_policy    = join("", data.aws_iam_policy_document.assume_role_with_oidc.*.json)
}

resource "aws_iam_role_policy_attachment" "oidc_attachment" {
  count      = var.create_oidc_role ? length(var.oidc_role_policy_arns) : 0
  role       = join("", aws_iam_role.oidc_role.*.name)
  policy_arn = var.oidc_role_policy_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "oidc_attachment_custom" {
  count      = var.create_oidc_role && var.create_policy ? 1 : 0
  role       = join("", aws_iam_role.oidc_role.*.name)
  policy_arn = aws_iam_policy.this[count.index].arn
}