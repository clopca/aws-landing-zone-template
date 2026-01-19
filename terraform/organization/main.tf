# Organization Customizations
#
# This module provides ADDITIONAL customizations on top of AWS Control Tower.
# It does NOT create AWS Organizations or OUs - those are managed by Control Tower.
#
# Use this for:
# - Custom SCPs beyond Control Tower guardrails
# - Additional tag policies
# - Delegated administrator setup for security services
#
# Prerequisites:
# - AWS Control Tower must be deployed
# - Run from the Management Account

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Reference the existing organization (created by Control Tower)
data "aws_organizations_organization" "main" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.id
  root_id    = data.aws_organizations_organization.main.roots[0].id
}

# Get existing OUs from Control Tower
data "aws_organizations_organizational_units" "root" {
  parent_id = local.root_id
}

locals {
  ou_name_to_id = {
    for ou in data.aws_organizations_organizational_units.root.children :
    ou.name => ou.id
  }
}
