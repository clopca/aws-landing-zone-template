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
