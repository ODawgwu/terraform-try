variable "cidr_block" {
  description = "vpc cidr range"
}

# variable "tags" {
#   description = "vpc cidr range"
# }

# variable "azs" {
#   description = "A list of availability zones names or ids in the region"
#   type        = list(string)
#   default     = []
# }

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  # default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidr" {
  type = list(string)
  # default = ["10.1.0.0/24", "10.1.1.0/24"]
}

variable "private_subnet_cidr" {
  type = list(string)
  # default = ["10.1.2.0/24", "10.1.3.0/24"]
}

# variable "private_subnet_association_ids" {
#   type    = list(string)
#   default = [aws_subnet.cf_private_subnet[0].id, aws_subnet.cf_private_subnet[1].id]
# }

variable "tags" {}

# variable "ami" {}

variable "instance_type" {}

variable "bucketname" {}