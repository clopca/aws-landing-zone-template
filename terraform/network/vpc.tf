resource "aws_vpc" "network_hub" {
  cidr_block           = var.network_hub_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.organization_name}-network-hub"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.network_hub.id

  tags = {
    Name = "${var.organization_name}-igw"
  }
}

resource "aws_subnet" "public" {
  count = local.az_count

  vpc_id                  = aws_vpc.network_hub.id
  cidr_block              = cidrsubnet(var.network_hub_cidr, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.organization_name}-public-${var.availability_zones[count.index]}"
    Tier = "public"
  }
}

resource "aws_subnet" "private" {
  count = local.az_count

  vpc_id            = aws_vpc.network_hub.id
  cidr_block        = cidrsubnet(var.network_hub_cidr, 4, count.index + 4)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.organization_name}-private-${var.availability_zones[count.index]}"
    Tier = "private"
  }
}

resource "aws_subnet" "transit" {
  count = local.az_count

  vpc_id            = aws_vpc.network_hub.id
  cidr_block        = cidrsubnet(var.network_hub_cidr, 4, count.index + 8)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.organization_name}-transit-${var.availability_zones[count.index]}"
    Tier = "transit"
  }
}

resource "aws_eip" "nat" {
  count = local.az_count

  domain = "vpc"

  tags = {
    Name = "${var.organization_name}-nat-${var.availability_zones[count.index]}"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  count = local.az_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.organization_name}-nat-${var.availability_zones[count.index]}"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network_hub.id

  tags = {
    Name = "${var.organization_name}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = local.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = local.az_count

  vpc_id = aws_vpc.network_hub.id

  tags = {
    Name = "${var.organization_name}-private-rt-${var.availability_zones[count.index]}"
  }
}

resource "aws_route" "private_nat" {
  count = local.az_count

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "private" {
  count = local.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table" "transit" {
  vpc_id = aws_vpc.network_hub.id

  tags = {
    Name = "${var.organization_name}-transit-rt"
  }
}

resource "aws_route_table_association" "transit" {
  count = local.az_count

  subnet_id      = aws_subnet.transit[count.index].id
  route_table_id = aws_route_table.transit.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "network_hub" {
  subnet_ids                                      = aws_subnet.transit[*].id
  transit_gateway_id                              = aws_ec2_transit_gateway.main.id
  vpc_id                                          = aws_vpc.network_hub.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${var.organization_name}-network-hub-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "network_hub" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.network_hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main["shared"].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "network_hub" {
  for_each = aws_ec2_transit_gateway_route_table.main

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.network_hub.id
  transit_gateway_route_table_id = each.value.id
}
