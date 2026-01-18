variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection for source repository"
  type        = string
}

variable "repository_id" {
  description = "Full repository ID (e.g., owner/repo)"
  type        = string
}

variable "branch_name" {
  description = "Branch to monitor for changes"
  type        = string
  default     = "main"
}

variable "permission_sets_path" {
  description = "Path to permission sets Terraform configuration in repository"
  type        = string
  default     = "terraform/permission-sets"
}

variable "enable_manual_approval" {
  description = "Enable manual approval stage before apply"
  type        = bool
  default     = true
}

variable "approval_email" {
  description = "Email address for approval notifications"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption (optional)"
  type        = string
  default     = null
}

variable "terraform_version" {
  description = "Terraform version to use in CodeBuild"
  type        = string
  default     = "1.5.7"
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "CodeBuild Docker image"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
}

variable "build_timeout" {
  description = "CodeBuild timeout in minutes"
  type        = number
  default     = 30
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
