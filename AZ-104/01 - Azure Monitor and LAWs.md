# Azure Monitor and LAWs

> Helps Moniter resource statistics and helps an engineer determine if their infrastructure can support a workload.

You can monitor things like:

-   VM CPU Util
-   VM Network Util
-   Other services ...

and have alerts which perform actions like send emails when certain thresholds are broken.

Metrics are shown my scope and namespace. You are able to select a scope (can be granular like a single VM).

## Alerts

> Use this if you want to be notified on metric based on thresholds.

By default you have no alerts.

Alert Creation Steps

1. Selecting a Scope (Can be just a resource)
2. Choose a signal (metric)
3. Create the logic
    - This involves you setting up thresholds for your signal
4. Next you must choose what to do when an alert is met
    - You have to create actions. You can choose an existing action group or create new.
    - Action Groups are a resource that hold information on how to send a message and who to send it to.
        - **Important**: You can assign the same _Action Group_ to **many** alerts. 
5. Assign a alert severity and metadata

### Alert Types

See types at [Docs](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types).

The types are:
1. Metric 
2. Log Search 
3. Activity Log - These are like metric but action based. Ex: Shutdown of VM or a resource creation.

## Monitor: Activity Log

This is a log of all control-place actions on your azure account. For example it will record SA actions like uploading Blobs or actions like creating a VM. You can see which users are doing what with this tool.

## Log Analytics Workspace (LAW)

> Central logging Solution

This is a container for your log collections. You _tell_ resource which LAW to send logs to. Then you can query logs based on a `Kusto`[^1] query language.

The LAW operates on tables (Data Source) and rows. Initially you will have no tables.

### Saving Data to LAWs

The rules that persist data onto LAWs are known as Data Collection Rules which are located under `Azure Monitor`. They are `Data Source` and `Data Destination` type rules where evidently the destination would be the LAW.

When you route Windows logs to a LAW extensions get installed into the VM for this purpose.

Many rules like performance counters have a `sample rate` which checks the relevant attribute ever $s$ seconds.

### LAW Queries

> KQL Based

See [Docs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/queries)

### LAW - Alerts

You can use KQL Queries inside a LAW to trigger alerts. This allows you to have event-based[^2] alerts rather than metric based alerts.

Notice that many resources can _report_ to the same LAW, this allows for powerful alert systems and queries.

### Azure VM Insights

This feature does the monitoring and analysis **for you** and then alerts you of issues via the Azure Monitor Agent and routes logs to a LAW.

There are many visual features like the MAP which outlines the dependencies on your VM. It can help you develop a network profile of your system.


### Custom Logs

Notice that since MS built both azure and windows, LAW comes equipped to handle windows based logs. You need extra setup to handle logs from custom applications or a non-windows OS like `ubuntu`.

For this action you  need:
+ a Custom Data Collection rule 
+ a Data Collection Endpoint
+ a sample of the schema  of logs you will collect

Then you need to:

1. Create a table inside the LAW using your sample
2. Create a Data Collection rule
    + Use the endpoint from before
    + Select resource to obtain logs from
    + Create a custom data source entry in which you map the log file and LAW table
