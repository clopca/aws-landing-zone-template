variable "name_prefix" {
  description = "Prefix for IAM resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Permission Sets Configuration
variable "create_permission_sets" {
  description = "Whether to create IAM Identity Center permission sets"
  type        = bool
  default     = false
}

variable "sso_instance_arn" {
  description = "ARN of the IAM Identity Center instance"
  type        = string
  default     = ""
}

variable "permission_sets" {
  description = "Map of permission sets to create"
  type = map(object({
    description      = string
    session_duration = string
    managed_policies = list(string)
    inline_policy    = optional(string)
  }))
  default = {}
}

# Cross-Account Roles Configuration
variable "create_cross_account_roles" {
  description = "Whether to create cross-account IAM roles"
  type        = bool
  default     = true
}

variable "trusted_account_ids" {
  description = "List of AWS account IDs that can assume cross-account roles"
  type        = list(string)
  default     = []
}

variable "cross_account_roles" {
  description = "Map of cross-account roles to create"
  type = map(object({
    description          = string
    managed_policies     = list(string)
    inline_policy        = optional(string)
    max_session_duration = optional(number, 3600)
  }))
  default = {}
}

# Permission Boundary Configuration
variable "enable_permission_boundary" {
  description = "Whether to attach a permission boundary to IAM roles"
  type        = bool
  default     = false
}

variable "permission_boundary_arn" {
  description = "ARN of the IAM policy to use as a permission boundary"
  type        = string
  default     = ""
}

# Break-Glass User Configuration
variable "create_break_glass_user" {
  description = "Whether to create a break-glass IAM user"
  type        = bool
  default     = false
}

variable "break_glass_user_name" {
  description = "Name of the break-glass IAM user"
  type        = string
  default     = "break-glass-admin"
}

variable "break_glass_user_path" {
  description = "Path for the break-glass IAM user"
  type        = string
  default     = "/"
}

variable "break_glass_user_policies" {
  description = "List of managed policy ARNs to attach to the break-glass user"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

# Service-Linked Roles Configuration
variable "service_linked_roles" {
  description = "Map of service-linked roles to create"
  type = map(object({
    aws_service_name = string
    description      = optional(string)
  }))
  default = {}
}

# Custom IAM Policies Configuration
variable "custom_policies" {
  description = "Map of custom IAM policies to create"
  type = map(object({
    description = string
    policy      = string
  }))
  default = {}
}

# Password Policy Configuration
variable "configure_password_policy" {
  description = "Whether to configure the account password policy"
  type        = bool
  default     = true
}

variable "password_policy" {
  description = "Account password policy configuration"
  type = object({
    minimum_password_length        = optional(number, 14)
    require_lowercase_characters   = optional(bool, true)
    require_uppercase_characters   = optional(bool, true)
    require_numbers                = optional(bool, true)
    require_symbols                = optional(bool, true)
    allow_users_to_change_password = optional(bool, true)
    max_password_age               = optional(number, 90)
    password_reuse_prevention      = optional(number, 24)
    hard_expiry                    = optional(bool, false)
  })
  default = {}
}

variable "create_default_permission_sets" {
  description = "Whether to create default permission sets (AdministratorAccess, ReadOnlyAccess, etc.)"
  type        = bool
  default     = true
}

variable "create_default_cross_account_roles" {
  description = "Whether to create default cross-account roles (OrganizationAccountAccessRole, SecurityAuditRole, etc.)"
  type        = bool
  default     = true
}

variable "require_mfa_for_cross_account" {
  description = "Whether to require MFA for cross-account role assumption"
  type        = bool
  default     = true
}
