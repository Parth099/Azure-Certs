# EC2 Networking

On Creation, the EC2 instance is provisioned with an ENI[^1], a primary ENI. This one cannot be removed. Additional ENIs[^2] can be created / removed but are _required_ to be in the same zone as the EC2.

Each ENI has a perma-IPv4 address from the subnet its deployed in. This is the IP the machine is shown in its OS are additional IP address from other ENIs are shown to the OS. Note, the IPv6 (always routable) is known by the OS as well.

If your EC2 has a public IPv4 this is not known by the OS.

## ENI Details

-   MAC address is determined by a ENI
    -   Important for Licensing
-   ENIs only process traffic in which they are the source or destination
    -   this is an option which can be disabled. One example where this needs to be disabled is if you have EC2 running NAT.

## Enhanced Networking & SR-IOV

-   Networking is virtualized (duh), VMs share a physical NIC and access is directed via a hypervisor.
    -   See that any kernal based calls are slow / blocking as hypervisor needs to step in

SR-IOV[^3] is a method which allows you to share a network card without the issue above as hypervisors aren't required here.

### SR-IOV

In this method, the NICs are virtualization aware. They expose "sub-devices" which are lightweight to the machines which have a cut down functionality. The machines interact with the sub-devices directly which allows for consistant speeds and connectivity without the need for a 1:1 mapping of VM to NIC.

One NIC offers 256 VFs (virtual functions).

### Performance for EC2 Networking

In this example consider Instance $A$ & $B$. Suppose $B$ is a much larger instance with better _specs_ than $A$.

Now logically between $A$ and $B$, the best transfer speed possible is that of $A$. Now this limit is set to 5 GPBS as a single flow[^4].

| Senario          | Performance                 |
| ---------------- | --------------------------- |
| Same Region      | Ideal speed described above |
| Different Region | 5 GBPS _aggregate_          |

Another limit exists but often not the cause of the limit a user may ever seen. This is the virtual function or ENA[^5], they have a limit as well. ENA has a limit of 100 GBPS and for virtual functions it varies.

## EFA - Elastic Fabric Adpater

-   1 per instance
-   can be added when the machine is created OR when it is shutdown

The way it works is that it supports "OS-bypass". This is meant for HPC/ML workloads where many nodes exist which may need to communicate to each other to solve a larger problem.

### The "bypass"

Traditionally, each network call will originate from a application and then travel down to the OS to be handled, see that this is a kernal-level call which may slow down networking needs.

With EFA, networking is changed, data is instead passed to a LIBFabric which sends it to the EFA driver. This makes it so the OS is not involved in networking calls.

The difference is shown in this image below: ![EFA-Advange-Gimages](https://docs.aws.amazon.com/images/AWSEC2/latest/UserGuide/images/efa_stack.png)

Limits

-   Single Subnet only (Same AZ)
    -   Cross Subnet makes it back to normal IP traffic
-   Some SG rules are required
    -   Allow all self-reference rule

## EC2 Placement Groups

By default, when an EC2 is created, AWS picks the best EC2 host for it to place your instance on.

-   Cluster
    -   pack instances close
    -   When created, AZ choise isnt present, the first instance launched determines the AZ all of the placement group will be in.
    -   AWS tries to keep the instances in the sane **rack** and/or **host**
    -   Single stream of data transfer goes from 5 GPBS to 10 GPBS
    -   Single AZ (obvious)
    -   Can span VPC Peers
    -   Only certain EC2 Types supported
    -   Tips
        -   Launch instances all at once to aid AWS into keeping instances close
        -   use same type of instance
-   Spread
    -   keep instances away by using distinct racks when deploying EC2 Instances over different AZs
    -   7 instances per AZ limit
-   Partition
    -   groups of instances away
    -   can be created over many AZs in a region
        -   per AZ you designate "partitions" (7 per AZ max) and then you can deploy the required number of EC2s to the partition.

## EC2 Instance Metadata

EC2s learn "what"[^6] they are via Instance Metadata service. EC2 instances call on the service IP `169.254.169.254\latest\meta-data`

This services exposes the following to the EC2s:

1. Environment
2. Networking
3. Authentication
    - instance roles
    - temp SSH keys for instance log-on
4. User-Data

This service from the EC2 is **unauthenticated**.

[^1]: Elastic Network Interface
[^2]: Recall NSGs apply to an ENI and not an EC2 Instance.
[^3]: Single Route IO Virtualization
[^4]: What is a flow? 5-tuple of SRC-IP, DEST-IP, SRC-Port, DEST-Port, and Protocol
[^5]: Elastic Network Adapter
[^6]: The Environment
