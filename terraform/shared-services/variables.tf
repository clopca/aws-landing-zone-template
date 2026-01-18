variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "organization_name" {
  description = "Organization name prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for shared services VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach to"
  type        = string
}

variable "tgw_route_table_id" {
  description = "Transit Gateway route table ID for association"
  type        = string
}

variable "enable_ecr" {
  description = "Create ECR repositories"
  type        = bool
  default     = true
}

variable "ecr_repositories" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default     = []
}
