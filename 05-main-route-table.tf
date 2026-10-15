# 1. Find the existing main route table
data "aws_route_table" "default" {
  vpc_id = aws_vpc.terraform_vpc.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# 2. Add a Name tag to the existing route table
resource "aws_ec2_tag" "public_route_table_name" {
  resource_id = data.aws_route_table.default.id

  key   = "Name"
  value = "public-route-table"
}