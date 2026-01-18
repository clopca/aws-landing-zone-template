resource "aws_ec2_transit_gateway" "main" {
  description                     = "${var.name} Transit Gateway"
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_transit_gateway_route_table" "main" {
  for_each = toset(var.route_tables)

  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
  })
}

resource "aws_ram_resource_share" "main" {
  count = var.share_with_organization ? 1 : 0

  name                      = "${var.name}-share"
  allow_external_principals = false

  tags = var.tags
}

resource "aws_ram_resource_association" "tgw" {
  count = var.share_with_organization ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.main[0].arn
}

resource "aws_ram_principal_association" "org" {
  count = var.share_with_organization && var.organization_arn != "" ? 1 : 0

  principal          = var.organization_arn
  resource_share_arn = aws_ram_resource_share.main[0].arn
}
