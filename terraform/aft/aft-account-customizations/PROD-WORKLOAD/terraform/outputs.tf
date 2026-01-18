output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "tgw_attachment_id" {
  description = "Transit Gateway attachment ID"
  value       = local.requires_tgw ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
}
