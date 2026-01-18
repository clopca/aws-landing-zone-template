resource "aws_config_configuration_aggregator" "organization" {
  count = var.enable_config_aggregator ? 1 : 0

  name = "organization-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.config_aggregator[0].arn
  }
}

resource "aws_iam_role" "config_aggregator" {
  count = var.enable_config_aggregator ? 1 : 0

  name = "aws-config-aggregator-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config_aggregator" {
  count = var.enable_config_aggregator ? 1 : 0

  role       = aws_iam_role.config_aggregator[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_accessanalyzer_analyzer" "organization" {
  count = var.enable_access_analyzer ? 1 : 0

  analyzer_name = "organization-analyzer"
  type          = "ORGANIZATION"
}

resource "aws_sns_topic" "security_alerts" {
  count = length(var.security_notification_emails) > 0 ? 1 : 0

  name              = "security-alerts"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "security_alerts_email" {
  for_each = toset(var.security_notification_emails)

  topic_arn = aws_sns_topic.security_alerts[0].arn
  protocol  = "email"
  endpoint  = each.value
}
