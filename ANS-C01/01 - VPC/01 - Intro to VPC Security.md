# Intro to VPC Security

## NACL (_Network Access Control List_)

> Can be defined as a Stateless 'Firewall'

NACLs are attached to Subnets. Resources within Subnets cannot be governed by NACLs. 

NACLs have two rule types
- Outbound
- Inbound

Each rule has a priority. By default, NACLs deny everything if no rules match.

Suppose you had a EC2 serving over 443, if you wanted the internet to access it you would need two rules:
- `inbound` - allow 443 from `0.0.0.0/0`
- `outbound` - allow 1024-65535 to `0.0.0.0/0`


Even between Subnets you need 2x NACL rules like shown above. By Default, there is an allow rule so by default NACLs have 0 effect.   

## Security Groups

> Can be defined as a stateful Firewall

SGs have no explicit deny. You deny everything by default (no rules inbound) and then start allowing items. One issue is you arent able to block actors you may want to block. Often times you are ment to use SGs and NACLs together where the NACL is used to deny certain actors. 
SGs allows you to reference logical resources like subnets or other SGs. When setting an SG to an instance like EC2, you are really attaching the SG to the ENI (Elastic Network Interface).


## VPC Flow Logs

> Does what it says

It does not capture packet data, only metadata (ex: src, dest, ports, ...). Examples are here [AWS Flow log ex.](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-records-examples.html)

Certain traffic is not saved like speaking with EC2 metadata service.

They can be attached to:
- VPCs
- Subnets
- ENIs

They are NOT realtime and they can dump data into S3 or CloudWatch Logs. 
