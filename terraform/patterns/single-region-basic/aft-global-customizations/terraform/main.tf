terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "security_baseline" {
  source = "../../../../modules/security-baseline"

  enable_ebs_encryption         = var.enable_ebs_encryption
  enable_s3_block_public_access = var.enable_s3_block_public_access
  enable_iam_password_policy    = var.enable_iam_password_policy

  password_min_length        = var.password_min_length
  password_require_uppercase = true
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = true
  password_max_age           = var.password_max_age
  password_reuse_prevention  = var.password_reuse_prevention
}
