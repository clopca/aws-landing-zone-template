output "account_id" {
  description = "Provisioned account ID"
  value       = local.account_id
}

output "ssm_parameter_name" {
  description = "SSM parameter name with account info"
  value       = aws_ssm_parameter.account_info.name
}
