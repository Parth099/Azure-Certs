# Hybrid DNS

This is a common issue:

> How can we integrate the on-platform DNs with R53 DNS **privately**?

## Preface

Recall that usually DNS is handled by the VPC DNS located on the `VPC+2` address. 

The `subnet+2` is also reserved in every subnet to be the r53 resolver which provides resolution for r53 public/private zones.

## Route 53 Endpoints

### Before R53 Endpoints

To put it simply, here was a common hybrid DNS architecture before R53 Endpoints.

- **AWS Side** - For traffic destined for on-prem domains, each VPC would have to be setup with a custom DNS server which would recongnize corperate domains which would forward to the on-prem resolver. This was done by setting up a custom DNS server in the VPC DHCP settings.
- **On Prem** -- Since you cannot communicate with R53 outside of a VPC, the on-prem resolver would send forward queries for AWS to the aformationed custom DNS server in the VPC which would resolve via R53

### R53 Endpoints

- Accessible via VPN or DX as they are VPC Interfaces
- Two types 	
	- Inbound Interfaces - on-prem can forward here to resolve va R53
	- Outbound Interface - AWS can forward here to resolve via on-prem via conditional forwarding. For example, you can mark certain domains as needing on-prem resolution which AWS will recognize and resolve them on-prem. The DNS servers here will have unique IPs which you may white list on your on-prem network. 