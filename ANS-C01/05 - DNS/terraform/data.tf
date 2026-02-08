locals {
  amiId         = "ami-0532be01f26a3de55"
  instance_size = "t3.micro"
}

data "aws_region" "current" {}
