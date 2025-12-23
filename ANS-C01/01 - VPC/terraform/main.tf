data "aws_availability_zones" "available" {
  state = "available"
}

locals {


  cidr = "10.0.0.0/16"

  # --- Subnets ---

  tiers = [
    "web", "app", "db", "pe"
  ]
  no_az = length(data.aws_availability_zones.available.names)

  subnets = [for i in range(16) : cidrsubnet(local.cidr, 4, i)]

  # give 4 subnets to each tier
  subnets_to_create = { for i, s in local.subnets : s => {
    tier = local.tiers[i % length(local.tiers)]
    az   = data.aws_availability_zones.available.names[min(floor(i / length(local.tiers)), local.no_az)]
    cidr = s
    }
  }

  private_endpoints = {
    "ec2messages" = "com.amazonaws.${var.region}.ec2messages"
    "ssm"         = "com.amazonaws.${var.region}.ssm"
    "ssmmessages" = "com.amazonaws.${var.region}.ssmmessages"
  }


}
## Create roles
## -- Reason : To give the EC2 instances access to the SSM service so we can access it without SSH

data "aws_iam_policy" "ssm_core" {
  name = "AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"

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

resource "aws_iam_role_policy_attachment" "ssm_core" {
  policy_arn = data.aws_iam_policy.ssm_core.arn
  role       = aws_iam_role.ssm_role.name
}

resource "aws_vpc" "vpc" {
  cidr_block       = local.cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet" {
  for_each = { for s, v in local.subnets_to_create : "${v.az}-${v.tier}" => v }
  vpc_id   = aws_vpc.vpc.id



  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${each.value.tier}-sn-${each.value.az}"
    tier = each.value.tier
  }
}

resource "aws_route_table_association" "rt_assoc" {
  for_each = aws_subnet.subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "ec2-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "pe_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "pe-sg"
  description = "Allow traffic TO private endpoints"

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  for_each = local.private_endpoints

  vpc_id       = aws_vpc.vpc.id
  service_name = each.value
  subnet_ids   = [for s in aws_subnet.subnet : s.id if s.tags["tier"] == "pe"]

  private_dns_enabled = true
  security_group_ids  = [aws_security_group.pe_sg.id]
  ip_address_type     = "ipv4"
  vpc_endpoint_type   = "Interface"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "vms" {

  count = 2

  ami           = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"


  subnet_id                   = aws_subnet.subnet["us-east-1a-web"].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false


  tags = {
    Name = "vm-networking-${count.index + 1}"
  }

  iam_instance_profile = aws_iam_instance_profile.ssm.name
}

