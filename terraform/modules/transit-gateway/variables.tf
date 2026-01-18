variable "name" {
  description = "Name prefix for Transit Gateway resources"
  type        = string
}

variable "amazon_side_asn" {
  description = "Private ASN for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Auto accept shared attachments"
  type        = string
  default     = "enable"
}

variable "route_tables" {
  description = "List of route table names to create"
  type        = list(string)
  default     = ["shared", "production", "nonproduction"]
}

variable "share_with_organization" {
  description = "Share Transit Gateway with entire organization"
  type        = bool
  default     = true
}

variable "organization_arn" {
  description = "ARN of the organization to share with"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
