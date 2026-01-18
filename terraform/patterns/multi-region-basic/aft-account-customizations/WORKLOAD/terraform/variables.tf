variable "environment" {
  description = "Environment name"
  type        = string
  default     = "workload"
}

variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster recovery AWS region"
  type        = string
  default     = "us-west-2"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dr_vpc_cidr" {
  description = "CIDR block for the DR VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "primary_availability_zones" {
  description = "Availability zones for primary region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "dr_availability_zones" {
  description = "Availability zones for DR region"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway in primary region"
  type        = bool
  default     = true
}

variable "enable_nat_gateway_dr" {
  description = "Enable NAT Gateway in DR region"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway in primary region"
  type        = bool
  default     = false
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "VPC Flow Logs retention in days"
  type        = number
  default     = 30
}

variable "enable_s3_replication" {
  description = "Enable S3 cross-region replication"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "AFT"
    Pattern   = "multi-region-basic"
  }
}
