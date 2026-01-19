# Control Tower Data - Output Values
#
# These outputs provide references to Control Tower managed resources
# for use by other Terraform configurations.

output "organization_id" {
  description = "The AWS Organization ID"
  value       = data.aws_organizations_organization.main.id
}

output "organization_arn" {
  description = "The AWS Organization ARN"
  value       = data.aws_organizations_organization.main.arn
}

output "root_id" {
  description = "The root OU ID"
  value       = local.root_id
}

output "management_account_id" {
  description = "The Management Account ID"
  value       = local.management_account_id
}

output "log_archive_account_id" {
  description = "The Log Archive Account ID (Control Tower managed)"
  value       = local.log_archive_account_id
}

output "audit_account_id" {
  description = "The Audit/Security Account ID (Control Tower managed)"
  value       = local.audit_account_id
}

# Organizational Unit IDs
output "security_ou_id" {
  description = "Security OU ID"
  value       = local.security_ou_id
}

output "infrastructure_ou_id" {
  description = "Infrastructure OU ID"
  value       = local.infrastructure_ou_id
}

output "sandbox_ou_id" {
  description = "Sandbox OU ID"
  value       = local.sandbox_ou_id
}

output "workloads_ou_id" {
  description = "Workloads OU ID"
  value       = local.workloads_ou_id
}

output "all_ou_ids" {
  description = "Map of all OU names to IDs"
  value       = local.ou_name_to_id
}

output "all_accounts" {
  description = "List of all accounts in the organization"
  value = [
    for acct in local.all_accounts : {
      id     = acct.id
      name   = acct.name
      email  = acct.email
      status = acct.status
    }
  ]
  sensitive = true
}
