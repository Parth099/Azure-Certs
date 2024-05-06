# Deployments

## Compute Deployments

What are your choices if you want your application to be deployed on Azure Virtual Machines or other compute?

1. Visual Studio Publish
	+ This provides a button to upload code to a VM and run it
2. Chef / Puppet (CI/CD Tools)
3. Azure Pipelines
	+ Azure DevOps with custom scripts, approvals, and etc
4. Deployment Groups
5. Custom Script Extensions, ARM Templates, TF, ...

## Container Deployments

> Containers are meant to solve deployment issues initially

+ Azure Container Registry - easy to pull and push container images
	+ Tools like HELM will build and deploy containers based on GitHub repos.

## Database Deployments


+ DACPAC
	+ You can use a DACPAC file to push relational schemas between environments
+ SQL Scripts (`CREATE` statements)
+ Azure Pipeline supports DB deployments

## Storage Deployments

+ Azure Pipeline has a file copy task where it can move items between folders to get things ready for deployment
	+ See that you can use azcopy to import / export files during this *stage*
	+ You can even use SSH to copy files

## Web App Deployment (`PaaS`)

+ Web deploy can occur over the wire with VS tooling
+ Kudu
+ Github Integration 
+ FTP
+ Azure Pipeline Web App Tasks


## Service Fabric

Azure Service Fabric is a distributed systems platform that makes it easy to deploy, and manage scalable and reliable microservices and containers.