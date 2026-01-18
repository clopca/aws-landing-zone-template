output "bastion_instance_id" {
  description = "ID of the bastion EC2 instance"
  value       = var.enable_bastion && !var.enable_bastion_auto_scaling ? aws_instance.bastion[0].id : null
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = var.enable_bastion && !var.enable_bastion_auto_scaling ? aws_instance.bastion[0].private_ip : null
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host (if assigned)"
  value       = var.enable_bastion && !var.enable_bastion_auto_scaling && var.associate_public_ip ? aws_instance.bastion[0].public_ip : null
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = var.enable_bastion ? aws_security_group.bastion[0].id : null
}

output "bastion_iam_role_arn" {
  description = "ARN of the bastion IAM role"
  value       = var.enable_bastion ? aws_iam_role.bastion[0].arn : null
}

output "bastion_iam_role_name" {
  description = "Name of the bastion IAM role"
  value       = var.enable_bastion ? aws_iam_role.bastion[0].name : null
}

output "bastion_instance_profile_arn" {
  description = "ARN of the bastion instance profile"
  value       = var.enable_bastion ? aws_iam_instance_profile.bastion[0].arn : null
}

output "bastion_autoscaling_group_name" {
  description = "Name of the bastion auto scaling group (if enabled)"
  value       = var.enable_bastion && var.enable_bastion_auto_scaling ? aws_autoscaling_group.bastion[0].name : null
}

output "bastion_launch_template_id" {
  description = "ID of the bastion launch template (if ASG enabled)"
  value       = var.enable_bastion && var.enable_bastion_auto_scaling ? aws_launch_template.bastion[0].id : null
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for bastion logs"
  value       = var.enable_bastion && var.enable_cloudwatch_agent ? aws_cloudwatch_log_group.bastion[0].name : null
}

output "session_manager_log_group_name" {
  description = "Name of the CloudWatch log group for Session Manager logs"
  value       = var.enable_bastion && var.enable_session_manager_logging ? aws_cloudwatch_log_group.session_manager[0].name : null
}

output "ssm_connect_command" {
  description = "AWS CLI command to connect to bastion via Session Manager"
  value       = var.enable_bastion && !var.enable_bastion_auto_scaling ? "aws ssm start-session --target ${aws_instance.bastion[0].id}" : null
}
