
## Basics

+ 60+ Regions over 140 countries

A **geography** is a discreet market of two or more regions that preserve *data-residency* and *compliance-boundaries*. Examples of geographies are: Canada, Unites States and Azure Geography... . A reason to use this is to ensure your data never leaves your zone.

**Important**: Not all services are available in every region.

There exist two types of regions:

1. Recommended Regions (Most services are available here)
2. Alternate Regions: "These regions **extend Azure's footprint within a data residency boundary where a recommended region currently exists**. Alternate regions help to optimize latency and provide a second region for disaster recovery needs but don't support availability zones."

A service can be GA (general available) when it is ready to be used by the public


A service can be:
1. Foundational: When GA, immediately or within 12 months in both types of regions.
2. Mainstream: Just like foundational yet it will only become available in alternate regions based on customer demands. 
3. Specialized: Only available based on customer demands on both regions.


## Paired Regions


Each azure region is paired with another region 300mi away to ensure no down times in the event of failures (updates, disasters, ...).



## Special Regions

> To meet compliance or legal reasons



## Availability Zones

A physical location made up of one or more data-centers. A region will contain generally contain three **isoloated** AZs. 

> Recall Alternate Regions have no support for AZs.
> Recommended Regions have at-least 3 AZs.

An AZ is a combo of a fault domain and an update domain.

A **fault domain** is a logical grouping of hardware to avoid single points of failure within one AZ. 

> A fault domain represents a group of resources that share a common power source and network switch. These resources are physically separated within a data center to reduce physical failures.

An **update domain** ensures your resources do not go offline when azure applies updates.
  
You can utilize Azure Availability Sets to ensure any VMs you setup are not in the same fault/update domain to ensure uptime.

![create_avail_set.png](create_avail_set.png)

Above is an image of creating a Availability set. If you launched 3 VMs in this AS you each would be in a different fault domain.

**Important**: Not all services are enabled for use on any account. Check Resource Providers under *subscriptions* on your azure account.

**Important:** Data Transfer between AZs and Regions is **NOT FREE**.

