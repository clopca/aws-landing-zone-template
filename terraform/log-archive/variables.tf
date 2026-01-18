variable "aws_region" {
  description = "AWS region for log archive account"
  type        = string
  default     = "us-east-1"
}

variable "organization_name" {
  description = "Organization name prefix for resource naming"
  type        = string
}

variable "organization_id" {
  description = "AWS Organization ID"
  type        = string
}

variable "cloudtrail_retention_days" {
  description = "Number of days to retain CloudTrail logs"
  type        = number
  default     = 365
}

variable "config_retention_days" {
  description = "Number of days to retain Config logs"
  type        = number
  default     = 365
}

variable "vpc_flow_log_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 90
}

variable "enable_s3_access_logging" {
  description = "Enable S3 access logging for log buckets"
  type        = bool
  default     = true
}

variable "enable_glacier_transition" {
  description = "Enable transition to Glacier for older logs"
  type        = bool
  default     = true
}

variable "glacier_transition_days" {
  description = "Days after which logs transition to Glacier"
  type        = number
  default     = 90
}
