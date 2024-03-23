t## Azure Virtual Network (VNet)

> VNet is for Azure what VPC is for Amazon.

Here are some networking features and services:
1. Azure DNS 
2. Network Security Groups (Firewall at the subnet level)
3. ExpressRoute: On-Prem to VNet connection
4. Virtial WAN: Centralized Network to route different network connections
5. Virtual Network Gateway: Site to Site VPN between VPN and local networks.

### Network Interface

A Network interface is a software or hardware interface between two pieces of equipment or protocol layers.

A NIC (Network Interface Controller) communicates via IP.

In Azure these are called Azure Network Interfaces (NICs) and they are attached to VMs. Note, these are virtual. You must have at least one but a machine may have more than one.  

## VNet Peering

You can adjoin ***VNets*** (NOT on-prem and VNet) to act as one.

1. Regional Peering
2. Global Peering

When this is done **ONLY** the azure network is used, the data is not seen by the *public internet*. 

## Subnets

**Unlike AWS**, azure subnets have no concept of *public* and *private*. To create a private subnet you must ensure the route table has no connection to the internet gateway.

A subnet can be enhanced with a NSG (Network Security Gateway) which can allow/deny traffic based on IP, port, and protocol. 


## Service: Azure DNS

> You should know what DNS is first and public vs private DNS names.

You **cannot** use azure domains to buy domains.


## Virtual Network Gateways

This is a software VPN for your Azure VNet. When created it will create two or more specialized VMs in the specific subnets (known as Gateway Subnets) you choose.

This VPN can be one of two gateway types:
1. VPN
2. ExpressRoute

> **Important**: A site-to-site GW connection will travel over the public internet.

### Azure ExpressRoute (ER)

ER creates private connections between Azure Data-Centers and Infrastructure on-prem or in a co-location environment. These connections do **not** use the public internet meaning they are faster and offer better security.

![intro-to-ExpressRoute](intro-to-ExpressRoute.png)
You may choose to use ExpressRoute *Direct* if you need massive amounts of bandwidth.

### Point-To-Site Connection

Allows you to securely connect to a VNet from a **individual** client. This is great for remote-workers. 
## Azure Private Links

Azure Private Links allow you to create secure connections between azure resources so traffic **remains** in the Azure network. These private links are network interfaces (Virtual NIC Cards).

The way this works is:

Suppose you had a service that was outside your private VNet that you wanted to access yet the rules of the VNet blocked public IP accesses. What you can do is create a Private Endpoint inside the VNet and then use a private link with the endpoint to gain access to the service. Notice the traffic now remains inside the cloud provider.

A service provider would create a private link where a consumer would create an endpoint to connect to the private link.

Endpoints and Links are 1:1, two connect to three private links you would be required to deploy **three** private endpoints in your VNet.

## Azure Firewall

+ managed stateful firewall with unrestricted scalability.
+ centrally create, enforce, and log application and network connectivity policies across subscriptions and virtual networks