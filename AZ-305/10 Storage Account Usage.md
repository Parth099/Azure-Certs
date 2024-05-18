# Storage Account Usage

> Managed Services, with a max size of 5 PB, and a throughput limit of 5-20 `GB`.

Storage Accounts are paid by usage (`GB` and account tier) , and is the cheapest storage on Azure.

Storage accounts come in two overall categories: `standard` and `premium`where `premium` has much lower latency. 

## Disk Usage

A disk can be unmanaged or managed. A managed disk has its lifecycle tied to the VM its attached to. There are SSDs possible too. 

These disks are stored in a **managed** storage account where same pricing rules apply[^1]. You can make reservations here to reduce costs with 1 *or* 3 year commitments.

### `premium` Storage

When you create a Premium Storage[^2] you can select a type of `blob` storage. 
+ Block Blobs
+ Page Blobs

## Storage Considerations

1. Storage on the cloud is "unlimited"
2. 11 *9*s of durability[^3]
3. Global Outage Failover
4. Different VMs have different number of disk attachment slots
5. You can *re*attach *file shares* with different VMs
6. Private Endpoint and Service Endpoints can help with security
7. Encryption
	+ By default Azure will encrypt at rest
	+ You can use Key Vault to encrypt your own keys
8. Create lifecycle policies to move files between tiers automatically
9. See `azcopy` and `Storage Explorer`
10. 

[^1]: For example, standard and premium tiers exist.
[^2]: Does not support tables or queues.
[^3]: Requires configuration to get there 