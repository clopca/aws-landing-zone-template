terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

data "aws_caller_identity" "current" {}

module "vpc_primary" {
  source = "../../../../modules/vpc"
  providers = {
    aws = aws.primary
  }

  name               = "${var.environment}-vpc-primary"
  cidr_block         = var.primary_vpc_cidr
  availability_zones = var.primary_availability_zones

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway

  enable_flow_logs          = var.enable_vpc_flow_logs
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_destination_arn  = var.enable_vpc_flow_logs ? aws_cloudwatch_log_group.vpc_flow_logs_primary[0].arn : ""

  tags = merge(var.tags, {
    Region = var.primary_region
    Role   = "primary"
  })
}

module "vpc_dr" {
  source = "../../../../modules/vpc"
  providers = {
    aws = aws.dr
  }

  name               = "${var.environment}-vpc-dr"
  cidr_block         = var.dr_vpc_cidr
  availability_zones = var.dr_availability_zones

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = var.enable_nat_gateway_dr
  single_nat_gateway   = true

  enable_flow_logs          = var.enable_vpc_flow_logs
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_destination_arn  = var.enable_vpc_flow_logs ? aws_cloudwatch_log_group.vpc_flow_logs_dr[0].arn : ""

  tags = merge(var.tags, {
    Region = var.dr_region
    Role   = "disaster-recovery"
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs_primary" {
  count    = var.enable_vpc_flow_logs ? 1 : 0
  provider = aws.primary

  name              = "/aws/vpc/${var.environment}-flow-logs-primary"
  retention_in_days = var.flow_log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs_dr" {
  count    = var.enable_vpc_flow_logs ? 1 : 0
  provider = aws.dr

  name              = "/aws/vpc/${var.environment}-flow-logs-dr"
  retention_in_days = var.flow_log_retention_days

  tags = var.tags
}
