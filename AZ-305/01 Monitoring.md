# Monitoring Partial

## Log Routing

Two types of log data:
1. Metrics - Numerical Values at near real-time
2. Logs - event driven, varies in data. Can be queried. 


**Considerations**
+ Data leaving a region to/from a LAW is changed per `GB`. 
+ Does data from different clients / purposes need to be separated?
+ How much logging do you need? Do you need each metric / log per resource type?
+ How long should logs be stored?

## Azure Monitor

Logging and diagnostics is under the Azure Monitor service. You can view resources here that do and do not have logging enabled.

## Monitoring

### Monitoring - Logs/Metrics

Note only two are highlighted below but many services have monitoring. Some other services are SQL and Containers. 

#### Compute

When deploying resources such as `AppService` or `VirtualMachines` you are able to turn on `Application Insights`. This will allow automatic monitoring without modification to your original code. Examples of monitoring are:

-   popular web pages
-   metrics like Request In/Out
-   ...

Application Insights is also able to offer manual instrumentation where you are able to inject code which for example will show you where and when execptions are being thown or which sections of code are slowing down execution.

#### Storage

Monitoring for storage accounts is automatic. You can get metrics per timeframe like:

-   Storage Account Errors
-   E2E Latency
-   ...

### Alerts

Alerts can take action when a metric hits a certain threshold over some timeframe. Actions are taken via the use of action groups which define the following:

- a notification
- an action

#### Alert - Notification

```
[
    {Notification Type -> UsersGroupA},
    {Notification Type -> UsersGroupB}
]
```

One example is sending a `text-msg` to a user on high VM CPU usages. 

#### Alert - Action

Alerts can kick off actions such as a Azure Function App Run or an Event Hub Event. You can even run an external webhook. 

### Monitor Log - Querying

You can use KQL to view log information. For some queries you can utilize the KQL charting functionality. 


## Microsoft Sentinel

> Azure Cloud Security Service

This service is a SIEM (Security information and event management) solution. You pair this service with a LAW and detect threats via queries. You may connect Sentinel to other products (even non-microsoft) like Entra ID or AWS to detect external threats.

The first step is `hunting`: You search the LAW(s) to find undetected threats to deliver a "hypothesis".
