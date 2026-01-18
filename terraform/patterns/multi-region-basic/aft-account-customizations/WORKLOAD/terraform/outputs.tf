output "primary_vpc_id" {
  description = "ID of the primary VPC"
  value       = module.vpc_primary.vpc_id
}

output "dr_vpc_id" {
  description = "ID of the DR VPC"
  value       = module.vpc_dr.vpc_id
}

output "primary_private_subnet_ids" {
  description = "IDs of primary private subnets"
  value       = module.vpc_primary.private_subnet_ids
}

output "dr_private_subnet_ids" {
  description = "IDs of DR private subnets"
  value       = module.vpc_dr.private_subnet_ids
}

output "primary_region" {
  description = "Primary region"
  value       = var.primary_region
}

output "dr_region" {
  description = "DR region"
  value       = var.dr_region
}
