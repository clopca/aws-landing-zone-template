output "ebs_encryption_enabled" {
  description = "EBS encryption status"
  value       = module.security_baseline.ebs_encryption_enabled
}

output "s3_public_access_blocked" {
  description = "S3 public access block status"
  value       = module.security_baseline.s3_public_access_blocked
}
