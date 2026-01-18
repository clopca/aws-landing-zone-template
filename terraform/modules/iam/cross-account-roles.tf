# Cross-Account IAM Roles
# These roles allow trusted accounts to assume roles in this account

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cross_account_trust" {
  for_each = var.create_cross_account_roles ? var.cross_account_roles : {}

  statement {
    sid     = "AllowCrossAccountAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [for account_id in var.trusted_account_ids : "arn:aws:iam::${account_id}:root"]
    }

    # Optional: Add condition for MFA
    dynamic "condition" {
      for_each = var.require_mfa_for_cross_account ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_role" "cross_account" {
  for_each = var.create_cross_account_roles ? var.cross_account_roles : {}

  name                 = "${var.name_prefix}-${each.key}"
  description          = each.value.description
  assume_role_policy   = data.aws_iam_policy_document.cross_account_trust[each.key].json
  max_session_duration = each.value.max_session_duration
  permissions_boundary = local.permission_boundary

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}"
  })
}

resource "aws_iam_role_policy_attachment" "cross_account_managed" {
  for_each = var.create_cross_account_roles ? {
    for item in flatten([
      for role_key, role_value in var.cross_account_roles : [
        for policy in role_value.managed_policies : {
          key        = "${role_key}-${replace(policy, "/", "-")}"
          role_key   = role_key
          policy_arn = policy
        }
      ]
    ]) : item.key => item
  } : {}

  role       = aws_iam_role.cross_account[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "cross_account_inline" {
  for_each = var.create_cross_account_roles ? {
    for role_key, role_value in var.cross_account_roles : role_key => role_value
    if role_value.inline_policy != null
  } : {}

  name   = "${var.name_prefix}-${each.key}-inline"
  role   = aws_iam_role.cross_account[each.key].id
  policy = each.value.inline_policy
}

# Default Cross-Account Roles (commonly used)
locals {
  default_cross_account_roles = var.create_default_cross_account_roles ? {
    OrganizationAccountAccessRole = {
      description          = "Role for organization management account access"
      managed_policies     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      inline_policy        = null
      max_session_duration = 3600
    }
    SecurityAuditRole = {
      description          = "Role for security team cross-account auditing"
      managed_policies     = ["arn:aws:iam::aws:policy/SecurityAudit"]
      inline_policy        = null
      max_session_duration = 3600
    }
    ReadOnlyRole = {
      description          = "Role for read-only cross-account access"
      managed_policies     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      inline_policy        = null
      max_session_duration = 3600
    }
  } : {}
}

data "aws_iam_policy_document" "default_cross_account_trust" {
  for_each = var.create_cross_account_roles && var.create_default_cross_account_roles ? local.default_cross_account_roles : {}

  statement {
    sid     = "AllowCrossAccountAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [for account_id in var.trusted_account_ids : "arn:aws:iam::${account_id}:root"]
    }

    dynamic "condition" {
      for_each = var.require_mfa_for_cross_account ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_role" "default_cross_account" {
  for_each = var.create_cross_account_roles && var.create_default_cross_account_roles && length(var.trusted_account_ids) > 0 ? local.default_cross_account_roles : {}

  name                 = each.key
  description          = each.value.description
  assume_role_policy   = data.aws_iam_policy_document.default_cross_account_trust[each.key].json
  max_session_duration = each.value.max_session_duration
  permissions_boundary = local.permission_boundary

  tags = merge(var.tags, {
    Name    = each.key
    Default = "true"
  })
}

resource "aws_iam_role_policy_attachment" "default_cross_account_managed" {
  for_each = var.create_cross_account_roles && var.create_default_cross_account_roles && length(var.trusted_account_ids) > 0 ? {
    for item in flatten([
      for role_key, role_value in local.default_cross_account_roles : [
        for policy in role_value.managed_policies : {
          key        = "${role_key}-${replace(policy, "/", "-")}"
          role_key   = role_key
          policy_arn = policy
        }
      ]
    ]) : item.key => item
  } : {}

  role       = aws_iam_role.default_cross_account[each.value.role_key].name
  policy_arn = each.value.policy_arn
}
