# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({
    Name = "${var.name_prefix}-vpc"

  })
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    Name = "${var.name_prefix}-igw"
  })
}
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge({
    Name = "${var.name_prefix}-public-${count.index}"
    tier = "public"
  })
}

# Pr.s
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge({
    Name = "${var.name_prefix}-private-${count.index}"
    tier = "application"
  })
}
# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    Name = "${var.name_prefix}-private-rt"

  })
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Prt
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    Name = "${var.name_prefix}-public-rt"

  })
}

# Rta
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


