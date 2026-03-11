data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_ssm_parameter" "log_archive_catalog" {
  name = "/org/log-archive/catalog"
}

locals {
  account_id          = data.aws_caller_identity.current.account_id
  account_name        = try(var.account_tags["AccountName"], "workload-${local.account_id}")
  vpc_cidr            = try(var.custom_fields["vpc_cidr"], "10.10.0.0/16")
  region              = data.aws_region.current.id
  log_archive_catalog = jsondecode(data.aws_ssm_parameter.log_archive_catalog.value)
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

# VPC with public and private subnets
module "vpc" {
  source = "../../../../../modules/vpc"

  name                     = local.account_name
  cidr_block               = local.vpc_cidr
  availability_zones       = ["${local.region}a", "${local.region}b", "${local.region}c"]
  create_database_subnets  = false
  create_transit_subnets   = false
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = var.account_tags
}

# IAM account alias for easier identification
resource "aws_iam_account_alias" "alias" {
  account_alias = local.account_name
}

# Basic IAM roles for workload access
module "iam_roles" {
  source = "../../../../../modules/iam"

  name_prefix = local.account_name
  tags        = var.account_tags
}
