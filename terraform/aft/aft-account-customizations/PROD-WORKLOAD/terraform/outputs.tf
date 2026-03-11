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
  value       = local.requires_tgw ? module.tgw_attachment[0].attachment_id : null
}
