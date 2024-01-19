
## Zero Trust Model

> "trust no one, verify everything"

### Three Principles
+ Verify Explicitly 
	+ Always authenticate and authorize based on all data points
+ Least Privileged Access (JIT/JEA)[^1]
+ Assume Breach
	+ Minimize blast radius 

### Six Pillers
+ *Identities*
+ Endpoints
+ Apps
+ Data
+ Infrastructure
+ Networks

### Seven Layers of Security

![seven-sec-layers.png](../img/seven-sec-layers.png)

---


## Azure Security Center

> Unified security system for Azure Infrastructure

## Azure Defender

> Located in the Azure Security Center

Tool that lets you see the resource types that are in your subscription that can be protected by azure defender.

### Scopes
Azure Defender has many plans for specific Azure resources:
1. Azure Defender for Servers
2. Azure Defender for SQL
3. ...

### Security Alerts

These describe the details of effected resources and sometimes suggest remediation steps. In some cases you can trigger logical app responses based on alerts. 

### Insights
Insights sorted by *priority* into pressing security concerns relevant to your subscription.

### Advanced Protection
These are additional security features driven by analytics. 

### Network Map
The Defender Network Map provides a graphical view with security overlays giving the user hardening suggestions. 

## Microsoft Defender for the Cloud

> unified infrastructure security management system that strengthens the security posture of your data centers and provides advanced threat protection across your hybrid workloads in the cloud

It also contains the Regulatory compliance dashboard.
### Microsoft Defender for Identity 

+ cloud based security solution that leverages on-prem AD signals (see note 09) to detect anomalies, investigate advanced threats, and compromised identities by monitoring domain controllers event logs.

### Azure ARC - Hybrid Cloud Protection

This can help protect VMs residing in other locations like GCP or AWS.

ARC is a control plane that can manege compute resources across cloud providers, on-prem, and edge.

## Azure Key Vault

Helps safeguard cryptographic keys and other secrets by tightly controlling access to tokens, passwords, certs, API Keys, and etc.

It can also:
+ Create and control encryption keys used to encrypt data
+ Provision and deploy Certificates (SSL)
+ Hardware Security Module (Hardware designed to store encryption keys)
	+ All keys are written on volatile ram and if HSM shuts down all keys are lost.
	+ Milti-tenant (FIPS 140 L2 Compliant)
	+ Single-tenant (FIPS 140 L3 Compliant)

## Azure DDoS Protection

Types of DDoS Attacks
1. Volumetric Attacks - Legit looking traffic 
2. Protocol Attacks - false protocol requests (flooding layers 3 and 4)
3. Application Layer Attacks - Ex: SQL-injection
	+ use WAFs[^2] as protection 

### Tiers
1. Basic Protection *Free*
	+ Turned on by default
2. DDoS Protection Standard
	+  ~3k$ / Month
	+ Metrics, Alerts, and Reporting
	+ DDoS Expert Support
	+ Application and Cost Protection SLAs


## Azure Firewall

> *managed* cloud based network security service meant to protect VNets

It is a fully stateful Firewall as a Service with:
1. built-in High Availability
2. unrestricted cloud scalability

Azure firewall is meant to be deployed in its own VNet and all traffic to your other VNets pass through this Central VNet, this allows users to apply things like Microsoft Threat Intelligence to block known malicious IPs & FQDNs[^3]. 

## Application Gateway

This is an application level load balancing service. This LB can look at the HTTP request and service each request that way.

Each AG has a frontend and a backend.

The frontend is the IP address type (Public, Private, or Both) while the backend represents the resources to route to like Scale sets. 

### AG Routing Rules

A listener *listens* on a port/IP mapping for the traffic that uses a specific protocol. When these conditions are met the AG will apply the routing rule.

There are two types of rules:
1. Basic - Forward all requests for any domain to backend pools
2. Multi-Site - forward requests to different pools based on host-header and host-name

Listeners can be ordered. 

## Azure Role based Access Control (R-BAC)

This helps manage who has access to Azure resources, what they can do with these resources and what areas that have access to.

Role assignments is the way you control access to resources.

**Role Assignments** are made up of three things:
1. Security Principle 
	+ Identity attempting to request access
1. Role Definition
	+ Collection of permissions like CRUD. Roles can even be high level like the rules below.
	+ The four default high level roles are: Owner, Contributor, Reader, and User Access Administrator. 
1. Scope
	+ Set of *resources* the role assignment applies to.

There is a similar feature known as "Azure Resource Manager Locks" that can put locks on things like subscription, resource group, or resources to prevent accidental deletion or modification critical resources. 

## Management Groups

![ManagementGroups.png](../img/ManagementGroups.png)

This helps manage mulitple subscriptions (accounts) into a hierarchical structure. Notice there is a ***root***. All subscriptions within a management group automatically inherit the conditions applied to the management group. 

## Service Health

This houses the current information on:
+ Service impacting events
+ planned maintenance 
+ etc.

There is,
1. Azure Status: shows service outages in Azure
2. Azure Service Health: Personalized view of health of services and regions *you* are using
3. Azure Resource Health: information about health of your individual cloud resources 

## Azure Advisor

This is an automated cloud consultant that helps you follow best practices.

It helps with the 5 following sub categories:
1. High Availability
2. Security
3. Performance
4. Cost 
5. Operation Excellence 

Also
+ Shows which VMs are not backed up via Azure Backup Service.

## Azure Policy

**Azure Policy** helps to enforce organizational standards and to assess compliance at scale. Through its compliance dashboard, it provides an aggregated view to evaluate the overall state of the environment.

Azure Policy will evaluate resources by comparing them to business rules defined in JSON known formally as policy definitions.

A policy can be assigned to any scope (subscriptions, management groups, or individual resources). It cannot be applied across subscriptions however.

**Important**: Azure Policy is *proactive*, it does not effect existing resources only ones deployed post-implementation. 


[^1]: Just-in-time, Just-enough-access
[^2]: Web Application firewall
[^3]: Fully qualified domain names

