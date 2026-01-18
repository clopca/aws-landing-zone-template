output "private_zone_id" {
  description = "ID of the private hosted zone"
  value       = try(aws_route53_zone.private[0].zone_id, null)
}

output "private_zone_name" {
  description = "Name of the private hosted zone"
  value       = try(aws_route53_zone.private[0].name, null)
}

output "private_zone_arn" {
  description = "ARN of the private hosted zone"
  value       = try(aws_route53_zone.private[0].arn, null)
}

output "private_zone_name_servers" {
  description = "Name servers for the private hosted zone"
  value       = try(aws_route53_zone.private[0].name_servers, [])
}

output "inbound_endpoint_id" {
  description = "ID of the inbound resolver endpoint"
  value       = try(aws_route53_resolver_endpoint.inbound[0].id, null)
}

output "inbound_endpoint_ips" {
  description = "IP addresses of the inbound resolver endpoint"
  value       = try(aws_route53_resolver_endpoint.inbound[0].ip_address[*].ip, [])
}

output "outbound_endpoint_id" {
  description = "ID of the outbound resolver endpoint"
  value       = try(aws_route53_resolver_endpoint.outbound[0].id, null)
}

output "outbound_endpoint_ips" {
  description = "IP addresses of the outbound resolver endpoint"
  value       = try(aws_route53_resolver_endpoint.outbound[0].ip_address[*].ip, [])
}

output "resolver_security_group_id" {
  description = "ID of the resolver security group"
  value       = try(aws_security_group.resolver[0].id, null)
}

output "resolver_rule_ids" {
  description = "Map of resolver rule names to IDs"
  value       = { for k, v in aws_route53_resolver_rule.forward : k => v.id }
}

output "resolver_rule_arns" {
  description = "Map of resolver rule names to ARNs"
  value       = { for k, v in aws_route53_resolver_rule.forward : k => v.arn }
}

output "dns_ram_share_id" {
  description = "ID of the DNS RAM resource share"
  value       = try(aws_ram_resource_share.dns[0].id, null)
}

output "resolver_rules_ram_share_id" {
  description = "ID of the resolver rules RAM resource share"
  value       = try(aws_ram_resource_share.resolver_rules[0].id, null)
}
