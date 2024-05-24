
# APIs

## API-Management Service

> Also known as API Gateway

The challenge with providing an API as a company is
+ Security (Malicious Users / Throttling)
+ Scaling


With APIM developers can
+ Learn / Try (APIM spawns a website)

The owners of the API can
+ Protect by verifying and approving certain users 
	+ You can even make it a B2B API
+ Establishing limits 
+ Gaining Usage Metrics / Analytics
+ Point the API to any internal service (Logic App, Function, VM, ...)
+ Easily Host API Documentation
+ Perform transformations (ex: XML to JSON) meaning you can modernize legacy systems. 

**Polices** can alter the behavior of your API system at 4 integration points
+ Inbound
+ Backend
+ Outbound
+ On Error

These policies allow you to perform actions such as 
+ Setting API Key quotas or overall quota for all users
+ Checking HTTP Headers
+ Validating JWT Tokens
+ Banning IP CIDRs
+ ...
all in a XML configuration file

Other more advanced policy examples include
+ Caching
+ CORS
+ Transformations

## App Service - Function App

Functions can also serve as an API. With functions you get three types of funciton HTTP Authorization Levels:
1. Anonymous - no API Key Required
2. Function - API Key Required
3. Admin - Master Key Required


