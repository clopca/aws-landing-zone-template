resource "aws_ssm_parameter" "catalog" {
  name = "/org/network/catalog"
  type = "String"
  value = jsonencode({
    transit_gateway_id     = module.tgw.transit_gateway_id
    transit_gateway_arn    = module.tgw.transit_gateway_arn
    route_table_ids        = module.tgw.route_table_ids
    vpc_id                 = module.hub_vpc.vpc_id
    private_subnet_ids     = module.hub_vpc.private_subnet_ids
    transit_subnet_ids     = module.hub_vpc.transit_subnet_ids
    private_hosted_zone_id = module.dns.private_zone_id
  })
}
