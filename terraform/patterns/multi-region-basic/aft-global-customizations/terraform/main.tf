data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  account_name = try(var.account_tags["AccountName"], "account-${local.account_id}")
}

# Security baseline applied globally to all AFT-managed accounts
module "security_baseline" {
  source = "../../../../../modules/security-baseline"

  enable_ebs_encryption         = true
  enable_s3_block_public_access = true
  enable_iam_password_policy    = true

  password_min_length        = 14
  password_require_uppercase = true
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = true
  password_max_age           = 90
  password_reuse_prevention  = 24
}

# IAM account alias for easier identification
resource "aws_iam_account_alias" "alias" {
  account_alias = local.account_name
}
