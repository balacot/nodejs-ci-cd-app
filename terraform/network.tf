resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Zonas de disponibilidad disponibles
data "aws_availability_zones" "available" {}

# Subnets públicas
resource "aws_subnet" "public" {
  for_each = { "0" = 0, "1" = 1 }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[each.value]
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, each.value)

  tags = {
    Name = "${var.project_name}-public-${each.key}"
  }
}

# Subnets privadas
resource "aws_subnet" "private" {
  for_each = { "0" = 0, "1" = 1 }

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[each.value]
  availability_zone = element(data.aws_availability_zones.available.names, each.value)

  tags = {
    Name = "${var.project_name}-private-${each.key}"
  }
}

# NAT Gateway con Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["0"].id

  tags = {
    Name = "${var.project_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Tabla de rutas públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Tabla de rutas privadas
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-rt-private"
  }
}

resource "aws_route" "private_egress" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
