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

A DTU is a relative power unit. This means you should expect double the performace when comparing a 10 DTU DB to a 20.

All of the above applies to **relational** DBs. With Cosmos DB pricing has two dimentions:
1. Storage
2. RU/s (Request Unit)

It represents the number of requests per second the DB should be able to serve. The reason it is different than DTUs is because Cosmos DB can host different types of DBs like SQL or MongoDB.

## Data Retention

Notice that many of the managed service already give you:

- Automatic Geo-redundant Backups
- Transaction Logs
- You can design retension and backup points which can last upto 10 years 
- Soft Delete Features
- Restore to another region

## Availability, Consistancy, Durability

+ Availability involves having replicated copies in other locations
  - Challange: Replicaiton Lag
+ Consistancy defines how "correct" your databases are. Under Cosmos DB you can define how consistant you want your replicas to be.
  - Challange: Consistancy sacrifices speed.
+ Durability is the idea that if a transaction is committed, it is never lost.
  - Challange: Durability is costly and mildly sacrifices speed

There exists Azure SQL Database Business Critical Tier which provides very low time SLAs for replication and backup recovery times.
