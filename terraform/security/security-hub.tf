resource "aws_securityhub_account" "main" {
  count = var.enable_security_hub ? 1 : 0

  enable_default_standards = false
}

resource "aws_securityhub_organization_admin_account" "main" {
  count = var.enable_security_hub ? 1 : 0

  admin_account_id = data.aws_caller_identity.current.account_id

  depends_on = [aws_securityhub_account.main]
}

resource "aws_securityhub_organization_configuration" "main" {
  count = var.enable_security_hub ? 1 : 0

  auto_enable           = true
  auto_enable_standards = "DEFAULT"

  depends_on = [aws_securityhub_organization_admin_account.main]
}

resource "aws_securityhub_standards_subscription" "cis" {
  count = var.enable_security_hub && contains(var.security_hub_standards, "cis-aws-foundations-benchmark/v/1.4.0") ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/1.4.0"

  depends_on = [aws_securityhub_account.main]
}

resource "aws_securityhub_standards_subscription" "aws_foundational" {
  count = var.enable_security_hub && contains(var.security_hub_standards, "aws-foundational-security-best-practices/v/1.0.0") ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"

  depends_on = [aws_securityhub_account.main]
}
