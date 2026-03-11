output "vpc_id" {
  description = "Shared Services VPC ID"
  value       = module.shared_services_vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.shared_services_vpc.private_subnet_ids
}

output "transit_subnet_ids" {
  description = "Transit subnet IDs"
  value       = module.shared_services_vpc.transit_subnet_ids
}

output "ecr_repository_urls" {
  description = "Map of ECR repository names to URLs"
  value = var.enable_ecr ? {
    for repo in aws_ecr_repository.main : repo.name => repo.repository_url
  } : {}
}
