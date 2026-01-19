output "account_id" {
  description = "AWS Account ID"
  value       = local.account_id
}

output "primary_vpc_id" {
  description = "Primary VPC ID"
  value       = module.vpc_primary.vpc_id
}

output "primary_vpc_cidr" {
  description = "Primary VPC CIDR block"
  value       = local.primary_vpc_cidr
}

output "secondary_vpc_id" {
  description = "Secondary VPC ID"
  value       = module.vpc_secondary.vpc_id
}

output "secondary_vpc_cidr" {
  description = "Secondary VPC CIDR block"
  value       = local.secondary_vpc_cidr
}

output "backup_vault_arn" {
  description = "AWS Backup vault ARN"
  value       = module.backup.vault_arn
}

output "replication_bucket_id" {
  description = "S3 replication bucket ID"
  value       = module.storage.replication_bucket_id
}
