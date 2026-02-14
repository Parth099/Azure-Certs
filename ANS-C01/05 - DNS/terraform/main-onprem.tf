locals {
  onprem = {
    vpc_cidr = "192.168.10.0/24"
    subnets = {
      "a" = {
        cidr = "192.168.10.0/25"
        az   = "us-east-1a"
      }
      "b" = {
        cidr = "192.168.10.128/25"
        az   = "us-east-1b"
      }
    }
    private_endpoints = {
      "ec2messages" = "com.amazonaws.${data.aws_region.current.region}.ec2messages"
      "ssm"         = "com.amazonaws.${data.aws_region.current.region}.ssm"
      "ssmmessages" = "com.amazonaws.${data.aws_region.current.region}.ssmmessages"
    }

    gateway_endpoints = {
      "s3" = "com.amazonaws.${data.aws_region.current.region}.s3"
    }
  }
}

resource "aws_vpc" "onprem_vpc" {
  cidr_block = local.onprem.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "onprem-vpc"
  }
}

resource "aws_subnet" "onprem_subnets" {
  for_each          = local.onprem.subnets
  vpc_id            = aws_vpc.onprem_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "onprem_route_table" {
  vpc_id = aws_vpc.onprem_vpc.id

  tags = {
    Name = "onprem-route-table"
  }
}

resource "aws_route_table_association" "onprem_route_table_assoc" {
  for_each       = aws_subnet.onprem_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.onprem_route_table.id
}


resource "aws_security_group" "onprem_sg" {
  vpc_id = aws_vpc.onprem_vpc.id
  name   = "onprem-sg"

  description = "Allow DNS and HTTP traffic IN, and all traffic OUT"

  ingress {
    description = "Allow SSH IPv4 IN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443 # for PEs
    to_port     = 443
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

resource "aws_security_group_rule" "onprem_allow_self_communication" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.onprem_sg.id
  source_security_group_id = aws_security_group.onprem_sg.id
}

resource "aws_vpc_endpoint" "onprem_vpc_endpoint" {
  for_each = local.onprem.private_endpoints

  vpc_id       = aws_vpc.onprem_vpc.id
  service_name = each.value
  subnet_ids   = [for s in aws_subnet.onprem_subnets : s.id]

  private_dns_enabled = true
  security_group_ids  = [aws_security_group.onprem_sg.id]
  ip_address_type     = "ipv4"
  vpc_endpoint_type   = "Interface"
}

resource "aws_vpc_endpoint" "onprem_gateway_endpoints" {
  for_each = local.onprem.gateway_endpoints

  vpc_id            = aws_vpc.onprem_vpc.id
  service_name      = each.value
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.onprem_route_table.id]
}

## DNS Servers

resource "aws_instance" "dns_servers" {
  for_each = aws_subnet.onprem_subnets

  ami           = local.amiId
  instance_type = local.instance_size
  subnet_id     = each.value.id

  iam_instance_profile   = aws_iam_instance_profile.cloud_ec2_profile.name
  vpc_security_group_ids = [aws_security_group.onprem_sg.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    application_server_ip = aws_instance.onprem_app_server.private_ip
    zone_name             = var.dns_domain
  })

  tags = {
    Name = "onprem-dns-server-${each.key}"
  }
}

## Application Server for the corp. sub-domain
resource "aws_instance" "onprem_app_server" {
  ami           = local.amiId
  instance_type = local.instance_size
  subnet_id     = aws_subnet.onprem_subnets["a"].id

  iam_instance_profile   = aws_iam_instance_profile.cloud_ec2_profile.name
  vpc_security_group_ids = [aws_security_group.onprem_sg.id]

  tags = {
    Name = "onprem-app-server"
  }
}
