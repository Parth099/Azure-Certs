# Networking
## Designing Your Network
### Hub and Spoke Architecture

In this method there are 
+ Hub VNets (_VNets that have certain capabilities such as outgoing connectivity or security rules_)
+ Spoke VNets 

Spoke VNets peer with the Hub Vnets to gain abalities already granted to the Hub. Spoke VNets *DO NOT* peer with anyone else.

![hub-spoke-ex](https://media.licdn.com/dms/image/D5612AQFURlJs8M7Tsg/article-cover_image-shrink_600_2000/0/1703032285926?e=2147483647&v=beta&t=tytCeOJlqgaLiVoT4mjfSPeshHBrnxDw9eSEzyaAC8g)

### WAN[^1] Topology

The WAN is used to connect locations together. This is the Hub and Spoke Model at a larger scale. In this method a hub can be:
1. VNet(s)
2. A On-Prem Location
3. Remote User
4. Internet

![WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/media/virtual-wan-about/virtual-wan-diagram.png)

Under Azure, you can use multiple WAN hubs to help with latency issues if your locations are far apart.

### Private Networking

Did not take notes on this. Learned enough via `Ace-Guardian`.

Note: NSGs do not apply when using PE/PLS

## Load Balancing

1. Application Gateway (L7)
    + Can come with a WAF
    + Can Scale
    + Needs a Subnet  to deploy in   
2. Load Balancer (L4)
3. Traffic Manager
    + Load Balancer based on DNS
    + Can be used to route users based on Geographical Settings
    + Supports Caching 
4. Front Door
	+ CDN

## BGP

> Border Gateway Protocol (BGP) is the standard routing protocol commonly used on the Internet to exchange routing and reachability information between two or more networks.

BGP helps to connect on-prem and Azure Networks and subsequent resources. When BGP is used with Express Route, it allows Azure Access to your Route Tables and it can update these tables in real-time to reflect actual reachability information which may effect nearest routable `on-prem<->azure` connections.

[^1]: Wide Area Network
