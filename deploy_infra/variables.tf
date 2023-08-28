variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default = {
    Name        = "CF"
    Environment = "Test"
  }
}

variable "region" {
  default = "us-east-1"
}