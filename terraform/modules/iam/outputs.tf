output "permission_set_arns" {
  description = "Map of permission set names to their ARNs"
  value = {
    for k, v in aws_ssoadmin_permission_set.this : k => v.arn
  }
}

output "default_permission_set_arns" {
  description = "Map of default permission set names to their ARNs"
  value = {
    for k, v in aws_ssoadmin_permission_set.default : k => v.arn
  }
}

output "cross_account_role_arns" {
  description = "Map of cross-account role names to their ARNs"
  value = {
    for k, v in aws_iam_role.cross_account : k => v.arn
  }
}

output "default_cross_account_role_arns" {
  description = "Map of default cross-account role names to their ARNs"
  value = {
    for k, v in aws_iam_role.default_cross_account : k => v.arn
  }
}

output "break_glass_user_arn" {
  description = "ARN of the break-glass IAM user"
  value       = var.create_break_glass_user ? aws_iam_user.break_glass[0].arn : null
}

output "break_glass_user_name" {
  description = "Name of the break-glass IAM user"
  value       = var.create_break_glass_user ? aws_iam_user.break_glass[0].name : null
}

output "custom_policy_arns" {
  description = "Map of custom policy names to their ARNs"
  value = {
    for k, v in aws_iam_policy.custom : k => v.arn
  }
}

output "service_linked_role_arns" {
  description = "Map of service-linked role names to their ARNs"
  value = {
    for k, v in aws_iam_service_linked_role.this : k => v.arn
  }
}
