moved {
  from = aws_vpc.main
  to   = module.shared_services_vpc.aws_vpc.main
}

moved {
  from = aws_subnet.private
  to   = module.shared_services_vpc.aws_subnet.private
}

moved {
  from = aws_subnet.transit
  to   = module.shared_services_vpc.aws_subnet.transit
}

moved {
  from = aws_route_table.private
  to   = module.shared_services_vpc.aws_route_table.private
}

moved {
  from = aws_route_table_association.private
  to   = module.shared_services_vpc.aws_route_table_association.private
}

moved {
  from = aws_route_table_association.transit
  to   = module.shared_services_vpc.aws_route_table_association.transit
}

moved {
  from = aws_ec2_transit_gateway_vpc_attachment.main
  to   = module.shared_services_attachment.aws_ec2_transit_gateway_vpc_attachment.main
}

moved {
  from = aws_ec2_transit_gateway_route_table_association.main
  to   = module.shared_services_attachment.aws_ec2_transit_gateway_route_table_association.main
}
