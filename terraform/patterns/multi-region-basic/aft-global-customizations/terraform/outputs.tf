output "primary_region" {
  description = "Primary AWS region"
  value       = var.primary_region
}

output "dr_region" {
  description = "Disaster recovery AWS region"
  value       = var.dr_region
}

output "ebs_encryption_enabled" {
  description = "Whether EBS encryption is enabled by default"
  value       = var.enable_ebs_encryption
}

output "cross_region_backup_enabled" {
  description = "Whether cross-region backup is enabled"
  value       = var.enable_cross_region_backup
}
