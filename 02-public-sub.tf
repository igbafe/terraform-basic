resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-01"
  }
}

resource "aws_route_table_association" "public_subnet_01_association" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = data.aws_route_table.default.id
}



resource "aws_subnet" "public_subnet_02" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-02"
  }
}

resource "aws_route_table_association" "public_subnet_02_association" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = data.aws_route_table.default.id
}
