output "vault_arn" {
  description = "Backup vault ARN"
  value       = aws_backup_vault.main.arn
}

output "vault_name" {
  description = "Backup vault name"
  value       = aws_backup_vault.main.name
}

output "plan_id" {
  description = "Backup plan ID"
  value       = aws_backup_plan.main.id
}

output "plan_arn" {
  description = "Backup plan ARN"
  value       = aws_backup_plan.main.arn
}

output "role_arn" {
  description = "Backup IAM role ARN"
  value       = aws_iam_role.backup.arn
}
