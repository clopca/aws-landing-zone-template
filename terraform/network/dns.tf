resource "aws_route53_zone" "private" {
  name = var.private_hosted_zone_name

  vpc {
    vpc_id = aws_vpc.network_hub.id
  }

  lifecycle {
    ignore_changes = [vpc]
  }

  tags = {
    Name = var.private_hosted_zone_name
  }
}

resource "aws_ram_resource_share" "route53" {
  name                      = "${var.organization_name}-route53-share"
  allow_external_principals = false
}

resource "aws_ram_principal_association" "route53_org" {
  principal          = var.organization_arn
  resource_share_arn = aws_ram_resource_share.route53.arn
}

resource "aws_route53_resolver_rule" "forward_internal" {
  count = var.enable_dns_firewall ? 1 : 0

  domain_name          = var.private_hosted_zone_name
  name                 = "${var.organization_name}-forward-internal"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound[0].id

  dynamic "target_ip" {
    for_each = aws_route53_resolver_endpoint.inbound[0].ip_address
    content {
      ip = target_ip.value.ip
    }
  }

  tags = {
    Name = "${var.organization_name}-forward-internal"
  }
}

resource "aws_ram_resource_association" "resolver_rule" {
  count = var.enable_dns_firewall ? 1 : 0

  resource_arn       = aws_route53_resolver_rule.forward_internal[0].arn
  resource_share_arn = aws_ram_resource_share.route53.arn
}

resource "aws_security_group" "dns" {
  count = var.enable_dns_firewall ? 1 : 0

  name        = "${var.organization_name}-dns-resolver"
  description = "Security group for Route53 Resolver endpoints"
  vpc_id      = aws_vpc.network_hub.id

  ingress {
    description = "DNS TCP"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "DNS UDP"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.organization_name}-dns-resolver-sg"
  }
}

resource "aws_route53_resolver_endpoint" "inbound" {
  count = var.enable_dns_firewall ? 1 : 0

  name               = "${var.organization_name}-inbound"
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.dns[0].id]

  dynamic "ip_address" {
    for_each = aws_subnet.private[*].id
    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Name = "${var.organization_name}-inbound-resolver"
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  count = var.enable_dns_firewall ? 1 : 0

  name               = "${var.organization_name}-outbound"
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.dns[0].id]

  dynamic "ip_address" {
    for_each = aws_subnet.private[*].id
    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Name = "${var.organization_name}-outbound-resolver"
  }
}
