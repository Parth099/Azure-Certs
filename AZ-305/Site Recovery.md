# Site Recovery Strategy - Backup and Disaster Recovery

## Azure Site Recovery

This is preperation which is required before a failure. ASR will help you create a "ghost" enviorment in another region allowing you to quickly redeploy your infrastructure. It does this by deploying the free resources such as `subnets` or empty `storage-accounts`. Then it will setup things like storage account replication and extensions on virtual machines to send their data to a intermediate VM. Then when required the failover can occur with the ASR finally deploying VMs on the `standby` region. When the original region is restored, a return to it is called a `failback`.

You do not have to wait for disaster test your plan. You can test your plan from the Recovery vaults. 

**Supported Workload**
1. VMs
2. On-Prem workloads[^1] (VMWare, Hyper-V, Physical)
3. 


[^1]: Notice this can help you migrate workloads to the cloud.

**Grographies**

Each region has a pair. This is not any indication of primary vs secondary but simply a region where data movement/replication will occur the fastest. This implies a failover should be more accurate and faster.
