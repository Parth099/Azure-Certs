locals {
  vpc_cidr = "10.16.0.0/16"
  subnets = {
    "app-1a" = {
      cidr = "10.16.0.0/24"
      az   = "us-east-1a"
    }
    "web-1a" = {
      cidr = "10.16.1.0/24"
      az   = "us-east-1a"
    }
    "endpoints-1a" = {
      cidr = "10.16.2.0/24"
      az   = "us-east-1a"
    }
  }
}

## Sample s3 for EC2 Query
resource "aws_s3_bucket" "bucket" {
  bucket = "endpoint-test-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "endpoint-test-bucket-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block       = local.vpc_cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "endpoints-vpc"
  }
}

# Route Tables
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "sg" {
  name        = "endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "endpoints-sg"
  }
}

resource "aws_subnet" "subnet" {
  for_each = local.subnets
  vpc_id   = aws_vpc.vpc.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = false
  tags = {
    Name = each.key
    tier = split("-", each.key)[0]
  }
}

resource "aws_route_table_association" "rta" {
  for_each       = aws_subnet.subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt.id
}

## EC2 Information
resource "aws_iam_role" "s3_reader" {
  name = "ec2-s3-reader-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_reader" {
  policy_arn = data.aws_iam_policy.s3_read_only.arn
  role       = aws_iam_role.s3_reader.name
}

resource "aws_iam_instance_profile" "s3_reader" {
  name = "ec2-s3-reader-iprofile"
  role = aws_iam_role.s3_reader.name
}

resource "aws_instance" "web_servers" {

  count = 1

  ami           = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.subnet["app-1a"].id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = false


  tags = {
    Name = "vm-s3-endpoint-access-${count.index + 1}"
  }

  iam_instance_profile = aws_iam_instance_profile.s3_reader.name
}

## Endpoints
resource "aws_ec2_instance_connect_endpoint" "ec2_cep" {
  subnet_id = aws_subnet.subnet["endpoints-1a"].id
  security_group_ids = [
    aws_security_group.sg.id
  ]

  tags = {
    Name = "ec2-cep-endpoint-1a"
  }
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.rt.id
  ]
}

/*
NOW head to EC2 and run 

"aws s3 ls" command on the instance to verify S3 access via VPC Endpoint
*/
