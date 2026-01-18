output "ebs_encryption_enabled" {
  description = "Whether EBS encryption by default is enabled"
  value       = var.enable_ebs_encryption
}

output "s3_public_access_blocked" {
  description = "Whether S3 public access is blocked at account level"
  value       = var.enable_s3_block_public_access
}

output "iam_password_policy_enabled" {
  description = "Whether IAM password policy is configured"
  value       = var.enable_iam_password_policy
}
