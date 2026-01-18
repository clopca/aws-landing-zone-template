output "cloudtrail_bucket_name" {
  description = "CloudTrail S3 bucket name"
  value       = aws_s3_bucket.cloudtrail.id
}

output "cloudtrail_bucket_arn" {
  description = "CloudTrail S3 bucket ARN"
  value       = aws_s3_bucket.cloudtrail.arn
}

output "config_bucket_name" {
  description = "Config S3 bucket name"
  value       = aws_s3_bucket.config.id
}

output "config_bucket_arn" {
  description = "Config S3 bucket ARN"
  value       = aws_s3_bucket.config.arn
}

output "vpc_flow_logs_bucket_name" {
  description = "VPC Flow Logs S3 bucket name"
  value       = aws_s3_bucket.vpc_flow_logs.id
}

output "vpc_flow_logs_bucket_arn" {
  description = "VPC Flow Logs S3 bucket ARN"
  value       = aws_s3_bucket.vpc_flow_logs.arn
}

output "kms_key_arn" {
  description = "KMS key ARN for log encryption"
  value       = aws_kms_key.logs.arn
}

output "kms_key_id" {
  description = "KMS key ID for log encryption"
  value       = aws_kms_key.logs.id
}
