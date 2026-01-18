output "account_id" {
  description = "Account ID from AFT"
  value       = data.aws_ssm_parameter.account_id.value
}

output "environment" {
  description = "Environment (production, staging, development)"
  value       = local.environment
}

output "vpc_cidr" {
  description = "VPC CIDR block for this account"
  value       = local.vpc_cidr
}

output "cost_center" {
  description = "Cost center for billing"
  value       = local.cost_center
}

output "owner" {
  description = "Account owner"
  value       = local.owner
}

output "data_classification" {
  description = "Data classification level"
  value       = local.data_classification
}

output "backup_enabled" {
  description = "Whether backup is enabled"
  value       = local.backup_enabled
}

output "custom_fields" {
  description = "Map of additional custom fields"
  value       = { for k, v in data.aws_ssm_parameter.custom : k => v.value }
}

output "tags" {
  description = "Common tags derived from custom fields"
  value = {
    Environment        = local.environment
    CostCenter         = local.cost_center
    Owner              = local.owner
    DataClassification = local.data_classification
    ManagedBy          = "AFT"
  }
}
