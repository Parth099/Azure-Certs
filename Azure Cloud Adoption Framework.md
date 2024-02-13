# Azure Cloud Adoption Framework: Landing Zones

Link: [MS](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)

An Azure landing zone is an environment that follows key design principles across eight design areas. The point of addressing each design area is to 'accommodate all application portfolios and enable application migration, modernization, and innovation at scale'. 

1. MS Entra Tenant
2. IAM
3. Resource Organization
4. Network Topology
5. Security
6. Management
7. Governance
8. DevOps

## Some Key Ideas
+ When  performing application migration focus on the application, do perform an infra "Lift and Shift".

## Terminology
+ Azure tenant - 'A dedicated and trusted instance of Azure AD that's automatically created when your organization signs up for a Microsoft cloud service subscription'. It is essentially a container for an orgainzation.
+ Azure Managed Identities
  + System Assigned Identity - Identity created and managed by Azure. This is a 1:1 mapping between resource and Entra entry. This identity is generated when a resource is created.
  + User Assigned Identity - This is when a user creates an identity and assigns it to a Azure resource. This allows you to assign many resources the same identity for easier management but overdoing this **does** violate security best practices.
  + To remember pros/cons of each take a look at the images on [ms-docs](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identity-best-practice-recommendations#choosing-system-or-user-assigned-managed-identities)
+ Azure Role-based Access COntrol (RBAC) - Fine grained permissions for Azure resources (yes users are Azure Resources)
+ Service Principal - [SOF](https://stackoverflow.com/questions/48096342/what-is-azure-service-principal) To put it simply: 'Service principal just work as an impersonation for user in Azure AD' via a `id`/`password`. You assign permissions and use this identity to commit actions without having a login popup.  
 
## Design Areas
### MS Entra Tenant

This is setting up your management structure (billing offer, subscriptions, ...). 

### Identity and Access Management

This design area is concerned with syncing identies and permissons to Entra ID. This area is not concerned with any _governence_ features like policies or zero-trust.

When creating your infra, you need to select the correct Auth Service. There may be reasons to pick Entra ID over Entra Domain Services or setting up your own AD DS servers.

### Resource Organization

This refers to the design of Subscriptions and Management Groups and refers to Naming and Tagging methods.

Subscripitions serve as a boundary for policy assignments. 

### Network Topology

The goal of this is to package together dependencies like hybrid or multi-cloud dependencies so future networks have it built in. 

The docs state that it is in the connectivity management group that subscriptions will host the Azure networking resources required for the platform, like Azure Virtual WAN, Virtual Network Gateways, Azure Firewall, Azure DNS private zones, and esteblish hybrid connectivity. 

Azure reccomends deployment of a Virtual Network Manager in the Connectivity MG to manage VNets across subscriptions. 

### Security

This refers to applying security requirements consistently across all workloads with Zero-trust and advanced network security. The docs are mostly about using Entra ID and MS Defender.

This area also focuses on using signals to access trust ([Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)).

# Azure Well-Architected Framework

Link: [MS](https://learn.microsoft.com/en-us/azure/well-architected)

> High  level notes

Five Pillers:
1. Reliablity
2. Security
3. Cost Optimization
4. Operation Excellence
5. Performance Efficiency

There is a tool on azure to see how well your workload fits this framework.

## Pillars

### Reliablity

> Design for failure

Application must be able to detect, withstand and recover from failure. It also needs to be highly observable. 

### Security

Calls to use the Zero-trust model, the encryption of data at all times, and applying bounds to your system so the software cannot be used for incorrect things[^1].

_Note_: Azure reccomends zole-based security.

### Cost Optimization

Refers to ROI and external financial constraints.

### Operation Excellence

Refers to the ability to deliver applcations fast via Agile methods and to treat problems to their cause rather than symptoms. The problems are found via observable software and logging. This way progress can be measured and developers can see trends in bugs.

### Performance Efficiency

> The goal of performance efficiency is to have just enough supply to handle demand at all times.

PE is about matching load and resources at an appropriate level; resources should not be overwhelmed or under-utilized while also adhereing to a SLA for latency.

[^1]: For example (networking) you should block the exflitration of data.
