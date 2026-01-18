# IAM Identity Center Permission Sets
# These permission sets are created in the management account and can be assigned to users/groups

resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.create_permission_sets ? var.permission_sets : {}

  instance_arn     = var.sso_instance_arn
  name             = each.key
  description      = each.value.description
  session_duration = each.value.session_duration

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = var.create_permission_sets ? {
    for item in flatten([
      for ps_key, ps_value in var.permission_sets : [
        for policy in ps_value.managed_policies : {
          key        = "${ps_key}-${policy}"
          ps_key     = ps_key
          policy_arn = policy
        }
      ]
    ]) : item.key => item
  } : {}

  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_key].arn
  managed_policy_arn = each.value.policy_arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = var.create_permission_sets ? {
    for ps_key, ps_value in var.permission_sets : ps_key => ps_value
    if ps_value.inline_policy != null
  } : {}

  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  inline_policy      = each.value.inline_policy
}

# Default Permission Sets (commonly used)
locals {
  default_permission_sets = var.create_default_permission_sets ? {
    AdministratorAccess = {
      description      = "Full administrative access to AWS services and resources"
      session_duration = "PT4H"
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      inline_policy    = null
    }
    ReadOnlyAccess = {
      description      = "Read-only access to AWS services and resources"
      session_duration = "PT8H"
      managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      inline_policy    = null
    }
    PowerUserAccess = {
      description      = "Full access except IAM and Organizations management"
      session_duration = "PT4H"
      managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      inline_policy    = null
    }
    SecurityAudit = {
      description      = "Security audit access for compliance reviews"
      session_duration = "PT8H"
      managed_policies = ["arn:aws:iam::aws:policy/SecurityAudit"]
      inline_policy    = null
    }
    ViewOnlyAccess = {
      description      = "View-only access to AWS services (more restrictive than ReadOnly)"
      session_duration = "PT8H"
      managed_policies = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
      inline_policy    = null
    }
    BillingAccess = {
      description      = "Access to billing and cost management"
      session_duration = "PT4H"
      managed_policies = ["arn:aws:iam::aws:policy/job-function/Billing"]
      inline_policy    = null
    }
  } : {}
}

resource "aws_ssoadmin_permission_set" "default" {
  for_each = var.create_permission_sets && var.create_default_permission_sets ? local.default_permission_sets : {}

  instance_arn     = var.sso_instance_arn
  name             = each.key
  description      = each.value.description
  session_duration = each.value.session_duration

  tags = merge(var.tags, {
    Name    = each.key
    Default = "true"
  })
}

resource "aws_ssoadmin_managed_policy_attachment" "default" {
  for_each = var.create_permission_sets && var.create_default_permission_sets ? {
    for item in flatten([
      for ps_key, ps_value in local.default_permission_sets : [
        for policy in ps_value.managed_policies : {
          key        = "${ps_key}-${replace(policy, "/", "-")}"
          ps_key     = ps_key
          policy_arn = policy
        }
      ]
    ]) : item.key => item
  } : {}

  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.default[each.value.ps_key].arn
  managed_policy_arn = each.value.policy_arn
}
