# Simulate AWS direct connect to on-premises network via VPC peering

resource "aws_vpc_peering_connection" "hybrid_vpc_peering" {
  vpc_id      = aws_vpc.cloud_vpc.id
  peer_vpc_id = aws_vpc.onprem_vpc.id
  auto_accept = true

  tags = {
    Name = "hybrid-vpc-peering"

  }
}

resource "aws_route" "peer_route_aws_to_onprem" {
  route_table_id            = aws_route_table.cloud_route_table.id
  destination_cidr_block    = aws_vpc.onprem_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hybrid_vpc_peering.id
}

resource "aws_route" "peer_route_onprem_to_aws" {
  route_table_id            = aws_route_table.onprem_route_table.id
  destination_cidr_block    = aws_vpc.cloud_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hybrid_vpc_peering.id
}

# DNS resolution across the peering connection
resource "aws_route53_resolver_endpoint" "aws_resolver_inbound_endpoint" {
  name                   = "r53-aws-inbound-endpoint"
  direction              = "INBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  dynamic "ip_address" {
    for_each = aws_subnet.subnets
    content {
      subnet_id = ip_address.value.id
    }
  }

  protocols = ["Do53", "DoH"]
}

resource "aws_route53_resolver_endpoint" "aws_resolver_outbound_endpoint" {
  name                   = "r53-aws-outbound-endpoint"
  direction              = "OUTBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  dynamic "ip_address" {
    for_each = aws_subnet.subnets
    content {
      subnet_id = ip_address.value.id
    }
  }

  protocols = ["Do53", "DoH"]
}

resource "aws_route53_resolver_rule" "fwd" {
  domain_name          = var.fwd_domain
  name                 = "corp-tapped-in-net-forwarding-rule"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.aws_resolver_outbound_endpoint.id

  dynamic "target_ip" {

    for_each = aws_instance.dns_servers
    content {
      ip = target_ip.value.private_ip
    }
  }
}

resource "aws_route53_resolver_rule_association" "crop_subdomain_association_aws" {
  resolver_rule_id = aws_route53_resolver_rule.fwd.id
  vpc_id           = aws_vpc.cloud_vpc.id
}
