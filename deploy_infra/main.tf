module "us-east-1" {
  source = "../modules/network/"

  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr  = ["10.1.0.0/24", "10.1.1.0/24"]
  private_subnet_cidr = ["10.1.2.0/24", "10.1.3.0/24"]
  cidr_block          = "10.1.0.0/16"
  tags                = var.tags
  instance_type       = "t2.micro"
  bucketname          = "cf-bucket-"
}

