## Microsoft Purview Information Protection (MPIP)

MPIP is a collection of Microsoft Purview (formerly Microsoft 365 Compliance) to help you discover, classify,and protect sensitive information.

### MPIP 1 - Know you data

Understand your *data landscape* and identify important data across your hybrid environment. You can use pattern matching (Regex or ML) to find sensitive data. You can use these insights to see what users are doing with this data.

### MPIP 2 - Protect Your Data

Apply encryption and access restrictions.

### MPIP 3 - Prevent Data Loss

Prevent accidental oversharing of sensitive information


### MPIP 4 - Govern Your data

Create lifecycle events where data not needed is deleted.

## Azure Policies

An Azure policy is used to enforce organizational standards and to **assess** compliance. These policies only observe, they do not block actions.

For example, this service can be used to see if you met `HIPPA` requirements or `FedRamp` requirements.

## Resource Locks

You may need a lock a subscription, resource group, or resource to prevent deletion or modification. 

Using the Azure Portal you can set these lock levels:
1. `CanNotDelete`
2. `ReadOnly`

## Azure Blue Prints

Enables quick creation of a **governed** subscriptions. This allows you to compose artifacts based on common or organizational-based patterns into re-usable blueprints. Artifacts include resources groups, configurations, role assignments, ... . Blueprints allow you to lock down environments by ensuring that resources are provisioned according to a predefined set of rules.

This is very similar to ARM Templates[^1] but Blueprints are backed by globally available Cosmos DB. Also, Blueprints supports improved tracking and auditing of deployments.




[^1]: Azure Resource Manager Templates