variable "aws_region" {
  description = "AWS region for the management account"
  type        = string
  default     = "us-east-1"
}

variable "organization_name" {
  description = "Name prefix for the AWS Organization resources"
  type        = string
}

variable "organizational_units" {
  description = "Map of Organizational Units to create"
  type = map(object({
    parent = string
  }))
  default = {
    Security = {
      parent = "Root"
    }
    Infrastructure = {
      parent = "Root"
    }
    Workloads = {
      parent = "Root"
    }
    Production = {
      parent = "Workloads"
    }
    NonProduction = {
      parent = "Workloads"
    }
    Sandbox = {
      parent = "Root"
    }
  }
}

variable "scp_deny_regions" {
  description = "List of AWS regions to deny access to (empty = allow all)"
  type        = list(string)
  default     = []
}

variable "scp_allowed_regions" {
  description = "List of AWS regions to allow (if specified, all others are denied)"
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "enable_iam_identity_center" {
  description = "Enable IAM Identity Center (SSO)"
  type        = bool
  default     = true
}

variable "delegated_admin_account_id" {
  description = "Account ID to delegate admin for security services"
  type        = string
  default     = ""
}
