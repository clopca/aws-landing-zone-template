data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_ssm_parameter" "tgw_id" {
  name = "/org/network/transit-gateway-id"
}

locals {
  vpc_cidr     = try(var.custom_fields["vpc_cidr"], "10.10.0.0/16")
  requires_tgw = try(var.custom_fields["requires_tgw"], "true") == "true"
  account_name = try(var.account_tags["AccountName"], "workload")
  region       = data.aws_region.current.id
}

module "vpc" {
  source = "../../../../modules/vpc"

  name               = local.account_name
  cidr_block         = local.vpc_cidr
  availability_zones = ["${local.region}a", "${local.region}b", "${local.region}c"]
  enable_nat_gateway = true
  single_nat_gateway = false
  enable_flow_logs   = true

  tags = var.account_tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = local.requires_tgw ? 1 : 0

  subnet_ids                                      = module.vpc.transit_subnet_ids
  transit_gateway_id                              = data.aws_ssm_parameter.tgw_id.value
  vpc_id                                          = module.vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(var.account_tags, {
    Name = "${local.account_name}-tgw-attachment"
  })
}

resource "aws_route" "tgw_default" {
  count = local.requires_tgw ? length(module.vpc.private_route_table_ids) : 0

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = data.aws_ssm_parameter.tgw_id.value

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.main]
}
