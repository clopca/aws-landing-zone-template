output "ebs_encryption_enabled" {
  description = "Whether EBS encryption is enabled by default"
  value       = var.enable_ebs_encryption
}

output "s3_public_access_blocked" {
  description = "Whether S3 public access is blocked"
  value       = var.enable_s3_block_public_access
}
