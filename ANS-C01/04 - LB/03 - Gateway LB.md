# Gateway Load Balancer (GW-LB)

- Helps you run and scale 3rd-party appliance
    - Ex: Firewall, DNS, ...

- Can be on in/egress traffic

GWLB creates GWLB endpoints which is how traffic will enter/exit the network. For traffic coming in or out, GWLB will balance the traffic among the backend appliances (EC2s). The Traffic is sent over a secure tunnel using the GENEVE protocol. Here is an image to visualize it:

![GWLB-flow](https://d2908q01vomqb2.cloudfront.net/5b384ce32d8cdef02bc3a139d4cac0a22bb029e8/2020/11/14/GWLB-Overview-1024x351.png)

Note, in this image the destination is not back to the client, the destination denotes the application server the client wants to interact with.

## How to Scan All packets

One way to do this is to configure your IGW's RT with routes to the GW-LB endpoint. This will cover packets entering the VPC.

For packets leaving, all subnets which DO NOT contain the GW-LB endpoint should point to the GW-LB with a RT-Route.

```text

Subnet C Route Table



VPC CIDR  => Local

0.0.0.0/0 => GW-LB Endpoint

```

See that traffic existing the VPC will not be using the local route and thus will be forced to be scanned.
