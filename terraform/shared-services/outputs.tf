output "vpc_id" {
  description = "Shared Services VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "ecr_repository_urls" {
  description = "Map of ECR repository names to URLs"
  value = var.enable_ecr ? {
    for repo in aws_ecr_repository.main : repo.name => repo.repository_url
  } : {}
}
