variable "read_environment" {
  description = "Read environment custom field"
  type        = bool
  default     = true
}

variable "read_vpc_cidr" {
  description = "Read vpc_cidr custom field"
  type        = bool
  default     = true
}

variable "read_cost_center" {
  description = "Read cost_center custom field"
  type        = bool
  default     = false
}

variable "read_owner" {
  description = "Read owner custom field"
  type        = bool
  default     = false
}

variable "read_data_classification" {
  description = "Read data_classification custom field"
  type        = bool
  default     = false
}

variable "read_backup_enabled" {
  description = "Read backup_enabled custom field"
  type        = bool
  default     = false
}

variable "additional_custom_fields" {
  description = "List of additional custom field names to read"
  type        = list(string)
  default     = []
}

variable "default_environment" {
  description = "Default environment if not specified"
  type        = string
  default     = "development"
}

variable "default_vpc_cidr" {
  description = "Default VPC CIDR if not specified"
  type        = string
  default     = "10.0.0.0/16"
}
