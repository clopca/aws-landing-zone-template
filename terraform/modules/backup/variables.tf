variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN for backup vault encryption"
  type        = string
  default     = null
}

variable "enable_cross_account_backup" {
  description = "Enable cross-account backup"
  type        = bool
  default     = false
}

variable "source_account_ids" {
  description = "Account IDs allowed to copy backups to this vault"
  type        = list(string)
  default     = []
}

variable "backup_rules" {
  description = "List of backup rules"
  type = list(object({
    name               = string
    schedule           = string
    start_window       = optional(number, 60)
    completion_window  = optional(number, 180)
    cold_storage_after = optional(number)
    delete_after       = number
    copy_to_vault_arn  = optional(string)
    copy_delete_after  = optional(number)
  }))
  default = [
    {
      name         = "daily"
      schedule     = "cron(0 5 ? * * *)"
      delete_after = 35
    }
  ]
}

variable "selection_tags" {
  description = "Tags to select resources for backup"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {
      key   = "Backup"
      value = "true"
    }
  ]
}

variable "resource_arns" {
  description = "Specific resource ARNs to backup"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
