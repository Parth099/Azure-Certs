locals {
  az_map = {
    a = data.aws_availability_zones.available.names[0]
    b = data.aws_availability_zones.available.names[1]
    c = data.aws_availability_zones.available.names[2]
  }

  public_route_table_classes = ["server"]

  private_endpoint_services = {
    ssm         = "ssm"
    ssmmessages = "ssmmessages"
    ec2messages = "ec2messages"
  }

  awsvpc = {
    cidr = "10.16.0.0/16"
    subnets = {
      reserved-a = { cidr = "10.16.0.0/20", az = local.az_map["a"] }
      reserved-b = { cidr = "10.16.16.0/20", az = local.az_map["b"] }
      reserved-c = { cidr = "10.16.32.0/20", az = local.az_map["c"] }
      db-a       = { cidr = "10.16.48.0/20", az = local.az_map["a"] }
      db-b       = { cidr = "10.16.64.0/20", az = local.az_map["b"] }
      db-c       = { cidr = "10.16.80.0/20", az = local.az_map["c"] }
      server-a   = { cidr = "10.16.96.0/20", az = local.az_map["a"] }
      server-b   = { cidr = "10.16.112.0/20", az = local.az_map["b"] }
      server-c   = { cidr = "10.16.128.0/20", az = local.az_map["c"] }
      private-a  = { cidr = "10.16.144.0/20", az = local.az_map["a"] }
      private-b  = { cidr = "10.16.160.0/20", az = local.az_map["b"] }
      private-c  = { cidr = "10.16.176.0/20", az = local.az_map["c"] }
    }
  }

  ec2 = {
    amiId         = "ami-0532be01f26a3de55"
    instance_size = "t3.micro"
  }
}
