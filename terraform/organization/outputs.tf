output "organization_id" {
  description = "AWS Organization ID"
  value       = aws_organizations_organization.main.id
}

output "organization_arn" {
  description = "AWS Organization ARN"
  value       = aws_organizations_organization.main.arn
}

output "root_ou_id" {
  description = "Root Organizational Unit ID"
  value       = aws_organizations_organization.main.roots[0].id
}

output "ou_ids" {
  description = "Map of OU names to their IDs"
  value = {
    for k, v in aws_organizations_organizational_unit.ous : k => v.id
  }
}

output "ou_arns" {
  description = "Map of OU names to their ARNs"
  value = {
    for k, v in aws_organizations_organizational_unit.ous : k => v.arn
  }
}

output "scp_ids" {
  description = "Map of SCP names to their IDs"
  value = {
    deny_leave_org = aws_organizations_policy.deny_leave_org.id
    require_imdsv2 = aws_organizations_policy.require_imdsv2.id
  }
}

output "management_account_id" {
  description = "Management account ID"
  value       = aws_organizations_organization.main.master_account_id
}
