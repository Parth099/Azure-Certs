# Fundamentals

## IP-SEC

- group of protocols that provide security for IP communications by authenticating and encrypting each IP packet in a communication session between peers. The term used here is "tunnel" which is a secure connection between two endpoints, often used to connect two networks over the internet. The tunnel, which is over the public internet, is established using IP-SEC protocols, which provide confidentiality, integrity, and authentication for the data being transmitted.

- for data encryption, usually an asymmetric key exchange protocol is used to establish a shared secret symmetric key between the two endpoints of the tunnel as symmetric encryption is more efficient for encrypting large amounts of data. The shared secret key is then used to encrypt the data being transmitted through the tunnel, ensuring that it remains confidential and secure from unauthorized access.

The two phases of IP-SEC are:

1. `IKE Phase 1`: This phase uses the Internet Key Exchange (IKE) protocol which uses asymmetric cryptography to establish a symmetric shared key. At the end of this phase, it is known as `IKE SA` (Security Association) which is a secure channel between the two endpoints that can be used to negotiate the parameters for the second phase.

2. `IKE Phase 2`: This phase uses the `IKE SA` established in Phase 1 to negotiate the parameters for the IP-SEC tunnel, such as the encryption and authentication algorithms to be used. Once the parameters are agreed upon, the IP-SEC tunnel is established and data can be securely transmitted between the two endpoints. Note there are two SAs in phase two, one for each direction of traffic flow.

IP-SEC is used by VPNs, there are two types of VPNs that use IP-SEC:

- route-based VPN: In this type of VPN, the traffic is routed through the tunnel based on routing tables. The VPN gateway will have a routing table that specifies which traffic should be sent through the tunnel and which should be sent through the regular internet connection. This type of VPN essentially maps routes to a SA key pair.

- policy-based VPN: In this type of VPN, the traffic is filtered based on policies that specify which traffic should be encrypted and sent through the tunnel. This type of VPN essentially maps traffic patterns to a SA key pair.

Note: Policy-based VPN can allow many SA over one phase 1 tunnel as you can set up different keys to match different traffic patterns, whereas route-based VPN can only have one SA per phase 1 tunnel as the routing table can only specify one path for the traffic to take.

## BGP - Border Gateway Protocol

Routing Protocol used to exchange routing information between different networks on the internet. It is a **path-vector** protocol that determines the best path for routing traffic between networks based on path attributes (not hop count like distance-vector protocols). BGP is used by internet service providers (ISPs) and large enterprises to manage the flow of traffic between their networks and the rest of the internet.

The unit of routing in BGP is called an Autonomous System (AS), which is a collection of IP networks and routers under the control of a single organization that presents a common routing policy to the internet. Each AS is assigned a unique AS number (ASN)[^1] that is used to identify it in BGP routing tables. ASs operate as "black-boxes" when viewed from a BGP lens.

One AS can send traffic to another AS if they are peered which is a manual process. Peers advertise who they are peered to and thus a router can build up a path on how to send data from one area to another area using the advertised ASNs. When a router looks to exchange paths from its peers, it uses the AS path (`ASPATH`) information to determine the best route to a destination.

### Path Selection

List is ordered from High to Low in terms of priority when picking a path

- Weight (Cisco-specific, highest priority, local to router)
- Local Preference - higher is preferred, used within an AS to influence outbound traffic
- Locally originated routes preferred (routes injected via `network`, `aggregate`, or `redistribute`)
- `ASPATH` length, shorter paths are best
- origin code
- MED (multi-exit discriminator)
- eBGP over iBGP
- IGP metric - shortest way OUT of the local AS
- oldest route - older means more stable route
- Router ID - lowest Router ID (an IP address, typically the highest loopback or highest active interface IP)
- Neighbor IP address - lowest neighbor path on IP next hop

#### **Local Preference**

What should you do if $N$ routes have the same `ASPATH` length. Local preference is a BGP attribute that can be used to influence the outbound traffic from an AS. It is a value that is assigned to each route and is used by BGP routers to determine the best path for routing traffic. The higher the local preference value, the more preferred the route is for outbound traffic. Local preference is only relevant within an AS and is not shared.

#### MED - Multi-Exit Discriminator

MED is used to influence inbound traffic to an AS. It is a value that is assigned to each route and is used by BGP routers to determine the best path for routing traffic into an AS. The lower the MED value, the more preferred the route is for inbound traffic.

MED is received from eBGP neighbors and shared with iBGP peers within the local AS, but it is non-transitive — it is not passed onward to the next AS. This means a third party would not know the MED values of anything more than the next hop.

[^1]: ASNs range from 0 to 65535. ASNs from 64512 to 65535 are reserved for private use and cannot be used on the public internet. When setting up BGP peering with a VGW, you can choose to use a private ASN for your on-premises network, or you can use a public ASN if you have one assigned to your organization.