resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private resources"
  vpc_id      = aws_vpc.terraform_vpc.id

  # ingress {
  # description     = "Allow application traffic from public resources"
  # from_port       = 8080
  # to_port         = 8080
  # protocol        = "tcp"
  # security_groups = [aws_security_group.public_sg.id]
  # }

  ingress {
    description = "Allow SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}
