resource "aws_security_group" "resolver" {
  count = var.create_resolver_endpoints ? 1 : 0

  name        = "${var.name_prefix}-resolver-sg"
  description = "Security group for Route53 Resolver endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = var.resolver_allowed_cidrs
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = var.resolver_allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-resolver-sg"
  })
}

resource "aws_route53_resolver_endpoint" "inbound" {
  count = var.create_inbound_endpoint ? 1 : 0

  name      = "${var.name_prefix}-inbound"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.resolver[0].id]

  dynamic "ip_address" {
    for_each = var.resolver_subnet_ids
    content {
      subnet_id = ip_address.value
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_endpoint" "outbound" {
  count = var.create_outbound_endpoint ? 1 : 0

  name      = "${var.name_prefix}-outbound"
  direction = "OUTBOUND"

  security_group_ids = [aws_security_group.resolver[0].id]

  dynamic "ip_address" {
    for_each = var.resolver_subnet_ids
    content {
      subnet_id = ip_address.value
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_rule" "forward" {
  for_each = var.create_outbound_endpoint ? var.forward_rules : {}

  domain_name          = each.value.domain_name
  name                 = each.key
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound[0].id

  dynamic "target_ip" {
    for_each = each.value.target_ips
    content {
      ip   = target_ip.value.ip
      port = target_ip.value.port
    }
  }

  tags = var.tags
}

resource "aws_ram_resource_share" "resolver_rules" {
  count = var.create_outbound_endpoint && var.share_rules_with_organization ? 1 : 0

  name                      = "${var.name_prefix}-resolver-rules-share"
  allow_external_principals = false

  tags = var.tags
}

resource "aws_ram_resource_association" "resolver_rules" {
  for_each = var.create_outbound_endpoint && var.share_rules_with_organization ? var.forward_rules : {}

  resource_arn       = aws_route53_resolver_rule.forward[each.key].arn
  resource_share_arn = aws_ram_resource_share.resolver_rules[0].arn
}

resource "aws_ram_principal_association" "resolver_rules" {
  count = var.create_outbound_endpoint && var.share_rules_with_organization ? 1 : 0

  principal          = var.organization_arn
  resource_share_arn = aws_ram_resource_share.resolver_rules[0].arn
}
