output "aft_request_metadata_table_name" {
  description = "AFT request metadata DynamoDB table name"
  value       = module.aft.aft_request_metadata_table_name
}

output "aft_controltower_events_table_name" {
  description = "AFT Control Tower events DynamoDB table name"
  value       = module.aft.aft_controltower_events_table_name
}

output "aft_invoke_aft_account_provisioning_framework_lambda_function_name" {
  description = "AFT invoke provisioning framework Lambda function name"
  value       = module.aft.aft_invoke_aft_account_provisioning_framework_lambda_function_name
}

output "aft_account_provisioning_framework_sfn_name" {
  description = "AFT account provisioning framework Step Function name"
  value       = module.aft.aft_account_provisioning_framework_sfn_name
}

output "aft_sns_topic_arn" {
  description = "AFT SNS topic ARN for notifications"
  value       = module.aft.aft_sns_topic_arn
}

output "aft_failure_sns_topic_arn" {
  description = "AFT failure SNS topic ARN"
  value       = module.aft.aft_failure_sns_topic_arn
}
