output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN"
  value       = aws_ec2_transit_gateway.main.arn
}

output "transit_gateway_route_table_ids" {
  description = "Map of Transit Gateway route table names to IDs"
  value = {
    for k, v in aws_ec2_transit_gateway_route_table.main : k => v.id
  }
}

output "vpc_id" {
  description = "Network Hub VPC ID"
  value       = aws_vpc.network_hub.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "transit_subnet_ids" {
  description = "Transit Gateway attachment subnet IDs"
  value       = aws_subnet.transit[*].id
}

output "ram_share_arn" {
  description = "RAM resource share ARN for Transit Gateway"
  value       = aws_ram_resource_share.tgw.arn
}

output "private_hosted_zone_id" {
  description = "Private hosted zone ID"
  value       = aws_route53_zone.private.zone_id
}
