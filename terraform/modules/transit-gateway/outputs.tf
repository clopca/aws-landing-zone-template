output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN"
  value       = aws_ec2_transit_gateway.main.arn
}

output "route_table_ids" {
  description = "Map of route table names to IDs"
  value = {
    for k, v in aws_ec2_transit_gateway_route_table.main : k => v.id
  }
}

output "ram_share_arn" {
  description = "RAM resource share ARN"
  value       = var.share_with_organization ? aws_ram_resource_share.main[0].arn : null
}
