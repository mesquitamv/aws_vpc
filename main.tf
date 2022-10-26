data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnet
  cidr_block        = each.value["subnet_cidr_block"]
  availability_zone = each.value["availability_zone"]
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnet
  cidr_block              = each.value["subnet_cidr_block"]
  availability_zone       = each.value["availability_zone"]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "gw" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw" {
  subnet_id     = aws_subnet.public_subnet[keys(aws_subnet.public_subnet)[0]].id
  allocation_id = aws_eip.gw.id
}

# ### To Apply
resource "aws_route_table" "private_rt" {
  vpc_id   = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id   = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "private_rt_association" {
  for_each       = var.private_subnet
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = var.public_subnet
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "ia_main_route_table" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
