module "tgw" {
  source = "../modules/transit-gateway"

  name             = "${var.organization_name}-tgw"
  route_tables     = var.tgw_route_tables
  organization_arn = var.organization_arn

  tags = {
    Component = "transit-gateway"
  }
}
