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

Key Ideas I saw
+ When  performing application migration focus on the application, do perform an infra "Lift and Shift".

left off: [bookmark](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/landing-zone-journey)
  
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
