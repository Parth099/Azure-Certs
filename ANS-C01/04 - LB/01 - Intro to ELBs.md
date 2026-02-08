# Intro to Load Balancing

 

Three types of ELBs (Elastic Load Balancer)

 

- Classic Load Balancer

    - Not recommended as only 1 SSL cert is supported per domain.

    - no listner rules (bad for consolidation)

- Application Load Balancer

- Network Load Balancer

 

## Elastic Load Balancer

 

Important choices when creating an ELB

- AZs (by selecting subnets)

- IPv4 or `dualstack`

- internet-facing or internal

 

Each ELB is configured with an `A` record. This record points to ELB nodes

 

ELBs are configured with listeners which accept traffic on a certain port and forward this to a configured `target`.

 

For complex applications, it is recommended that ELBs are configured and if needed EC2s would directly send requests to private ELBs to make everything easily scalable independently.

 

### Cross Zone Balancing

 

Consider a scenario where an LB spans 2 AZs. This implies at least two nodes exist in total. We can call the two nodes $N_a$ and $N_b$. Historically each node could only send traffic within its zone. If a certain AZ had more backend instances, then the distribution of traffic was generally unfair.

 

A feature called `cross-zone-load-balancing` enabled any node to send traffic to any AZ. This is enabled by default for ALBs.

 

### Requirements

 

- 8+ free IP address into the subnet they are selected to operate in.

    - AWS suggests Subnet Size greater than or equal to `/27` but `/28` is the smallest supported.

 

### Application Load Balancer (ALB)

 

- L7 LB (understands HTTP, HTTP/s)

    - Con: doesn’t understand other L7

    - Con: no UDP, TLS, ...

    - Con: Uses SSL termination

        - HTTPS is broken at the ALB, a new one is formed from ALB -> Application

    - Con: L7 implies slower since it understands more

    - Pro: Understands cookies, location, app-behaviors, app-health

- many rules can be attached and each have a priority with a default

    - rule conditions include things like:

        - headers

        - query-string

        - source-ip

        - paths

        - ...

    - rules have actions

        - forwarding

        - redirect

        - ...

 

### Network Load Balancer (NLB)

 

- L4 (Understands TCP, TLS, UDP)

    - Con: No understand of L7

    - Con: No Backend health check

    - Pro: Faster than ALB

- NLBs have static IPs; useful for whitelisting

    - Pro: supports e2e unbroken encryption

- NLBs are also used to provide privatelink services to other VPCs

 

