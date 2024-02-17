# Compute

## Azure Key Vault Service


## Azure Virtual Machine Service[^1]

VMs can be connected to via SSH keys or User/PW combos. If you lose the key or user/pw combo, you **can** reset it via the Azure portal.

### Costs of VMs

> Note: your VNet is free.

+ Stopping a VM does not imply no costs
	+ Your attached disks still incur costs or any other other resources. See disk section below

For managing tasks, you can set up budget alerts under *Subscription*s. 

#### VM Types


Defined by the size of the CPU & RAM but also other factors like the *purpose* of the VM (Memory-intensive, Graphical)

For example D series is for daily use and general-purpose, E is for memory based applications, and H is for HPC.


[^1]: See AZ-900 notes for basic details on the VM service and the VNet service.

### Custom Scripts and Boot
### Custom Script via `Extensions`

`Extensions` is a feature under advanced VM settings.

+ For when you want to run a script on start up
+ any script cannot take more than 90 mins of runtime
+ scripts can be located in Azure Storage OR github
+ According to [SOF](https://stackoverflow.com/questions/41540702/do-custom-script-extensions-specified-in-arm-templates-run-each-time-the-vm-is-r) the script is ran ONCE after initial provision

An example is located under `/snippets/install_web.yaml`
#### `cloud init`

You can input a `yaml` file based on the `cloud init` spec to install packages and run commands.

An example is located under `/snippets/install_web_cloud_init.yaml`.

#### Boot Diagnostics

Debugging feature which takes logs and screenshots during boot. The data can be stored in a Azure-managed Storage account *or* a custom storage account. 

#### `run command`

You can run commands on a VM without logging in via the Azure portal. This can include preset commands such as 'Disable Windows Updates' but can go as far as running custom scripts.

### Confidential Computing and Dedicated Hosts

Confidential Computing allows you to isolate sensitive data. This feature reserves CPU hardware for a specific portion of your code known as an 'enclave'. This feature is supported on the DCsv2 type VMs.   

*Dedicated Hosts* on the other hand reserve **physical** servers to your azure subscription; no other Azure customer can place VMs on your *reserved server*. Payment depends on the number of hosts reserved not the number of VM hours. 

### Disks

Each disk is **highly available** as three copies of it exist.

When a VM is created it comes with a OS Disk, this is used to store user data along with OS data. You can additionally attach a data disk.[^1]. 

For certain VM types you get ephemeral storage via 'Temporary Disks' which is removed when the VM is stopped/deleted but **not** when it is restarted. This is because a restart does not *move* the VM's physical location in the data-center.

There are **5** types of disks:
1. Ultra Disks
2. Premium SSDs
3. Premium SSDs V2
4. Standard SSDs
5. Standard HDDs

Each varies in Throughput and IOPs.[^2] 

#### Server-Side Disk Encryption 

> You **cannot** alter disk encryption state while the another resource is using the disk.

Your disks is protected at rest via 256-bit AES and the encryption is done via platform-managed keys. However, you can set up your own 'customer-managed' keys via Disk encryption sets.

A Disk encryption set is used to encrypt data on disks. Once you swap encryption to customer-managed you cannot swap back to platform managed.

There are other options like Encryption at host which protects data in transit to Azure storage clusters.

Next, we have Azure Disk Encryption which is a Azure specific solution to help meet company compliance standards by using OS specific features like BitLocker and DM-Crypt (Windows). Notice in this method, the VM you are using will have to allocate CPU time to this encryption task unlike server-side encryption.

#### Disk Snapshots

You can copy a disk data into a `Disk Snapshop` and you can later restore it or create another disk using it. These snapshots can be incremental[^3] or full.

[^1]: It is a best practice to install and save application data on separate disks.
[^2]: You want higher IOPs for applications with high read/write ops while you want high Throughput when you need a constant stream of disk bandwidth.
[^3]: The first snapshot is a full snapshot while the subsequent snapshots are generated via a differential architecture. 

#### Shared Disks

> Feature for `High Availability`  

These are disks attached to *many* VMs. When creating a disk there is a limit on how many instances it can attach to known as `Max Shares`. 

**Important**: This does not imply that data will be sync-ed over machines. Additional software is needed for this to occur.