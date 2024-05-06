# Data Management

## Managed and Unmanaged Data Solution

An Unmanaged solution is a solution you have all the control over like `SQL on VM`. A managed solution is one which is managed by Microsoft where things like scaling and load balancing are not your concern; an example is `Cosmos DB`.

Many managed services have features unmanaged features cannot. For example Azure offers auto tuning to Azur SQL DBs which helps you make queries faster via finding items to index.

## NoSQL and Relational Solutions

> Not going to take many notes here I know whats going on here already

## Database Auditing

A SQL Database has a event log and a transaction log which allows for rollbacks. Azure Monitor does have features for SQL Server to help you with observability. 

## `DTU` and `RU/s`

While you can configure your DB in terms of CPU, Memory, ...; Azure has complied all those descriptors into DTU, a database transaction unit. When buying via DTU, you lose all control over the underlying hardware.

A DTU is a relative power unit. This means you should expect double the performance when comparing a 10 DTU DB to a 20.

All of the above applies to **relational** DBs. With Cosmos DB pricing has two dimensions:
1. Storage
2. RU/s (Request Unit)

It represents the number of requests per second the DB should be able to serve. The reason it is different than DTUs is because Cosmos DB can host different types of DBs like SQL or MongoDB.

## Data Retention

Notice that many of the managed service already give you:

- Automatic Geo-redundant Backups
- Transaction Logs
- You can design retention and backup points which can last up to 10 years 
- Soft Delete Features
- Restore to another region

## Data Archiving

+ From all these other sections you notice that it is smart to keep backups of DBs, for example, at regular intervals. This data is **rarely** accessed so it can be archived to reduce costs. 
+ Only Blob Storage and GPv2 support tiering. You can default to hot or cool on data upload.
	+ An archived file may take hours to rehydrate  
+  

## Availability, Consistency, Durability

+ Availability involves having replicated copies in other locations
  - Challenge: Replication Lag
+ Consistency defines how "correct" your databases are. Under Cosmos DB you can define how consistent you want your replicas to be.
  - Challenge: Consistency sacrifices speed.
+ Durability is the idea that if a transaction is committed, it is never lost.
  - Challenge: Durability is costly and mildly sacrifices speed

There exists Azure SQL Database Business Critical Tier which provides very low time SLAs for replication and backup recovery times.

### Availability

+ Cosmos DB will keep **4** copies of your data in the same data center to avoid data loss on node failures. You are liable if the AZ goes down. However you can configure a multi-AZ or multi-region support. 
+ Redis Cache which is based on `nodes` (VMs in a cluster), also has options:
	+ Standard - dual nodes
	+ Zone - Multi-node across AZs
	+ Geo-Replication - Linked Cache instances in two regions
+ Storage accounts has:
	+ LRS
	+ ZRS
	+ GRS/GZRS and the Read Replica version of both
		+ Secondary Region Data is not available to you until failure
		+ Updates are **async**. No SLA for syncing
		+ Read-access not supported by Files
	+ "Trivia"
		+ General Purpose V1 & Legacy Blobs can only be LRS or GRS/RA-GRS
		+ Premium File Shares & Premium Block Blobs can only be LRS/ZRS 
+ Azure Managed disks can at best be ZRS.
+ Relational DBs
	+ SQL DB has some default HA
		+ In a single region SQL DB has a primary replica with read replicas while keeping data in a Premium Storage with backups in a standard storage (RA-GRS).
			+ By default outside the Data Center, your data is not saved.
		+ You can enable geo-replication, this does not increase HA but does decrease RTO[^1]
		+ ZRS for SQL DB is in preview
		+ Premium and Business Tier differ by persisting data **directly** on each VM rather than having the VMs access a storage account. Also applies to ZRS
		+ Hyperscale Tier involves storing data to cache instead of disk or SSD and using caching servers to run your DB. Snapshots are stored on storage account
	+ SQL Managed Instances
		+ Does not support Zone Redundant Configs
		+ Does not support Hyperscale
		+ Effectively like managing a VM 
		+ SQL managed instances need extra node(s) called witness(es) which determine if any VMs are failing to alert for failovers. 



[^1]: RTO is short for recovery time objective