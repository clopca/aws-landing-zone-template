locals {
  delegated_admin_services = var.security_admin_account_id != "" ? toset([
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "config.amazonaws.com",
    "access-analyzer.amazonaws.com",
  ]) : toset([])
}

resource "aws_organizations_delegated_administrator" "security" {
  for_each = local.delegated_admin_services

  account_id        = var.security_admin_account_id
  service_principal = each.value
}
