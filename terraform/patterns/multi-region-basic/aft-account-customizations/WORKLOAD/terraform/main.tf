data "aws_caller_identity" "current" {}
data "aws_ssm_parameter" "log_archive_catalog" {
  name = "/org/log-archive/catalog"
}

locals {
  account_id          = data.aws_caller_identity.current.account_id
  account_name        = try(var.account_tags["AccountName"], "workload-${local.account_id}")
  primary_vpc_cidr    = try(var.custom_fields["primary_vpc_cidr"], "10.10.0.0/16")
  secondary_vpc_cidr  = try(var.custom_fields["secondary_vpc_cidr"], "10.20.0.0/16")
  enable_replication  = try(var.custom_fields["enable_replication"], "true") == "true"
  backup_schedule     = try(var.custom_fields["backup_schedule"], "cron(0 2 * * ? *)")
  backup_retention    = tonumber(try(var.custom_fields["backup_retention_days"], "30"))
  log_archive_catalog = jsondecode(data.aws_ssm_parameter.log_archive_catalog.value)

  primary_tags = merge(var.account_tags, {
    Region = var.primary_region
    Role   = "primary"
  })

  secondary_tags = merge(var.account_tags, {
    Region = var.secondary_region
    Role   = "secondary"
  })
}

# Security baseline - applied to all accounts
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

# Primary region VPC
module "vpc_primary" {
  source = "../../../../../modules/vpc"

  providers = {
    aws = aws.primary
  }

  name                     = "${local.account_name}-primary"
  cidr_block               = local.primary_vpc_cidr
  availability_zones       = ["${var.primary_region}a", "${var.primary_region}b", "${var.primary_region}c"]
  create_database_subnets  = false
  create_transit_subnets   = false
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = local.primary_tags
}

# Secondary region VPC (DR)
module "vpc_secondary" {
  source = "../../../../../modules/vpc"

  providers = {
    aws = aws.secondary
  }

  name                     = "${local.account_name}-secondary"
  cidr_block               = local.secondary_vpc_cidr
  availability_zones       = ["${var.secondary_region}a", "${var.secondary_region}b", "${var.secondary_region}c"]
  create_database_subnets  = false
  create_transit_subnets   = false
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = local.secondary_tags
}

# Cross-region backup configuration
module "backup" {
  source = "../../../../../modules/backup"

  providers = {
    aws = aws.primary
  }

  name_prefix = "${local.account_name}-primary"
  backup_rules = [
    {
      name              = "daily"
      schedule          = local.backup_schedule
      delete_after      = local.backup_retention
      copy_to_vault_arn = local.enable_replication ? module.backup_secondary.vault_arn : null
      copy_delete_after = local.enable_replication ? local.backup_retention : null
    }
  ]

  tags = local.primary_tags
}

module "backup_secondary" {
  source = "../../../../../modules/backup"

  providers = {
    aws = aws.secondary
  }

  name_prefix = "${local.account_name}-secondary"
  backup_rules = [
    {
      name         = "daily"
      schedule     = local.backup_schedule
      delete_after = local.backup_retention
    }
  ]

  tags = local.secondary_tags
}

# S3 cross-region replication
module "storage_replica" {
  source = "../../../../../modules/storage"

  providers = {
    aws = aws.secondary
  }

  bucket_name       = "${local.account_name}-data-replica"
  enable_versioning = true
  tags              = local.secondary_tags
}

data "aws_iam_policy_document" "replication_assume_role" {
  count = local.enable_replication ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "replication" {
  count = local.enable_replication ? 1 : 0

  name               = "${local.account_name}-s3-replication"
  assume_role_policy = data.aws_iam_policy_document.replication_assume_role[0].json

  tags = local.primary_tags
}

data "aws_iam_policy_document" "replication" {
  count = local.enable_replication ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]
    resources = ["arn:aws:s3:::${local.account_name}-data"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]
    resources = ["arn:aws:s3:::${local.account_name}-data/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner",
    ]
    resources = ["arn:aws:s3:::${local.account_name}-data-replica/*"]
  }
}

resource "aws_iam_role_policy" "replication" {
  count = local.enable_replication ? 1 : 0

  name   = "${local.account_name}-s3-replication"
  role   = aws_iam_role.replication[0].id
  policy = data.aws_iam_policy_document.replication[0].json
}

module "storage_primary" {
  source = "../../../../../modules/storage"

  providers = {
    aws = aws.primary
  }

  depends_on = [aws_iam_role_policy.replication]

  bucket_name                        = "${local.account_name}-data"
  enable_versioning                  = true
  enable_replication                 = local.enable_replication
  replication_role_arn               = local.enable_replication ? aws_iam_role.replication[0].arn : null
  replication_destination_bucket_arn = local.enable_replication ? module.storage_replica.bucket_arn : null

  tags = local.primary_tags
}

# IAM account alias
resource "aws_iam_account_alias" "alias" {
  account_alias = local.account_name
}

# Basic IAM roles for workload access
module "iam_roles" {
  source = "../../../../../modules/iam"

  name_prefix = local.account_name
  tags        = var.account_tags
}
