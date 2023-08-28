variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default = {
    Name        = "Coal-Fire"
    Environment = "Test"
  }
}

variable "region" {
  default = "us-east-1"
}