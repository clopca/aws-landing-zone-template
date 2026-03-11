variable "name" {
  description = "VPC name"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways"
  type        = bool
  default     = true
  validation {
    condition     = var.enable_nat_gateway ? var.create_public_subnets : true
    error_message = "create_public_subnets must be true when enable_nat_gateway is enabled."
  }
}

variable "create_public_subnets" {
  description = "Create public subnets and the shared public route table"
  type        = bool
  default     = true
}

variable "create_database_subnets" {
  description = "Create database subnets"
  type        = bool
  default     = true
}

variable "create_transit_subnets" {
  description = "Create transit subnets and the shared transit route table"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway instead of one per AZ"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC flow logs"
  type        = bool
  default     = true
}

variable "flow_log_destination_arn" {
  description = "ARN of the destination for flow logs (S3 bucket or CloudWatch log group)"
  type        = string
  default     = ""
  validation {
    condition     = var.enable_flow_logs ? var.flow_log_destination_arn != "" : true
    error_message = "flow_log_destination_arn must be set when enable_flow_logs is true."
  }
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination (s3 or cloud-watch-logs)"
  type        = string
  default     = "s3"
  validation {
    condition     = contains(["s3", "cloud-watch-logs"], var.flow_log_destination_type)
    error_message = "flow_log_destination_type must be either s3 or cloud-watch-logs."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
