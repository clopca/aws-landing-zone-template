output "organization_id" {
  description = "The AWS Organization ID (from Control Tower)"
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

output "ou_ids" {
  description = "Map of OU names to IDs (Control Tower managed)"
  value       = local.ou_name_to_id
}

output "management_account_id" {
  description = "Management account ID"
  value       = local.account_id
}

output "custom_scps" {
  description = "Map of custom SCP names to IDs"
  value = {
    deny_leave_org   = aws_organizations_policy.deny_leave_org.id
    require_imdsv2   = aws_organizations_policy.require_imdsv2.id
    deny_root_user   = aws_organizations_policy.deny_root_user.id
    restrict_regions = length(aws_organizations_policy.restrict_regions) > 0 ? aws_organizations_policy.restrict_regions[0].id : null
  }
}
