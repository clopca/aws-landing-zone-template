variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where bastion host will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for bastion host deployment"
  type        = list(string)
}

variable "enable_bastion" {
  description = "Enable bastion host deployment"
  type        = bool
  default     = true
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion host (if not specified, latest Amazon Linux 2023 will be used)"
  type        = string
  default     = ""
}

variable "bastion_root_volume_size" {
  description = "Size of bastion host root volume in GB"
  type        = number
  default     = 20
}

variable "bastion_root_volume_type" {
  description = "Type of bastion host root volume"
  type        = string
  default     = "gp3"
}

variable "bastion_root_volume_encrypted" {
  description = "Enable encryption for bastion host root volume"
  type        = bool
  default     = true
}

variable "bastion_root_volume_kms_key_id" {
  description = "KMS key ID for bastion host root volume encryption (if not specified, AWS managed key will be used)"
  type        = string
  default     = ""
}

variable "enable_bastion_auto_scaling" {
  description = "Enable auto scaling group for bastion host (for HA)"
  type        = bool
  default     = false
}

variable "bastion_desired_capacity" {
  description = "Desired number of bastion instances in auto scaling group"
  type        = number
  default     = 1
}

variable "bastion_min_size" {
  description = "Minimum number of bastion instances in auto scaling group"
  type        = number
  default     = 1
}

variable "bastion_max_size" {
  description = "Maximum number of bastion instances in auto scaling group"
  type        = number
  default     = 1
}

variable "enable_cloudwatch_agent" {
  description = "Enable CloudWatch agent on bastion host"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for bastion host logs"
  type        = string
  default     = ""
}

variable "cloudwatch_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "enable_session_manager_logging" {
  description = "Enable Session Manager session logging to CloudWatch"
  type        = bool
  default     = true
}

variable "session_manager_log_group_name" {
  description = "CloudWatch log group name for Session Manager logs"
  type        = string
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access bastion (for future use, currently SSM-only)"
  type        = list(string)
  default     = []
}

variable "enable_imdsv2" {
  description = "Require IMDSv2 for EC2 metadata access"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Associate public IP address with bastion host"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script for bastion host initialization"
  type        = string
  default     = ""
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to bastion host"
  type        = list(string)
  default     = []
}

variable "additional_iam_policies" {
  description = "Additional IAM policy ARNs to attach to bastion instance role"
  type        = list(string)
  default     = []
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring for bastion host"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
