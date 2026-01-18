variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for SSE-KMS encryption. If not provided, SSE-S3 will be used"
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enable access logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "logging_bucket_name" {
  description = "Name of the S3 bucket for access logs. If not provided and enable_logging is true, a logging bucket will be created"
  type        = string
  default     = null
}

variable "logging_prefix" {
  description = "Prefix for access log objects"
  type        = string
  default     = "logs/"
}

variable "enable_public_access_block" {
  description = "Enable public access block for the S3 bucket"
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type = list(object({
    id                            = string
    enabled                       = bool
    prefix                        = optional(string)
    expiration_days               = optional(number)
    noncurrent_version_expiration = optional(number)
    transition_days               = optional(number)
    transition_storage_class      = optional(string)
    noncurrent_transition_days    = optional(number)
    noncurrent_storage_class      = optional(string)
  }))
  default = []
}

variable "enable_replication" {
  description = "Enable cross-region replication for the S3 bucket"
  type        = bool
  default     = false
}

variable "replication_role_arn" {
  description = "ARN of the IAM role for replication"
  type        = string
  default     = null
}

variable "replication_destination_bucket_arn" {
  description = "ARN of the destination bucket for replication"
  type        = string
  default     = null
}

variable "replication_destination_storage_class" {
  description = "Storage class for replicated objects"
  type        = string
  default     = "STANDARD"
}

variable "enable_object_lock" {
  description = "Enable object lock for the S3 bucket (requires versioning)"
  type        = bool
  default     = false
}

variable "object_lock_mode" {
  description = "Object lock mode (GOVERNANCE or COMPLIANCE)"
  type        = string
  default     = "GOVERNANCE"
  validation {
    condition     = contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_mode)
    error_message = "Object lock mode must be GOVERNANCE or COMPLIANCE"
  }
}

variable "object_lock_days" {
  description = "Number of days for object lock retention"
  type        = number
  default     = 1
}

variable "bucket_policy" {
  description = "Custom bucket policy JSON. If not provided, a default secure policy will be applied"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
