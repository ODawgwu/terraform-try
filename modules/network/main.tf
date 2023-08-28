resource "aws_vpc" "cf_vpc" {
  cidr_block = var.cidr_block
  # tags = var.tags
}

resource "aws_internet_gateway" "cf_igw" {
  vpc_id = aws_vpc.cf_vpc.id
}

############# Public Subnets ############################
####################################################################################








# resource "aws_route_table_association" "private_subnet1_association" {
#   subnet_id      = aws_subnet.sub3.id
#   route_table_id = aws_route_table.private_rt1.id
# }

# resource "aws_route_table_association" "private_subnet2_association" {
#   subnet_id      = aws_subnet.sub4.id
#   route_table_id = aws_route_table.private_rt2.id
# }