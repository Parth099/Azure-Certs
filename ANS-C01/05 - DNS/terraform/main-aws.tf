locals {
  cloud = {
    vpc_cidr = "10.16.0.0/16"
    subnets = {
      "a" = {
        cidr = "10.16.32.0/20"
        az   = "us-east-1a"
      }
      "b" = {
        cidr = "10.16.96.0/20"
        az   = "us-east-1b"
      }
    }
    private_endpoints = {
      "ec2messages" = "com.amazonaws.${data.aws_region.current.region}.ec2messages"
      "ssm"         = "com.amazonaws.${data.aws_region.current.region}.ssm"
      "ssmmessages" = "com.amazonaws.${data.aws_region.current.region}.ssmmessages"
    }
  }
}

# Part 1 -- Building out AWS VPC (represents the cloud side)
resource "aws_vpc" "cloud_vpc" {
  cidr_block = local.cloud.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cloud-vpc"
  }
}

resource "aws_route_table" "cloud_route_table" {
  vpc_id = aws_vpc.cloud_vpc.id

  tags = {
    Name = "cloud-route-table"
  }
}

resource "aws_route_table_association" "cloud_route_table_assoc" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.cloud_route_table.id
}

resource "aws_subnet" "subnets" {
  for_each          = local.cloud.subnets
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_security_group" "pe_sg" {
  vpc_id      = aws_vpc.cloud_vpc.id
  name        = "pe-sg"
  description = "Allow traffic TO private endpoints"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.cloud_vpc.id
  name   = "ec2-sg"

  description = "Allow DNS and HTTP traffic IN, and all traffic OUT"

  ingress {
    description = "Allow SSH IPv4 IN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP IPv4 IN"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow DNS-tcp IN"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow DNS-udp IN"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_self_communication" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  for_each = local.cloud.private_endpoints

  vpc_id       = aws_vpc.cloud_vpc.id
  service_name = each.value
  subnet_ids   = [for s in aws_subnet.subnets : s.id]

  private_dns_enabled = true
  security_group_ids  = [aws_security_group.pe_sg.id]
  ip_address_type     = "ipv4"
  vpc_endpoint_type   = "Interface"
}

resource "aws_instance" "cloud_ec2" {
  for_each = aws_subnet.subnets

  ami           = local.amiId
  instance_type = local.instance_size
  subnet_id     = each.value.id

  iam_instance_profile   = aws_iam_instance_profile.cloud_ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

}

## R53 AWS DNS Section
resource "aws_route53_zone" "hosted_zone" {
  name = var.dns_domain
}

resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "web"
  type    = "A"
  ttl     = 60
  records = [for vm in aws_instance.cloud_ec2 : vm.private_ip]
}
