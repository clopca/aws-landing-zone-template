terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "vpc" {
  source = "../../../../modules/vpc"

  name               = "${var.environment}-vpc"
  cidr_block         = var.vpc_cidr
  availability_zones = var.availability_zones

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway

  enable_flow_logs          = var.enable_vpc_flow_logs
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_destination_arn  = var.enable_vpc_flow_logs ? aws_cloudwatch_log_group.vpc_flow_logs[0].arn : ""

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  name              = "/aws/vpc/${var.environment}-flow-logs"
  retention_in_days = var.flow_log_retention_days

  tags = var.tags
}
