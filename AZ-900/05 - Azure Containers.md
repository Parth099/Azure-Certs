## Azure Container Instances (ACI)

ACIs allow you to launch containers without worrying about the underlying machines.

+ Containers are billed to the **second**.
+ Very granular sizing (CPU, MEM, ...)
+ You can persist storage files with Azure Files
+ ACIs can be hit as they come with fully qualified domain names.

### Container Groups

CGs are collections of containers that get put on the same host machine. They share:
1. Lifecycle
2. Resources
3. Local Network
4. Storage Volumes

> Multi-container groups currently only support Linux machines.

#### Container Restart Policies 

1. Always: Containers are always restarted
2. Never: Run one time only
3. OnFailure: Restart on a non-zero exit code.

#### Container Environment Variables 

These can be set via Azure Portal, CLI, or powershell[^1]. Within the CLI you can set a secure flag to ensure nobody sees the plain text version.

#### Container Persistent Storage

To persist state you need to mount external volumes like:
+ Azure Files (file-share)
+ secret volume
+ empty directory 
+ Cloud Git Repo

This is not available via the portal and needs to be done via the CLI. 



[^1]: Anytime CLI or powershell is mentioned I mean both.