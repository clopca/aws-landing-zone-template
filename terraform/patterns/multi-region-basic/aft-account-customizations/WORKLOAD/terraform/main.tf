data "aws_caller_identity" "current" {}

locals {
  account_id         = data.aws_caller_identity.current.account_id
  account_name       = try(var.account_tags["AccountName"], "workload-${local.account_id}")
  primary_vpc_cidr   = try(var.custom_fields["primary_vpc_cidr"], "10.10.0.0/16")
  secondary_vpc_cidr = try(var.custom_fields["secondary_vpc_cidr"], "10.20.0.0/16")
  enable_replication = try(var.custom_fields["enable_replication"], "true") == "true"
  backup_schedule    = try(var.custom_fields["backup_schedule"], "cron(0 2 * * ? *)")
  backup_retention   = try(var.custom_fields["backup_retention_days"], "30")
}

# Security baseline - applied to all accounts
module "security_baseline" {
  source = "../../../../../../modules/security-baseline"

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

# Primary region VPC
module "vpc_primary" {
  source = "../../../../../../modules/vpc"

  providers = {
    aws = aws.primary
  }

  name               = "${local.account_name}-primary"
  cidr_block         = local.primary_vpc_cidr
  availability_zones = ["${var.primary_region}a", "${var.primary_region}b", "${var.primary_region}c"]
  enable_nat_gateway = true
  single_nat_gateway = false
  enable_flow_logs   = true

  tags = merge(var.account_tags, {
    Region = var.primary_region
    Role   = "primary"
  })
}

# Secondary region VPC (DR)
module "vpc_secondary" {
  source = "../../../../../../modules/vpc"

  providers = {
    aws = aws.secondary
  }

  name               = "${local.account_name}-secondary"
  cidr_block         = local.secondary_vpc_cidr
  availability_zones = ["${var.secondary_region}a", "${var.secondary_region}b", "${var.secondary_region}c"]
  enable_nat_gateway = true
  single_nat_gateway = false
  enable_flow_logs   = true

  tags = merge(var.account_tags, {
    Region = var.secondary_region
    Role   = "secondary"
  })
}

# Cross-region backup configuration
module "backup" {
  source = "../../../../../../modules/backup"

  providers = {
    aws = aws.primary
  }

  vault_name             = "${local.account_name}-backup"
  backup_schedule        = local.backup_schedule
  backup_retention_days  = tonumber(local.backup_retention)
  enable_cross_region    = true
  cross_region_vault_arn = module.backup_secondary.vault_arn

  tags = var.account_tags
}

module "backup_secondary" {
  source = "../../../../../../modules/backup"

  providers = {
    aws = aws.secondary
  }

  vault_name            = "${local.account_name}-backup-dr"
  backup_schedule       = local.backup_schedule
  backup_retention_days = tonumber(local.backup_retention)
  enable_cross_region   = false

  tags = merge(var.account_tags, {
    Role = "disaster-recovery"
  })
}

# S3 cross-region replication
module "storage" {
  source = "../../../../../../modules/storage"

  providers = {
    aws = aws.primary
  }

  bucket_name             = "${local.account_name}-data"
  enable_versioning       = true
  enable_replication      = local.enable_replication
  replication_region      = var.secondary_region
  replication_bucket_name = "${local.account_name}-data-replica"

  tags = var.account_tags
}

# IAM account alias
resource "aws_iam_account_alias" "alias" {
  account_alias = local.account_name
}

# Basic IAM roles for workload access
module "iam_roles" {
  source = "../../../../../../modules/iam"

  account_name = local.account_name
  account_tags = var.account_tags
}
