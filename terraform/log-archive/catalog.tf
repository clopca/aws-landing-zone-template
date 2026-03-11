resource "aws_ssm_parameter" "catalog" {
  name = "/org/log-archive/catalog"
  type = "String"
  value = jsonencode({
    cloudtrail_bucket_name    = aws_s3_bucket.cloudtrail.id
    cloudtrail_bucket_arn     = aws_s3_bucket.cloudtrail.arn
    config_bucket_name        = aws_s3_bucket.config.id
    config_bucket_arn         = aws_s3_bucket.config.arn
    vpc_flow_logs_bucket_name = aws_s3_bucket.vpc_flow_logs.id
    vpc_flow_logs_bucket_arn  = aws_s3_bucket.vpc_flow_logs.arn
    kms_key_arn               = aws_kms_key.logs.arn
    kms_key_id                = aws_kms_key.logs.id
    access_logs_bucket_name   = var.enable_s3_access_logging ? aws_s3_bucket.access_logs[0].id : null
  })
}
