locals {
  private_subnet_association_ids = [
    aws_subnet.cf_private_subnet[0].id,
    aws_subnet.cf_private_subnet[1].id,
  ]

  subnet_tags = {
    Name        = "${var.tags["Name"]}"
    Environment = var.tags["Environment"]
  }
}

########## Create private and public subnets ############
###################################################################
resource "aws_subnet" "cf_private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.cf_vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(local.subnet_tags, {
    Name             = "${local.subnet_tags["Name"]}-Private-Subnet-${count.index + 1}-${element(var.azs, count.index)}"
    Type             = "Private"
    AvailabilityZone = element(var.azs, count.index)
  })
}

resource "aws_subnet" "cf_public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.cf_vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(local.subnet_tags, {
    Name             = "${local.subnet_tags["Name"]}-Public-Subnet-${count.index + 1}-${element(var.azs, count.index)}"
    Type             = "Public"
    AvailabilityZone = element(var.azs, count.index)
  })
}

# Create public route table
resource "aws_route_table" "cf_public_rt" {
  vpc_id = aws_vpc.cf_vpc.id
}

# Create public subnet routes
resource "aws_route" "public_subnet_rt" {
  route_table_id         = aws_route_table.cf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cf_igw.id
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.cf_public_subnet[count.index].id
  route_table_id = aws_route_table.cf_public_rt.id
}

# Create private route tables
resource "aws_route_table" "cf_private_rt" {
  vpc_id = aws_vpc.cf_vpc.id
}

# Associate private subnets with private route tables
# resource "aws_route_table_association" "private_subnet_association" {
#   count           = 2
#   subnet_id       = aws_subnet.cf_private_subnet[count.index + 2].id
#   route_table_id = aws_route_table.cf_private_rt.id
# }

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(local.private_subnet_association_ids)
  subnet_id      = local.private_subnet_association_ids[count.index]
  route_table_id = aws_route_table.cf_private_rt.id
}


####### NAT Gateway Resources ##########
################################################################################

# Create Elastic IPs for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = 1
  allocation_id = aws_eip.nat_eip.id
  # subnet_id     = aws_subnet.cf_public_subnet.id
  subnet_id = aws_subnet.cf_public_subnet[count.index].id

  # depends_on = [ aws_eip.nat_eip ]
  depends_on = [aws_internet_gateway.cf_igw]
}

# Create NAT route in private route table
resource "aws_route" "private_nat_route" {
  count                  = 1
  route_table_id         = aws_route_table.cf_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
  # nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

