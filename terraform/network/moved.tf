moved {
  from = aws_vpc.network_hub
  to   = module.hub_vpc.aws_vpc.main
}

moved {
  from = aws_internet_gateway.main
  to   = module.hub_vpc.aws_internet_gateway.main[0]
}

moved {
  from = aws_subnet.public
  to   = module.hub_vpc.aws_subnet.public
}

moved {
  from = aws_subnet.private
  to   = module.hub_vpc.aws_subnet.private
}

moved {
  from = aws_subnet.transit
  to   = module.hub_vpc.aws_subnet.transit
}

moved {
  from = aws_eip.nat
  to   = module.hub_vpc.aws_eip.nat
}

moved {
  from = aws_nat_gateway.main
  to   = module.hub_vpc.aws_nat_gateway.main
}

moved {
  from = aws_route_table.public
  to   = module.hub_vpc.aws_route_table.public
}

moved {
  from = aws_route.public_internet
  to   = module.hub_vpc.aws_route.public_internet
}

moved {
  from = aws_route_table_association.public
  to   = module.hub_vpc.aws_route_table_association.public
}

moved {
  from = aws_route_table.private
  to   = module.hub_vpc.aws_route_table.private
}

moved {
  from = aws_route.private_nat
  to   = module.hub_vpc.aws_route.private_nat
}

moved {
  from = aws_route_table_association.private
  to   = module.hub_vpc.aws_route_table_association.private
}

moved {
  from = aws_route_table.transit
  to   = module.hub_vpc.aws_route_table.transit[0]
}

moved {
  from = aws_route_table_association.transit
  to   = module.hub_vpc.aws_route_table_association.transit
}

moved {
  from = aws_ec2_transit_gateway.main
  to   = module.tgw.aws_ec2_transit_gateway.main
}

moved {
  from = aws_ec2_transit_gateway_route_table.main
  to   = module.tgw.aws_ec2_transit_gateway_route_table.main
}

moved {
  from = aws_ram_resource_share.tgw
  to   = module.tgw.aws_ram_resource_share.main[0]
}

moved {
  from = aws_ram_resource_association.tgw
  to   = module.tgw.aws_ram_resource_association.tgw[0]
}

moved {
  from = aws_ram_principal_association.org
  to   = module.tgw.aws_ram_principal_association.org[0]
}

moved {
  from = aws_ec2_transit_gateway_vpc_attachment.network_hub
  to   = module.hub_attachment.aws_ec2_transit_gateway_vpc_attachment.main
}

moved {
  from = aws_ec2_transit_gateway_route_table_association.network_hub
  to   = module.hub_attachment.aws_ec2_transit_gateway_route_table_association.main
}

moved {
  from = aws_ec2_transit_gateway_route_table_propagation.network_hub
  to   = module.hub_attachment.aws_ec2_transit_gateway_route_table_propagation.main
}

moved {
  from = aws_route53_zone.private
  to   = module.dns.aws_route53_zone.private[0]
}

moved {
  from = aws_ram_resource_share.route53
  to   = module.dns.aws_ram_resource_share.dns[0]
}

moved {
  from = aws_ram_principal_association.route53_org
  to   = module.dns.aws_ram_principal_association.dns[0]
}

moved {
  from = aws_route53_resolver_rule.forward_internal
  to   = module.dns.aws_route53_resolver_rule.internal_forward[0]
}

moved {
  from = aws_security_group.dns
  to   = module.dns.aws_security_group.resolver[0]
}

moved {
  from = aws_route53_resolver_endpoint.inbound
  to   = module.dns.aws_route53_resolver_endpoint.inbound[0]
}

moved {
  from = aws_route53_resolver_endpoint.outbound
  to   = module.dns.aws_route53_resolver_endpoint.outbound[0]
}
