resource "aws_vpc" "ntier" {
  cidr_block = var.ntier_vpc_info.vpc_cidr
  tags = {
    Name = "ntier"
  }
}
resource "aws_subnet" "public_subnets" {
  count             = length(var.ntier_vpc_info.public_subnet_names)
  cidr_block        = cidrsubnet(var.ntier_vpc_info.vpc_cidr, 8, count.index)
  availability_zone = "${var.region}${var.ntier_vpc_info.public_subnet_azs[count.index]}"
  vpc_id            = aws_vpc.ntier.id #implicit dependency
  depends_on = [
    aws_vpc.ntier
  ]
  map_public_ip_on_launch = true
  tags = {
    Name = var.ntier_vpc_info.public_subnet_names[count.index]
  }
}
resource "aws_subnet" "private_subnets" {
  count             = length(var.ntier_vpc_info.private_subnet_names)
  cidr_block        = cidrsubnet(var.ntier_vpc_info.vpc_cidr, 8, length(var.ntier_vpc_info.public_subnet_names) + count.index)
  availability_zone = "${var.region}${var.ntier_vpc_info.private_subnet_azs[count.index]}"
  vpc_id            = aws_vpc.ntier.id #implicit dependency
  depends_on = [
    aws_vpc.ntier
  ]
  tags = {
    Name = var.ntier_vpc_info.private_subnet_names[count.index]
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "my_igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ntier.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "public_rt"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "private_rt"
  }
}
resource "aws_route_table_association" "public_associate" {
  count          = length(var.ntier_vpc_info.public_subnet_names)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_associate" {
  count          = length(var.ntier_vpc_info.private_subnet_names)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
