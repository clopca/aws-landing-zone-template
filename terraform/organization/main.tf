data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_organizations_organization" "main" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "ram.amazonaws.com",
    "sso.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "account.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]

  feature_set = "ALL"
}

locals {
  root_ou_id = aws_organizations_organization.main.roots[0].id

  ou_parent_map = {
    for k, v in var.organizational_units : k => (
      v.parent == "Root" ? local.root_ou_id : aws_organizations_organizational_unit.ous[v.parent].id
    )
  }

  ous_first_level = {
    for k, v in var.organizational_units : k => v
    if v.parent == "Root"
  }

  ous_second_level = {
    for k, v in var.organizational_units : k => v
    if v.parent != "Root"
  }
}

resource "aws_organizations_organizational_unit" "ous" {
  for_each = var.organizational_units

  name      = each.key
  parent_id = each.value.parent == "Root" ? local.root_ou_id : aws_organizations_organizational_unit.ous[each.value.parent].id

  depends_on = [aws_organizations_organization.main]

  lifecycle {
    create_before_destroy = true
  }
}
