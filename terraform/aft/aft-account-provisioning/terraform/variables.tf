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

variable "control_tower_parameters" {
  description = "Control Tower parameters from AFT"
  type        = map(string)
  default     = {}
}
