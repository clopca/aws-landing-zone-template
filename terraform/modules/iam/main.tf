locals {
  permission_boundary = var.enable_permission_boundary ? var.permission_boundary_arn : null
}

resource "aws_iam_user" "break_glass" {
  count = var.create_break_glass_user ? 1 : 0

  name = var.break_glass_user_name
  path = var.break_glass_user_path

  tags = merge(var.tags, {
    Name      = var.break_glass_user_name
    Purpose   = "Break-glass emergency access"
    ManagedBy = "Terraform"
  })
}

resource "aws_iam_user_policy_attachment" "break_glass" {
  count = var.create_break_glass_user ? length(var.break_glass_user_policies) : 0

  user       = aws_iam_user.break_glass[0].name
  policy_arn = var.break_glass_user_policies[count.index]
}

resource "aws_iam_policy" "custom" {
  for_each = var.custom_policies

  name        = "${var.name_prefix}-${each.key}"
  description = each.value.description
  policy      = each.value.policy

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}"
  })
}

resource "aws_iam_service_linked_role" "this" {
  for_each = var.service_linked_roles

  aws_service_name = each.value.aws_service_name
  description      = each.value.description

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}"
  })
}

resource "aws_iam_account_password_policy" "this" {
  count = var.configure_password_policy ? 1 : 0

  minimum_password_length        = var.password_policy.minimum_password_length
  require_lowercase_characters   = var.password_policy.require_lowercase_characters
  require_uppercase_characters   = var.password_policy.require_uppercase_characters
  require_numbers                = var.password_policy.require_numbers
  require_symbols                = var.password_policy.require_symbols
  allow_users_to_change_password = var.password_policy.allow_users_to_change_password
  max_password_age               = var.password_policy.max_password_age
  password_reuse_prevention      = var.password_policy.password_reuse_prevention
  hard_expiry                    = var.password_policy.hard_expiry
}
