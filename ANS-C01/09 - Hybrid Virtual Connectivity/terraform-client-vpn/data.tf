data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_iam_policy" "ec2_ssm" {
  name = "AmazonSSMManagedInstanceCore"
}
