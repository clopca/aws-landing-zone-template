output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.permission_sets.arn
}

output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.permission_sets.name
}

output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project"
  value       = aws_codebuild_project.permission_sets.arn
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.permission_sets.name
}

output "artifacts_bucket_arn" {
  description = "ARN of the S3 artifacts bucket"
  value       = aws_s3_bucket.artifacts.arn
}

output "artifacts_bucket_name" {
  description = "Name of the S3 artifacts bucket"
  value       = aws_s3_bucket.artifacts.bucket
}

output "approval_topic_arn" {
  description = "ARN of the SNS topic for approvals (if enabled)"
  value       = var.enable_manual_approval ? aws_sns_topic.approval[0].arn : null
}

output "codepipeline_role_arn" {
  description = "ARN of the CodePipeline IAM role"
  value       = aws_iam_role.codepipeline.arn
}

output "codebuild_role_arn" {
  description = "ARN of the CodeBuild IAM role"
  value       = aws_iam_role.codebuild.arn
}
