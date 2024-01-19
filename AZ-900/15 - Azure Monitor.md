## Pillars of Observability

> to obtain observability you need Metrics, Logs, and Traces. (You need each)

+ Metrics: Number measured over time (ex: CPU Util/sec)
+ Logs: text file where each line contains event data with a timestamp.
+ Traces: A history of request that travels through multiple apps/services to help pinpoint failures.

## Azure Monitor

Solution for collecting, analyzing, and acting on Telemetry for cloud/on-prem environments.

### Anatomy 

![azure_monitor_anatomy](../img/azure_monitor_anatomy.png)

#### Log Analytics

This is a tool used to edit and run log queries with data in Azure Monitor logs. The query language is called `KQL`.

#### Log Analytics Workspace

This is a unique environment for Azure Monitor Log Data.

Each workspace has its own data-repo and configs, and data sources (see image above) and solutions that are configured to store their data in a particular workspace.

#### Azure Alerts

These notify you of application or infrastructure issues.

They come in three flavors:
1. Metric Alerts
2. Log Alerts
3. Activity Log Alerts

![azure_alert](../img/azure_alert.png)

The monitor condition is used to track and log the state of the alert regarding if it was resolved or not.

#### Application Insights

> Sub-service of monitor, an APM (Application Performance Management) service.

+ **APM**: Monitoring and management of performance and availability of apps. Used to maintain a certain level of service.

Application Insights can
+ detect performance anomalies
+ powerful analytic tools to help you diagnose issues and peer into application performance (ex: Page load times)
+ powerful analytic tools to help you see what users are doing with your software


You simply need to instrument your application with Application insights to use it.

![application_insights.png](../img/application_insights.png)

