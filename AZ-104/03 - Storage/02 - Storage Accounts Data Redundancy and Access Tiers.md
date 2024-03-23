
# Data Redundancy and Access Tiers
## Data Redundancy

You need Data Redundancy to plan for protect against unplanned events. 

The basics are laid out in the AZ-900 Note 7.

By default multiple copies (3) of your data is saved at the minimum. This is called Locally redundant storage (LRS). The word locally implies it is stored in the same region as your Storage Account.

+ **LRS** can protect from Server Rack failure.
+ **ZRS** can protect from AZ failure as data is replicated across three AZ. (3 copies of your data)
+ **GRS** - Can protect against region failure by copying your data to another region. Three copies exist in your region (LRS), three in another region (LRS). 
	+ By default the secondary region is not accessible until the primary goes offline.
	+ You have another option in *GRS* where the second region is simply a read-access GRS and both regions can be accessed at once.
	+ **Important**: You do *not* select a region. The region is selected as Azure has pair regions.
+ **GZRS** - 6 copies exist. Primary region uses ZRS while secondary region uses LRS.
	+ Has the same options as GRS with the read-only vs default.

## Access Tiers
There is a cost for storing and accessing objects.

You can save money if there is a access pattern like for example objects are accessed frequently week one but then infrequently accessed later.


+ Hot  - accessed frequently (High Storage Cost, Low Access Cost) 
+ Cool - accessed infrequently (Lower Storage Cost, higher Access Cost)
	+ Data should be stored for min 30 days before being shifted
+ Cold - Like cool
	+ Data in the cold tier should be stored for a minimum of 90 days
+ Archive - for long term backups (Lowest Storage Cost, Highest Access Cost)
	+ Data should to be stored at min 180 days before being shifted

**Note**: For each tier above that has some $d$ days requirement. If the object is deleted or moved it suffers an early deletion penalty. Suppose the object has been in that tier for $n$ days already. The penalty is then charged based on $\max{(d-n, 0)}$ days.

You can set the default tier to be any tier but `archive`. You must set individual blobs to be of archive tier.

### Life-cycle Policies

You can set objects to be moved into different tiers or deleted based on their creation/last modification date. You can also apply filters where rules would apply apply to certain containers. 

## Object Replication

This allows you to copy **blobs** between storage accounts based on *rules* that decide what gets copied. 

+ Requires Versioning to be enabled on the source and destination. 
+ [Change feed](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal) required to be enabled on the source. This is simple a log of all the *changes* to your SA.

The copied access tier reflects the default (inferred) access tier of the destination. 


More about the copy rules (AKA copy policy):
1. Inside the SA you can choose to copy a container to another container. The whole SA need not get copied. 
2. You can choose between three rules for choosing objects to copy:
	+ Only new objects
	+ All
	+ Custom
3. To end the replication you can remove the rule.