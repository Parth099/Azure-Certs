# Private Links

## Reasons for Use

- Want to expose a service to another AWS Account
- Want to consume a service from another AWS Account

Data will travel over the AWS backbone. 

### Facts

- HA is via Many Endpoints (1 per AZ)
- IPv4 (TCP) **ONLY**
- private DNS supported
- Access to create Private Link resources needs to be given via IAM

## VPC Endpoints

Two types of Endpoints exist, 

- `gateway`
- `interface`

Both deliver similar functionality via different means.

### Gateway Type

- Private access to certain services (without public infra like NAT+IGW)
	- Certain Services are so far: S3/Dynamo
- Associated to VPC
- regional resource (no need to configure AZs), cannot go to non-configured region

This resource will manipluate the RT for the subnets associated with the endpoint and will use a prefix list to direct traffic to the gateway endpoint. 

An Endpoint policy can be used to block/allow s3 buckets for example. 

### Interface Type

Provides private access to AWS Public Service

- Interface type is not HA, you need to deploy one per AZ used per subnet. 
- Endpoint polices can be used
- TCP over IPv4 only supported
- Internally used private link

Interface Endpoints do not use RT+Prefixes for routing. They use DNS. Each interface created gets its own DNS name:
- regional DNS name
- zonal DNS name

Applications may use the DNS names above OR utlize private DNS which would override default DNS AWS r53 provides. This option is enabled by default so that now any application will not need a patch to migrate to interface endpoints.

#### Example: EC2 Instance Connect Endpoint

There is an option to connect to a private EC2 Instance via an interface endpoint. This is called "Connect Using EC2 Instance Connect Endpoint".

The connection requester (*you*) is sending data to AWS's public API infrastructure, and they're pushing it through the endpoint. When the SSH connection is initiated the endpoint acts as a relay for the EC2 and sends the data over the endpoint which is then displayed via the EC2 Instance Connect UI. When the EC2 window is loaded, you will see that the connection request is _coming_ from the Interface IP of the endpoint.[^1] 

[^1]: There is an option to have connections stem from requester IP.

