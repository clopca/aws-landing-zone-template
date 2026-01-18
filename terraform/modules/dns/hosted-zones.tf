# Private Hosted Zone
resource "aws_route53_zone" "private" {
  count = var.create_private_hosted_zone ? 1 : 0

  name = var.private_zone_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.tags, {
    Name = var.private_zone_name
  })

  lifecycle {
    ignore_changes = [vpc]
  }
}

# Associate additional VPCs with the hosted zone
resource "aws_route53_zone_association" "additional" {
  for_each = var.create_private_hosted_zone ? toset(var.additional_vpc_ids) : []

  zone_id = aws_route53_zone.private[0].zone_id
  vpc_id  = each.value
}

# RAM Share for cross-account zone sharing
resource "aws_ram_resource_share" "dns" {
  count = var.create_private_hosted_zone && var.share_zone_with_organization ? 1 : 0

  name                      = "${var.name_prefix}-dns-share"
  allow_external_principals = false

  tags = var.tags
}

resource "aws_ram_resource_association" "dns" {
  count = var.create_private_hosted_zone && var.share_zone_with_organization ? 1 : 0

  resource_arn       = aws_route53_zone.private[0].arn
  resource_share_arn = aws_ram_resource_share.dns[0].arn
}

resource "aws_ram_principal_association" "dns" {
  count = var.create_private_hosted_zone && var.share_zone_with_organization ? 1 : 0

  principal          = var.organization_arn
  resource_share_arn = aws_ram_resource_share.dns[0].arn
}
