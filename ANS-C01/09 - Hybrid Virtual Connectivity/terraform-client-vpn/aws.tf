resource "aws_vpc" "aws_vpc" {
  cidr_block           = local.awsvpc.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aws-vpc"
  }


}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "aws-igw"
  }
}

resource "aws_route_table" "rts" {
  for_each = toset([for subnet_key, subnet in local.awsvpc.subnets : split("-", subnet_key)[0]])

  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name  = "${each.key}-rt"
    Class = each.key
  }
}

resource "aws_route" "public_default" {
  for_each = { for class, rt in aws_route_table.rts : class => rt if contains(local.public_route_table_classes, class) }

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "awssubnets" {
  for_each = local.awsvpc.subnets

  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name  = "${each.key}"
    Class = split("-", each.key)[0]
  }
}

resource "aws_route_table_association" "subnet" {
  for_each = aws_subnet.awssubnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.rts[split("-", each.key)[0]].id
}

resource "aws_security_group" "ssm_sg" {
  name        = "ec2_sg"
  description = "Allow SSH, HTTP, and HTTPS ingress and any outbound traffic"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ec2-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = data.aws_iam_policy.ec2_ssm.arn
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP from inside the VPC"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.awsvpc.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_launch_template" "web_server" {
  name_prefix   = "web-server-"
  image_id      = local.ec2.amiId
  instance_type = local.ec2.instance_size

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  user_data = filebase64("${path.module}/ec2-scripts/web-server-userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server" {
  name             = "web-server-asg"
  max_size         = 1
  min_size         = 1
  desired_capacity = 1
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }

  vpc_zone_identifier = [for key, subnet in aws_subnet.awssubnets : subnet.id if split("-", key)[0] == "server"]

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
  
}

resource "aws_vpc_endpoint" "ssm_endpoints" {
  for_each = local.private_endpoint_services

  vpc_id              = aws_vpc.aws_vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for key, subnet in aws_subnet.awssubnets : subnet.id if split("-", key)[0] == "private"]
  security_group_ids  = [aws_security_group.ssm_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "${each.key}-endpoint"
  }
}
