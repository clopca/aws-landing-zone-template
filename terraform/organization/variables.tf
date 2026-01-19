variable "aws_region" {
  description = "AWS region (should match Control Tower home region)"
  type        = string
  default     = "us-east-1"
}

variable "organization_name" {
  description = "Name prefix for custom SCPs and resources"
  type        = string
  default     = "lz"
}

variable "scp_allowed_regions" {
  description = "List of AWS regions to allow (if specified, all others are denied)"
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "delegated_admin_account_id" {
  description = "Account ID to delegate admin for security services (Audit account)"
  type        = string
  default     = ""
}
