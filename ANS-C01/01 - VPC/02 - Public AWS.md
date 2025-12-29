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


[^1]: We are not thinking about Private Endpoints
[^2]: a.k.a Jumpbox
