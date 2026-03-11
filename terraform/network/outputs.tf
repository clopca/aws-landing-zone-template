output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.tgw.transit_gateway_id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN"
  value       = module.tgw.transit_gateway_arn
}

output "transit_gateway_route_table_ids" {
  description = "Map of Transit Gateway route table names to IDs"
  value       = module.tgw.route_table_ids
}

output "vpc_id" {
  description = "Network Hub VPC ID"
  value       = module.hub_vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.hub_vpc.private_subnet_ids
}

output "transit_subnet_ids" {
  description = "Transit Gateway attachment subnet IDs"
  value       = module.hub_vpc.transit_subnet_ids
}

output "ram_share_arn" {
  description = "RAM resource share ARN for Transit Gateway"
  value       = module.tgw.ram_share_arn
}

output "private_hosted_zone_id" {
  description = "Private hosted zone ID"
  value       = module.dns.private_zone_id
}
