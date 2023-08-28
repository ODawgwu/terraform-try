terraform {
  backend "s3" {
    bucket         = "backendstatefileanyi"
    key            = "cf_project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-dynamoDB"
  }
}
