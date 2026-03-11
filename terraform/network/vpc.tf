data "aws_ssm_parameter" "log_archive_catalog" {
  name = "/org/log-archive/catalog"
}

locals {
  log_archive_catalog = jsondecode(data.aws_ssm_parameter.log_archive_catalog.value)
}

module "hub_vpc" {
  source = "../modules/vpc"

  name                     = var.organization_name
  cidr_block               = var.network_hub_cidr
  availability_zones       = var.availability_zones
  create_database_subnets  = false
  create_transit_subnets   = true
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = {
    Component = "network-hub"
  }
}

module "hub_attachment" {
  source = "../modules/tgw-attachment"

  name                        = "${var.organization_name}-network-hub-attachment"
  transit_gateway_id          = module.tgw.transit_gateway_id
  vpc_id                      = module.hub_vpc.vpc_id
  subnet_ids                  = module.hub_vpc.transit_subnet_ids
  association_route_table_id  = module.tgw.route_table_ids["shared"]
  propagation_route_table_ids = values(module.tgw.route_table_ids)

  tags = {
    Component = "network-hub"
  }
}
