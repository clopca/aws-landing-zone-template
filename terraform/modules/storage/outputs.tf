output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "logging_bucket_id" {
  description = "ID of the logging S3 bucket (if created)"
  value       = var.enable_logging && var.logging_bucket_name == null ? aws_s3_bucket.logging[0].id : null
}

output "logging_bucket_arn" {
  description = "ARN of the logging S3 bucket (if created)"
  value       = var.enable_logging && var.logging_bucket_name == null ? aws_s3_bucket.logging[0].arn : null
}
