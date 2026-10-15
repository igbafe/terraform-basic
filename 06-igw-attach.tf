 resource "aws_route" "public_internet_route" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}