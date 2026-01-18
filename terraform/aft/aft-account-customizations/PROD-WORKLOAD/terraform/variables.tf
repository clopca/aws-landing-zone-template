variable "account_tags" {
  description = "Tags from AFT account request"
  type        = map(string)
  default     = {}
}

variable "custom_fields" {
  description = "Custom fields from AFT account request"
  type        = map(string)
  default     = {}
}
