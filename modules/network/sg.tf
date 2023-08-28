##### Security Group for EC2 and ALB instances #####
resource "aws_security_group" "allow_tls" {
  name        = "CoalFire_allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.cf_vpc.id

  ingress {
    description = "Allow TCP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

