# Backup Options in Azure

## Azure Backup for VMs

> Aside from VMs you can also backup SAs.

This service provides access to the a VM's if something occurs to the VM. This data is written to a `recovery services vault` which is another resource (needs to be provisioned aswell) and is required to be in the same region as the data it stands to protect.

## Azure Backup for VM

You can backup your VM data inside a vault and choose a backup policy. The backup policy determines your backup frequency and schedule. This also includes the length of the backup's life. You can configure how long backups (Daily, Weekly, ...) will be saved.

The way recovery works is that the service will trigger a snapshot which will initially be saved on the VM locally but then is later uploaded to the vault. You may choose to keep these instant snapshots for longer as they serve as a recovery point.

Azure VM Recovery via the Recovery Vault **will not** be able to backup VMs where the managed disks are set to false.[^1]
### Azure Recovery Vault

This entity house recovery data from VMs and DBs (ex: `Azure SQL`). You can use this service to enable replication for a VM to set up disaster recovery **to a secondary region**. The service will install extensions to start replicating data. When you need to perform a recovery you can simple choose a restore point and a VM in the secondary to restore to.

### File Restore

This method also supports file restores from existing restore points, the service generates an executable[^2] allowing you to mount the drive onto another computer. This process will attach whatever volumes existed on the VM and takes a few mins to complete. There is a catch however, you **cannot** restore files to a previous or future operating system version. For example, you can't restore a file from a Windows Server 2016 VM to Windows Server 2012 or a Windows 8 computer.

### VM Recovery

After selecting a restore you have two options:

1. Create new machine
    - With this method you need a SA inplace to hold the data for the VM to copy; the SA serves as a staging location
2. Restore the current machine by replacing disks

### Deletion of the Recovery Vault

There are steps required before deleting the Vault. 

### MARS Agent

> Microsof Azure Recovery Services Agent

The MARS Agent services to make backup more configurable such as selecting specific files and folders to be backed-up. When installed it has to modes:
1. Backup
2. Recovery

It is evident from their names what each of the modes do.

You initially need to have a vault ready, however, this time the region does not have to be the same as the VM. You download the agent from the portal and it generated to be tried to your account. Note this ONLY works for the Windows OS.

### Backup Reports
1. Insights: Get metrics on things like number of backups and storage consumed.
2. Support (like tech support)
3. Data: Backup report data is sent to a LAW or a SA. You can choose.
    + This needs to be enabled and may take _days_ to populate
    + The SA is required to be in the same location as Recovery Service. 
    + The LAW has no location restrictions.


## Azure Site Recovery

> Disaster Recovery

For a workload to be multi-region, that is there is one active region and one fallback region, there needs to be some software / process that is copying data to another region. This is what ASR does for Azure Servers and on-prem servers. The replication region must be different from the original region.

With ASR you are "recovering" your VM in another region as its purpose is to safeguard against regional failures. Now what it means is that your machine will _respawn_ in this new region and subsequently a new VNet. 

The replication frequency is very high, you can get near 30-sec latency with ASR; thus you can restore to a very recent point. 

ASR needs an SA active as VM changes are first cached on the SA before being synced over. 




[^1]: Managed disks are when Azure manages your VM disk for you. 
[^2]: Recall at this point you would not be able to go on your VM. We are under the impression it is down.
