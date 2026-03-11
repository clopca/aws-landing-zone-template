resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_transit_gateway_route_table_association" "main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = var.association_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "main" {
  for_each = toset(var.propagation_route_table_ids)

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.main.id
  transit_gateway_route_table_id = each.value
}

resource "aws_route" "spoke" {
  for_each = {
    for combo in setproduct(toset(var.spoke_route_table_ids), toset(var.destination_cidrs)) :
    "${combo[0]}|${combo[1]}" => {
      route_table_id = combo[0]
      cidr_block     = combo[1]
    }
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_route_table_association.main]
}
