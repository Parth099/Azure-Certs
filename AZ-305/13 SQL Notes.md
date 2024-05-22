# SQL Notes

1. **SQL DB Geo-Replication** does **NOT** support writes on primary region failure or a successful failover. 
2. What are "Azure SQL Database failover groups"?
	+ A failover group is a set of DB (managed[^1] or instance-wise)
	+ ![Failover-grp-ex](https://media.tutorialsdojo.com/azure-sql-failover-group.png)
	+ You can manually force a failover or it can be managed by Azure (*user policy*) to happen automatically.
3. SQL Product Family only supports RSA 2048 & 3072
4. All 3[^2] support a data retention period of 10 years.
5. **Serverless SQL** - There is a compute tier on azure that scales based on demand for SQL DBs. It will only incur cost during usage and can be auto-paused[^3]. This model cannot be used with DTU, only vCore model can be employed here.
6. 




[^1]: This refers to "Azure SQL Database Managed Instance" where Azure manages the instance. It exists to provide easy migrations.
[^2]: Azure SQL Database, Azure SQL Managed Instances, Azure SQL on VMs
[^3]: Configured time in which no activity results in shutdown until it gets a call.