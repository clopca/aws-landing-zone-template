# Control Tower Data Sources
#
# This module provides data sources to reference resources created by AWS Control Tower.
# We DO NOT create AWS Organizations, OUs, or core accounts - Control Tower manages those.
#
# Prerequisites:
# - AWS Control Tower must be deployed
# - Run this from the Management Account

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get the AWS Organization (created by Control Tower)
data "aws_organizations_organization" "main" {}

# Get all organizational units
data "aws_organizations_organizational_units" "root" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

# Locals to organize OU data
locals {
  root_id = data.aws_organizations_organization.main.roots[0].id

  # Map OU names to their IDs for easy reference
  ou_name_to_id = {
    for ou in data.aws_organizations_organizational_units.root.children :
    ou.name => ou.id
  }

  # Control Tower standard OUs
  security_ou_id       = lookup(local.ou_name_to_id, "Security", null)
  infrastructure_ou_id = lookup(local.ou_name_to_id, "Infrastructure", null)
  sandbox_ou_id        = lookup(local.ou_name_to_id, "Sandbox", null)
  workloads_ou_id      = lookup(local.ou_name_to_id, "Workloads", null)
}

# Get Control Tower core accounts
data "aws_organizations_organization" "accounts" {}

locals {
  # Find accounts by name pattern (Control Tower naming)
  all_accounts = data.aws_organizations_organization.accounts.accounts

  log_archive_account = [
    for acct in local.all_accounts :
    acct if can(regex("(?i)log.?archive", acct.name))
  ]

  audit_account = [
    for acct in local.all_accounts :
    acct if can(regex("(?i)audit|security", acct.name))
  ]

  management_account_id  = data.aws_caller_identity.current.account_id
  log_archive_account_id = length(local.log_archive_account) > 0 ? local.log_archive_account[0].id : null
  audit_account_id       = length(local.audit_account) > 0 ? local.audit_account[0].id : null
}
