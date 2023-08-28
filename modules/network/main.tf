resource "aws_vpc" "cf_vpc" {
  cidr_block = var.cidr_block
  # tags = var.tags
}

resource "aws_internet_gateway" "cf_igw" {
  vpc_id = aws_vpc.cf_vpc.id
}