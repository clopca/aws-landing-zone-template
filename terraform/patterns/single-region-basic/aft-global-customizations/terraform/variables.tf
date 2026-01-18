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
