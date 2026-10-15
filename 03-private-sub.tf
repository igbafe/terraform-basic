resource "aws_subnet" "private_subnet_01" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private-subnet-01"
  }
}

resource "aws_route_table_association" "private_subnet_01_association" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private-subnet-02"
  }
}

resource "aws_route_table_association" "private_subnet_02_association" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.private_route_table.id
}
