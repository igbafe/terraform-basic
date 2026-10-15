resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "private-route-table"
  }
}
