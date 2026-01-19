variable "account_tags" {
  description = "Tags applied to the account (provided by AFT)"
  type        = map(string)
  default     = {}
}

variable "custom_fields" {
  description = "Custom fields from account request (provided by AFT)"
  type        = map(string)
  default     = {}
}

variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for DR"
  type        = string
  default     = "us-west-2"
}
