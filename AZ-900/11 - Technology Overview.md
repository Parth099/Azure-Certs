## Database Services[^1]

+ Azure Cosmos DB - Fully managed NoSQL DB
+ Azure SQL DB - Managed SQL DB
	+ Additional Service: *Azure Database For MySQL/PSQL/MariaDB* (Also fully managed)
	+ Additional Service: SQL Server on VMs
+ Azure Synapse Analytics (Before known as SQL Data Warehouse)
	+ This is a *fully managed* data warehouse
+ Azure Cache for Redis
	+ Caches frequently used static data to reduce latency
+ Azure Table Storage
	+ Wide Column NoSQL DB hosting **unstructured** data while being schema-less
+ Azure DB Migration Service

## Application Integration

+ Azure Notification Hub - **Pub/Sub**; Has the ability to send notifications to any platform from any backend.
+ Azure API Apps - Quickly build and consume APIs; Routes APIs to Azure Services like Functions
+ Azure Service Bus - Reliable Cloud messaging as a Service Bus.
	+ Microsoft says it is a: _message broker with message queues and publish-subscribe topics_
+ Azure Stream Analytics - Serverless real-time analytics 
+ Azure Logic Apps - used to schedule, automate, and orchestrate tasks based on business process and workflows. 
+ Azure API Management - Used to manege multi-cloud APIs and adds additional functionality to your API.
+ Azure Queue Storage - data store for queuing and reliable delivering messages between applications

## Developer and Mobile Tools

+ Azure SignalR Service - Easily add real-time web functionality to applications.
+ Azure App Service - Easy to use service for deploying and scaling web-applications. Developers using this need-not worry about underling infrastructure
+ Xamarin - Mobile app framework that joins `.net` and Azure.

## DevOps Services

+ Azure DevOps - Overarching Service that contains the following:
	+ Azure Boards (Github Projects)
	+ Azure Piplines - CI/CD
	+ Azure Repos (Github Repos)
	+ Azure Test Plans - test and ship tests
	+ Azure Artifacts - create, host, and share packages. Useful when paired with CI/CD
	+ Azure DevTest Labs - Easy way to generate Dev/Test environments for developers.

## Cloud Native Networking Services

- Azure DNS
- Azure Load Balancer (OSI L4 - Transport Level)
- Azure Application Gateway (OSI L7 - Application Level)
- Network Security Groups
	- Firewall at the subnet level

## Enterprise / Hybrid Networking Services

> Networking that interface with Azure and external networks like on-prem/other cloud.

+ Azure Front Door - Scalable entry point for fast delivery of your Global Applications
+ Azure ExpressRoute - Connection between on-prem and Azure (50 Mbps to 10 Gbps)
+ Virtual WAN - networking service that brings many networking, security, and routing features into a single interface
+ Azure Connection - A VPN connection that securely connections two Azure local networks via IPSec
+ Virtual Network Gateway - site to site VPN connection between an Azure VNet and your local network

## Azure Traffic Manager

This operates at the DNS layer to quickly and efficient direct incoming DNS requests based on a selected routing method[^2].

This can be used to split users to simulate A/B testing.

## IoT[^3] Service


+ IoT Central - connects your IoT device to the cloud
+ IoT Hub - Enable highly secure communication between IoT applications and the devices it manages
+ IoT Edge - managed service built on IoT Hub. This is edge computing offloading: you offload computing to the IoT device nearest to you.
+ Azure Sphere 

## Big Data and Analytic Service 

+ Azure Synapse Analytics  - runs SQL queries against large databases 
+ HDInsight - runs open source softwares like Hadoop, Kafka and Spark
+ Azure Databricks - Service made to use the Spark based partner service 'DataBricks'
+ Data Lake Analytics - on-demand analytics job service that simplifies big data
	+ A data lake is a repo of **raw** data in its native format until its needed 
+  Azure CycleCloud - orchestrating and managing High Performance Computing (HPC) environments


## AI/ML Service

```
Artifical Intelligence
[
	 Machine Learning
	[
		Deep Learning
	]
]
```

+ Azure Machine Learning Service - Simplifies running AL/ML workloads allowing you to build pipelines for automation.

### AI Service

+ Personalizer - deliver personalized experinces for each user
+ Translator - realtime translation
+ Anomaly Detector - Detect Anomalies in data
+ Azure Bot Service - serverless scalable bot service
+ Form Recogniser - Automate the extraction of test, key/value pairs and tables from documents
+ Computer Vision
+ Language Understanding - NLP
+ QnA Maker - QnA Bot
+ Text Analytics - Sentiment Analysis + Key Phrases + named entities
+ Content Moderator
+ Face
+ Ink Recognizer

## Serverless Services 

 + Azure Functions
 + Blob Storage
 + Logic Apps
 + Event Grid - Allows you to react to events and trigger other azure cloud services such as functions



[^1]: Anytime SQL is mentioned without a flavor, recall we are on Azure and thus it will most likely be Microsoft's SQL
[^2]: Sample routing method: Geographic, Weighted, ...
[^3]: Internet of Things.