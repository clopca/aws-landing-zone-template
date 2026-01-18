data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  az_count   = length(var.availability_zones)
}

resource "aws_ec2_transit_gateway" "main" {
  description                     = "${var.organization_name} Transit Gateway"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.organization_name}-tgw"
  }
}

resource "aws_ec2_transit_gateway_route_table" "main" {
  for_each = toset(var.tgw_route_tables)

  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name = "${var.organization_name}-tgw-rt-${each.key}"
  }
}

resource "aws_ram_resource_share" "tgw" {
  name                      = "${var.organization_name}-tgw-share"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

resource "aws_ram_principal_association" "org" {
  principal          = var.organization_arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}
