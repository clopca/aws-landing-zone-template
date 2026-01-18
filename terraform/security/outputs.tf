output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = var.enable_guardduty ? aws_guardduty_detector.main[0].id : null
}

output "security_hub_arn" {
  description = "Security Hub ARN"
  value       = var.enable_security_hub ? aws_securityhub_account.main[0].id : null
}

output "config_aggregator_arn" {
  description = "Config aggregator ARN"
  value       = var.enable_config_aggregator ? aws_config_configuration_aggregator.organization[0].arn : null
}

output "access_analyzer_arn" {
  description = "Access Analyzer ARN"
  value       = var.enable_access_analyzer ? aws_accessanalyzer_analyzer.organization[0].arn : null
}

output "sns_topic_arn" {
  description = "SNS topic ARN for security alerts"
  value       = length(var.security_notification_emails) > 0 ? aws_sns_topic.security_alerts[0].arn : null
}
