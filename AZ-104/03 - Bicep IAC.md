# Bicep

> IaC tool; **Azure Specfic**

Docs: [learn.microsoft](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

Bicep templates are deployed via the ide or powershell.

Unlike ARM Templates, resource blocks in `bicep` do not require a `dependsOn`. Azure is able to orchestrate the deployment whilst managing resource dependencies. It looks and mildly behaves like terraform with its variables, functions, outputs, and modules. You are able to track deployments on the Azure Portal. Just like ARM Templates, there are parameters and parameters. If values are not provided it is prompted. There are secure strings as well via decorators (see below) or Key Vault.[^1]

There are a few cool features not seen on terraform:

-   [Parent-Child Resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/child-resource-name-type)
-   [Parameter Decorators](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters#decorators)


[^1]: You need to use the `existing` keyword to import the KV into your `bicep` file and use the secret getter method to get the values.
