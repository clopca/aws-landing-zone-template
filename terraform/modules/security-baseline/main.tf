resource "aws_ebs_encryption_by_default" "main" {
  count = var.enable_ebs_encryption ? 1 : 0

  enabled = true
}

resource "aws_s3_account_public_access_block" "main" {
  count = var.enable_s3_block_public_access ? 1 : 0

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_account_password_policy" "main" {
  count = var.enable_iam_password_policy ? 1 : 0

  minimum_password_length        = var.password_min_length
  require_uppercase_characters   = var.password_require_uppercase
  require_lowercase_characters   = var.password_require_lowercase
  require_numbers                = var.password_require_numbers
  require_symbols                = var.password_require_symbols
  allow_users_to_change_password = true
  max_password_age               = var.password_max_age
  password_reuse_prevention      = var.password_reuse_prevention
  hard_expiry                    = false
}
