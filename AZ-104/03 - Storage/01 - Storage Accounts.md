
# Storage Accounts
## Intro

Storage accounts is a service to persist data on azure with scalability. It is just named badly: it is **not** another account inside your already existing account; it is simply a container for all your storage services and saved data. Under this "account" you have access to many services under a namespace like Queue[^1], tables, CDNs, ... .  

## Azure Blob Service

> Optimized for storing unstructured data. 

To start storing data you need a container. All uploaded items are treated as `objects` that are **URL-accessible**.[^2]

Microsoft recommends using Azure Storage Explorer, a GUI tool to help look at your saved items visually.

Here is what it looks like:

![azure_storage_explorer_demo.png](../img/azure_storage_explorer_demo.png)
### Authorization 

By default, all objects and containers[^3] are set to private access. 

We have three methods of Authorization:
1. Access Keys
2. SAS - Shared Access Signatures 
3. Azure AD Auth


#### Access Keys

Each SA has two access keys:

![sa_akeys.png](../img/sa_akeys.png)

The connection string is used by SDKs to connect to the storage account. 

*Con*: These keys grant **full** access to the storage account.

#### Shared Access Signature

A shared access signature (SAS) is a URI that grants restricted access rights to Azure Storage resources. You are able to select:
+ type of access (container, file, ...)
+ length of access
+ operations permitted (read, write, delete, ...)
+ Allowed IP addresses

A SAS token/URL can be generated at the Blob Level (individual object) or at the storage account level. The latter having more options such as being able to give access to only a certain service like `blob` or `queue`. 

**Key Invalidation**: SAS Tokens ads URLs are generated via one of the access keys as they are used as a Signing key. To invalidate a SAS, rotate the signing key.

##### SAS: Shared Access Policy

> At the container level.

The first step in using a Shared Access Policy is selecting a permission type (Read, Write) and a Policy duration. This approach of granting access to a container is better then a SAS because to revoke access you simple remove permissions from the policy used to grant it. 
#### Azure AD Authentication



[^1]: Unsure why Queue Service, is under Storage accounts since its an Event-Driven queue messaging service. 
[^2]: By default, all objects are set to private access. 
[^3]: Containers are just "folders" that hold Blobs that aid in organization