data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_ssm_parameter" "network_catalog" {
  name = "/org/network/catalog"
}

data "aws_ssm_parameter" "log_archive_catalog" {
  name = "/org/log-archive/catalog"
}

locals {
  vpc_cidr            = try(var.custom_fields["vpc_cidr"], "10.10.0.0/16")
  requires_tgw        = try(var.custom_fields["requires_tgw"], "true") == "true"
  account_name        = try(var.account_tags["AccountName"], "workload")
  region              = data.aws_region.current.id
  network_catalog     = jsondecode(data.aws_ssm_parameter.network_catalog.value)
  log_archive_catalog = jsondecode(data.aws_ssm_parameter.log_archive_catalog.value)
}

module "vpc" {
  source = "../../../../modules/vpc"

  name                     = local.account_name
  cidr_block               = local.vpc_cidr
  availability_zones       = ["${local.region}a", "${local.region}b", "${local.region}c"]
  create_transit_subnets   = local.requires_tgw
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = var.account_tags
}

module "tgw_attachment" {
  count  = local.requires_tgw ? 1 : 0
  source = "../../../../modules/tgw-attachment"

  name                       = "${local.account_name}-tgw-attachment"
  transit_gateway_id         = local.network_catalog.transit_gateway_id
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.transit_subnet_ids
  association_route_table_id = local.network_catalog.route_table_ids.production
  propagation_route_table_ids = [
    local.network_catalog.route_table_ids.production,
    local.network_catalog.route_table_ids.shared,
  ]
  spoke_route_table_ids = module.vpc.private_route_table_ids
  destination_cidrs     = ["10.0.0.0/8"]
  tags                  = var.account_tags
}
