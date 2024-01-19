## Azure App Service

An HTTP-based PaaS for hosting web-applications and rest-APIs. It has many integrations which makes it add things like Github, Custom Domains, Docker Hub, ... .

You pay based on your Tier:
1. Shared Tier - Free (no Linux Support)
2. Dedicated Tier - Basic, Standard, Premium, PremiumV2, PremiumV3
3. Isolated Tier

Azure App services can docker containers (or many of them).

### Runtimes
To choose a runtime you must choose a container if your runtime is not supported by default you must create your own container (*custom containers*) and *push* to the azure container registry. 

### Deployment Slots
This allows you to create different environments for your application; this can be useful when you want to separate your environments (QA, Testing, Prod, ...) . You are able to swap environments allowing for blue-green deployments.

### App Service Environment (ASE)

The ASE is a azure app service feature that provides a fully isoloated and dedicated environment for securely running App Service apps at high scale.  

These are great for horizontal scaling as you can create many per region and ASEs can be deployed in many AZs. They are priced in the *isolated tier* and can be used to configure security architecture. 

The two deployments are:
1. External ASE
	+ Exposes your app to the world via an IP
	+ Also connects to On-Prem via a site-to-site VPN
1. ILB ASE
	+  Same as the one above except it contains an internal load balancer in-front of the ASE. 


### Azure App Service Payment Plan


1. Free Tier
2. Shared Tier
3. Dedicated Tier
4. Isolated




Each Tier has more power and higher SLA.

