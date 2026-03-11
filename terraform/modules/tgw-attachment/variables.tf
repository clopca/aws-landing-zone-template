variable "name" {
  description = "Name prefix for the TGW attachment"
  type        = string
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the attachment"
  type        = list(string)
}

variable "association_route_table_id" {
  description = "Transit Gateway route table ID used for attachment association"
  type        = string
}

variable "propagation_route_table_ids" {
  description = "Transit Gateway route table IDs to propagate the attachment into"
  type        = list(string)
  default     = []
}

variable "spoke_route_table_ids" {
  description = "VPC route table IDs that should target the TGW for destination CIDRs"
  type        = list(string)
  default     = []
}

variable "destination_cidrs" {
  description = "Destination CIDRs to route from the spoke route tables through the TGW"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
