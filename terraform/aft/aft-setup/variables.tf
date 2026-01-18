variable "ct_management_account_id" {
  description = "Control Tower Management Account ID"
  type        = string
}

variable "log_archive_account_id" {
  description = "Log Archive Account ID"
  type        = string
}

variable "audit_account_id" {
  description = "Audit/Security Account ID"
  type        = string
}

variable "aft_management_account_id" {
  description = "AFT Management Account ID"
  type        = string
}

variable "ct_home_region" {
  description = "Control Tower home region"
  type        = string
  default     = "us-east-1"
}

variable "tf_backend_secondary_region" {
  description = "Secondary region for Terraform backend"
  type        = string
  default     = "us-west-2"
}

variable "vcs_provider" {
  description = "VCS provider (codecommit, github, githubenterprise, bitbucket)"
  type        = string
  default     = "codecommit"
}

variable "github_enterprise_url" {
  description = "GitHub Enterprise URL (if using GHE)"
  type        = string
  default     = ""
}

variable "account_request_repo_name" {
  description = "Repository name for account requests"
  type        = string
  default     = "aft-account-request"
}

variable "account_request_repo_branch" {
  description = "Branch for account request repository"
  type        = string
  default     = "main"
}

variable "global_customizations_repo_name" {
  description = "Repository name for global customizations"
  type        = string
  default     = "aft-global-customizations"
}

variable "global_customizations_repo_branch" {
  description = "Branch for global customizations repository"
  type        = string
  default     = "main"
}

variable "account_customizations_repo_name" {
  description = "Repository name for account customizations"
  type        = string
  default     = "aft-account-customizations"
}

variable "account_customizations_repo_branch" {
  description = "Branch for account customizations repository"
  type        = string
  default     = "main"
}

variable "account_provisioning_customizations_repo_name" {
  description = "Repository name for provisioning customizations"
  type        = string
  default     = "aft-account-provisioning-customizations"
}

variable "account_provisioning_customizations_repo_branch" {
  description = "Branch for provisioning customizations repository"
  type        = string
  default     = "main"
}

variable "terraform_version" {
  description = "Terraform version to use in AFT"
  type        = string
  default     = "1.5.0"
}

variable "terraform_distribution" {
  description = "Terraform distribution (oss or tfe)"
  type        = string
  default     = "oss"
}

variable "aft_feature_cloudtrail_data_events" {
  description = "Enable CloudTrail data events in AFT"
  type        = bool
  default     = false
}

variable "aft_feature_enterprise_support" {
  description = "Enable enterprise support in vended accounts"
  type        = bool
  default     = false
}

variable "aft_feature_delete_default_vpcs_enabled" {
  description = "Delete default VPCs in vended accounts"
  type        = bool
  default     = true
}
