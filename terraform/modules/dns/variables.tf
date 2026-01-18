variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the private hosted zone and resolver endpoints"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "create_private_hosted_zone" {
  description = "Whether to create a private hosted zone"
  type        = bool
  default     = false
}

variable "private_zone_name" {
  description = "Name of the private hosted zone"
  type        = string
  default     = ""
}

variable "additional_vpc_ids" {
  description = "Additional VPC IDs to associate with the private hosted zone"
  type        = list(string)
  default     = []
}

variable "share_zone_with_organization" {
  description = "Whether to share the private hosted zone with the organization via RAM"
  type        = bool
  default     = false
}

variable "organization_arn" {
  description = "ARN of the AWS Organization to share resources with"
  type        = string
  default     = ""
}

variable "create_resolver_endpoints" {
  description = "Whether to create Route53 Resolver endpoints"
  type        = bool
  default     = false
}

variable "create_inbound_endpoint" {
  description = "Whether to create an inbound resolver endpoint"
  type        = bool
  default     = false
}

variable "create_outbound_endpoint" {
  description = "Whether to create an outbound resolver endpoint"
  type        = bool
  default     = false
}

variable "resolver_subnet_ids" {
  description = "Subnet IDs for resolver endpoints (minimum 2 required)"
  type        = list(string)
  default     = []
}

variable "resolver_allowed_cidrs" {
  description = "CIDR blocks allowed to query the resolver endpoints"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "forward_rules" {
  description = "Map of forwarding rules for outbound resolver"
  type = map(object({
    domain_name = string
    target_ips = list(object({
      ip   = string
      port = number
    }))
  }))
  default = {}
}

variable "share_rules_with_organization" {
  description = "Whether to share resolver rules with the organization via RAM"
  type        = bool
  default     = false
}
