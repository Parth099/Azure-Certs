# AWS Transit Gateway

The Transit gateway is a service which connects VPCs together and also connects VPCs to on-premises networks. It acts as a central hub for routing traffic between VPCs and on-premises networks, allowing for more efficient communication and easier management of network resources.

THe TGW has a child object known as an "Attachment" which is what represents a connection. Valid attachments include:

- VPC Attachment: Connects a VPC to the Transit Gateway.
- VPN Attachment: Connects a Site-to-Site VPN to the Transit Gateway.
- Direct Connect Gateway Attachment: Connects a Direct Connect connection to the Transit Gateway.
- TGW Peering Attachment: Connects two Transit Gateways across accounts or regions.

## Why use Transit Gateway? The Problem Before TGWs

Before Transit Gateway, if you wanted to connect multiple VPCs together, you would have to set up peering connections between each pair of VPCs. This can quickly become complex and difficult to manage as the number of VPCs increases, as you would need to set up and maintain a large number of peering connections. Additionally, if you wanted to connect your VPCs to on-premises networks, you would need to set up separate VPN connections for each VPC, which can also be complex and difficult to manage.

## TGW Details

- A TGW can serve as a Site-2-site termination point for VPNs. Thus it can connect multiple sites together through the TGW, similar to CloudHub but with more features and better performance.
- When connecting TGW to VPCs, you can specify which subnets in the VPC should be used for the attachment. This allows you to control which traffic is routed through the TGW and which traffic is routed directly between VPCs.
- TGW supports route propagation, which allows routes learned from one attachment to be automatically propagated to other attachments. This can simplify the management of routing between VPCs and on-premises networks.
- TGW supports inter-account inter-region peering, which allows you to connect TGWs in different regions
- TGW also supports connections to a Direct Connect Gateway, which allows you to connect your on-premises network to the TGW using a Direct Connect connection. This can provide better performance and lower latency compared to using a Site-to-Site VPN connection.

The TGW is able to learn and propogate routes via its learned route table. There is one by default. This table is modified anytime a new attachment is added with the exception of TGW peering attachments. There is no feature yet to automatically learn routes from a peered TGW, thus you would need to manually add the routes from the peered TGW to the local TGW's route table. With this you can also conclude that TGW peers cannot take your public DNS query and resolve the private IP of your resources.

### TGW Route Tables

**Terms to clear confusion**:

- `association`: represents the route table that is used to look up routes for traffic leaving an attachment
- `propagation`: represents the route table that is automatically updated with routes learned from attachments

- attachments can only be associated with one route table at a time
- a route table can be associated with multiple attachments
- attachments can propagate to many RTs, even those they are not associated with, but only if the attachment is not a TGW peering attachment. TGW peering attachments do not propagate to any RTs.

This may be important in a few cases:

- create a system from where On-prem can reach **any** VPC yet each of the VPCs cannot reach each other. This can be done by creating a route table for each VPC attachment and only propagating the on-prem attachment to those RTs. This way, the on-prem attachment will learn routes to all the VPCs, but the VPC attachments will not learn routes to each other. The default route-table can be used on the TGW for the on-prem attachment as it should have all the routes.
