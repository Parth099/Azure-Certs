# Intro to VPC

## Public vs Private (Networking)

- Private Services refer to services running inside the VPC.
- Public Services refer to services can be consumed by the internet.

There are three zones to consider:

1. Public Zone  (See Above)
2. Private Zone (See Above)
3. AWS Public Zone
  - Where AWS Public services reside. Ex: S3
  - If a service gets a public-ip address, it is projected to this zone. 

## VPCs

- Min Size: `/28` -> Max Size: `/16`
- Regional
- Nothing is allowed in or out without explicit config
- VPCs have two modes
  - default
  - dedicated
- VPCs can use public OR private IPv4
- Has 1 Primary Private IPv4 block
  - Optional 2nd-ary blocks

 ### DNS

 - Provided by R53
 - `Base IP +2` Address
 - Setting can be enabled to give instances DNS Names
 - Setting can be enabled to turn on or off DNS resolution within the VPC

### Subnets

Subnets are by default private and later can be set to public. One subnet is tied to one AZ. 

- By Default, subnets can speak to each other within the VPC.

Subnets have 5 reserved address. 

- +0 -> Starting Address
- +1 -> VPC Router
  - See `VPC Router` section below. This address is an address to an interface to the VPC router.
- +2 -> DNS
- +3 -> TBD
- -1 -> Broadcast Address

#### DHCP 

The DHCP Option Set is, inherited from the VPC, you can only have one. 


On Normal networks, DHCP on L2 allows devices to exhange their L2 Identifer (Mac Addr) for Network information (L3):
- IP Address
- Subnet Mask
- Default Gateway
- DNS Servers / Domain Name
- ...

##### Option Sets

- Immutable Post-Creation
- One Set can be used by MANY VPCs
- One VPC can use at most one set

This is where you would configure the DNS server to use. 

#### VPC Router

Performs following routing
1. Between Subnets
2. To/From External Networks like internet or on-prem

Details:
- Runs in all AZ the VPC is. 
- Can influence routes via the Route Table Resource (attaches at Subnet Level)
  - By Default a main RT is created and attached to ALL subnets.     
     
  
### IPv6 in AWS VPCs

IPv6 address in AWS are always routable. This does imply a NAT Gateway **does not** support IPv6. However, if it is required that your IPv6 machines are not sent any data from the internet they can be placed behind a EO (Egress Only) IG (Internet Gateway).

In Route tables, IPv4 & IPv6 address have different routes in the table. 

IPv6 can be enabled post-creation too for VPCs & Subnets


