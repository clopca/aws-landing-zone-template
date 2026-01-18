variable "aws_region" {
  description = "AWS region for network hub"
  type        = string
  default     = "us-east-1"
}

variable "organization_name" {
  description = "Organization name prefix for resource naming"
  type        = string
}

variable "organization_arn" {
  description = "AWS Organization ARN for RAM sharing"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "network_hub_cidr" {
  description = "CIDR block for network hub VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tgw_route_tables" {
  description = "Transit Gateway route tables to create"
  type        = list(string)
  default     = ["shared", "production", "nonproduction"]
}

variable "enable_dns_firewall" {
  description = "Enable Route53 Resolver DNS Firewall"
  type        = bool
  default     = true
}

variable "private_hosted_zone_name" {
  description = "Name for the private hosted zone"
  type        = string
  default     = "aws.internal"
}

variable "enable_network_firewall" {
  description = "Enable AWS Network Firewall for inspection"
  type        = bool
  default     = true
}

variable "vpc_flow_log_bucket_arn" {
  description = "S3 bucket ARN for VPC flow logs"
  type        = string
  default     = ""
}
