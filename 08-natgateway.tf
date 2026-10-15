# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-elastic-ip"
  }
}

resource "aws_nat_gateway" "gw" {
  # Elastic IP allocation
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_01.id

  tags = {
    Name = "gw NAT"
  }
}
