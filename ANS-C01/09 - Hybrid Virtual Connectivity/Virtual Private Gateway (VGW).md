# Virtual Private Gateway (VGW)

The VGW is a gateway object between AWS VPCs and non AWS networks.

Facts

- 1:1 relationship with VPC, can only be attached to one VPC at a time. If detached, can be attached to another VPC and retains its configuration (VPN tunnel definitions, CGW associations), though tunnels go down until reattached. Thus if you have certain users and locations already using the VGW, it is very easy to migrate to a new VPC by detaching and reattaching the VGW.
- Gets Private ASN (Autonomous System Number) for BGP peering, can be changed to custom ASN.
- VGW **route propagation** allows routes learned from on-premises (via BGP) to be automatically injected into VPC route tables. Separately, the VGW advertises the VPC CIDR to on-premises via BGP. These are two distinct mechanisms — "route propagation" specifically refers to the on-prem → VPC route table direction.
- Often times a VGW is used as a backup for a Direct Connect connection, as it can provide a secure and reliable connection to the on-premises network in case the Direct Connect connection goes down. In this scenario, the VGW can be configured to automatically route traffic through the VPN tunnel when the Direct Connect connection is unavailable, ensuring that the on-premises network remains connected to the VPC at all times.

**VGW Architecture**: (Site-to-Site VPN)

![arc](https://docs.aws.amazon.com/images/vpn/latest/s2svpn/images/vpn-how-it-works-vgw.png)

## Cloud`Hub`

CloudHub is a feature of AWS that allows you to connect multiple on-premises sites together through a single VGW. It is essentially a hub-and-spoke model where the VGW acts as the hub and the remote sites (Customer Gateways) act as the spokes. This allows for communication between the on-premises sites without the need for a direct connection between them, as all traffic is routed through the VGW. The sites can also communicate with the VPC attached to the VGW.

This requires:

- Each site connected has a different ASN for BGP peering with the VGW, as the VGW will be peering with each site separately. This allows for proper routing and communication between the sites and the VGW.
- Each side must be connected to the same VGW, as the VGW is the central point of communication for all the sites. If a site is connected to a different VGW, it will not be able to communicate with the other sites that are connected to the original VGW.

## AWS Site-2-Site VPN

- a logical connection between a VPC and an on-premises network, using IP-SEC tunnel, over the public internet.
- Each VPN connection includes two tunnels by default for HA on the AWS side. On-premises HA (second CGW) is optional.
- quick to set up
- uses the VGW as the gateway on the AWS side, and a Customer Gateway (CGW) on the on-premises side.
  - Note: CGW represents a configuration on AWS and the physical device on the customer side.
- VPNs do not have high bandwidth, thus not suitable for large data transfer. They are more commonly used for backup connections or for connecting to smaller on-premises networks. Given that the VPN is over the internet, there is no SLA on latency.
- hourly cost

### Creation of S2S VPN

Context

```text
AWS VPC has IP             10 .0  .0.0/24
On-premises network has IP 192.168.0.0/24
CGW has public IP          1.3.3.7
```

1. Create VGW and attach to VPC (Fill in information from above context)
   - In Reality, the VGW has endpoints in multiple AZs for HA. Thus, one endpoint can fail but the VPN will not.
2. Select Static or Dynamic VPN
   - Static: Manually fill in the routes that should be propagated to the VGW. Like the VPC ranges and the on-premises ranges.
   - Dynamic: Use BGP to automatically propagate routes between the VGW and the CGW. This is more efficient and easier to manage than static routing, especially if there are many routes or if the network topology changes frequently.

Note: this design has the single point of failure: on-prem router. To solve this, you would need to set up a second VPN connection with a second CGW and have it connect to the same VGW. This way, if one CGW fails, the other can take over and maintain the connection between the on-premises network and the VPC.
