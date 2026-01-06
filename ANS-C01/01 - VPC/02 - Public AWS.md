# Public Networking

## Internet Gateway

-   An IGW _can be_ attached to a VPC
    -   1:1 (IGW -> VPC)
-   This is used to access AWS Public Services[^1] and Access Internet
    -   For AWS Public Zone, the traffic does not leave the AWS Network.
-   Scaling is managed by AWS
-   IPv4 & IPv6 supported
    -   For IPV4: The NAT used is Static. A private IPv4 maps to a public one

### IGW - Static NAT

> Recall that when given a public address for EC2, the machine OS only knows of the private address.

The IGW is a border device, when it sees traffic destined for the internet with a private address it will replace the address with a public one. This is how an EC2 instance gets its public IP. The reverse will occur for taffic destined to the EC2 from outside. 

For IPv6, the IGW needs to do only forwarding. 

### Public Subnets

A **public subnet** is a subnet with a internet gateway route attached.

#### IGW Setup

1. Create IGW
2. Attach IGW to VPC
3. Create Custom RT
    - Associate RT
4. Add route to IGW (`/0`-> IGW)


#### Bastion Hosts[^2]

- Server at a network's edge
   - gatekeeper between two zones (public -> private)

Bastions hosts allow you to login to it, since it likely has a public address, which then you can use it to log into the private machines in the private zones. 



### Egress ONLY IGW

> Does what it says

This may seem redundant for IPv4 (NAT Gateway) but since all IPv6 is routable this is useful. 


## Bring Your Own IP

With the normal process, AWS owns the IPs you are using. 

See that this is required as AWS needs to advertize their IPs via BGP. You are able to follow a process to get your IPs into AWS which will authorize AWS to advertize your IPs. 

The process is not documented here but it involves cryptographically signed documents which prove ownership and ability to advertize.

Limits:
- smallest is /24
- 5 IPv4 and IPv6 ranges per account (cannot share between accounts)

## Network Addres Translation

Prior to the NAT Gateway, NAT was provided via a `NAT-Instance` which was an EC2 running Linux AMI. This approach is not suggested _anymore_. 

### NAT Gateway

Consider two subnets $P_x$ (private) and $P$ (public). Now suppose all EC2 machines $M_i$ are deployed to $P_x$.

If $M_i$ needed to connect to the internet we need to deploy a NAT Gateway to $P$. It is important here to understand that the NAT Gateway has a public address (provided by IGW) and a private address provided by the VPC. For internet connectivity, the RT of $P_x$ needs to forward all traffic to the NAT GW.

Facts
- AZ Resliant 
- 45 GBPS Bandwidth
- Cost per GB cost
- Elastics can be used
  - this implies IP cannot change
- No Security Groups on NAT Gateway Resource

If your destination is S3/DynamoDB, you can use this `gateway-endpoint` resource: [AWS-Docs](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html).




[^1]: We are not thinking about Private Endpoints
[^2]: a.k.a Jumpbox
