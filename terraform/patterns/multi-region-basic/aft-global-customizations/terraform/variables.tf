variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster recovery AWS region"
  type        = string
  default     = "us-west-2"
}

variable "enable_ebs_encryption" {
  description = "Enable EBS encryption by default"
  type        = bool
  default     = true
}

variable "enable_s3_block_public_access" {
  description = "Enable S3 account-level public access block"
  type        = bool
  default     = true
}

variable "enable_iam_password_policy" {
  description = "Configure IAM password policy"
  type        = bool
  default     = true
}

variable "password_min_length" {
  description = "Minimum password length"
  type        = number
  default     = 14
}

variable "password_max_age" {
  description = "Maximum password age in days"
  type        = number
  default     = 90
}

variable "password_reuse_prevention" {
  description = "Number of previous passwords to prevent reuse"
  type        = number
  default     = 24
}

variable "enable_cross_region_backup" {
  description = "Enable cross-region backup"
  type        = bool
  default     = true
}
