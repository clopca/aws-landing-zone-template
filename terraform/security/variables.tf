variable "aws_region" {
  description = "AWS region for the security account"
  type        = string
  default     = "us-east-1"
}

variable "enable_guardduty" {
  description = "Enable GuardDuty across the organization"
  type        = bool
  default     = true
}

variable "guardduty_s3_protection" {
  description = "Enable S3 protection in GuardDuty"
  type        = bool
  default     = true
}

variable "guardduty_eks_protection" {
  description = "Enable EKS protection in GuardDuty"
  type        = bool
  default     = true
}

variable "guardduty_malware_protection" {
  description = "Enable malware protection in GuardDuty"
  type        = bool
  default     = true
}

variable "enable_security_hub" {
  description = "Enable Security Hub across the organization"
  type        = bool
  default     = true
}

variable "security_hub_standards" {
  description = "List of Security Hub standards to enable"
  type        = list(string)
  default = [
    "aws-foundational-security-best-practices/v/1.0.0",
    "cis-aws-foundations-benchmark/v/1.4.0",
  ]
}

variable "enable_config_aggregator" {
  description = "Enable AWS Config aggregator"
  type        = bool
  default     = true
}

variable "enable_access_analyzer" {
  description = "Enable IAM Access Analyzer"
  type        = bool
  default     = true
}

variable "log_archive_bucket_name" {
  description = "S3 bucket name in log archive account for security findings"
  type        = string
  default     = ""
}

variable "security_notification_emails" {
  description = "Email addresses for security alerts"
  type        = list(string)
  default     = []
}
