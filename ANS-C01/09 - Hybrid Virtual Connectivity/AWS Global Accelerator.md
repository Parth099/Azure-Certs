# AWS Global Accelerator

> Not to be confused with AWS Cloudfront

- optimizes flow of data from AWS Backbone to end users by routing traffic through the AWS global network, which can provide better performance and lower latency compared to routing traffic over the public internet. AWS aims to better the latency by reducing the number of hops and using the AWS global network.

- global accelerator provides two static IP addresses that act as a fixed entry point to your application, and it routes traffic to the optimal endpoint based on health, geography, and routing policies. This can help improve the availability and performance of your application for users around the world. These two IPs are `anycast` IPs, which means that they are advertised from multiple locations around the world, and traffic is automatically routed to the nearest location based on the user's geographic location. This is different from a traditional IP address, which is typically associated with a single location / machine.

## Accelerated Site-to-Site VPN

AWS Global Accelerator can be used to accelerate the performance of a Site-to-Site VPN connection by routing traffic through the AWS global network instead of the public internet. This can help reduce latency and improve the overall performance of the VPN connection, especially for users who are located far from the on-premises network.

## Client VPN (Point-to-Site VPN)

- managed implementation of `OpenVPN` software

Connection Steps

- Connect to provisioned Client VPN endpoint
- associated with a target network with Subnets as a unit of association
- billed based on network association and connection hours

### Routing

The client VPN, when connected in full-tunnel mode, adds a default route (0.0.0.0/0) through the VPN interface that takes priority over the existing default route. This means that all traffic from the client machine will be routed through the VPN connection, and the client will effectively not have access to remote network resources outside the VPN while connected. This is a common configuration for a Client VPN, as it provides a secure and private connection to the VPC and on-premises network.

To avoid inefficent routing, you can use split-tunnel configuration, which allows you to specify which traffic should be routed through the VPN connection and which traffic should be routed through the local network. This can be useful in a situation where you still need to access local devices.
