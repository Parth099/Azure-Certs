# Azure File Shares (AFS)

The File share is a replacement for the file server which requires maintained unlike the *managed* AFS. 

You are able to view and edit the file structure & files via the Azure Portal. Unlike the Blob Storage, files are treated as files and not objects. To get the files via a system like a VM or a local machine you must **connect** onto the file share via a series of steps.

On the Azure Portal steps are shown to connect to the AFS, the script **contains** secrets.

The URI for the file share is defined via `\\<storageAccountName>.file.core.windows.net\<fileShareName>`

AFS uses the SMB protocol over port 445, this port should be open if you want to access the file share.

## Snapshots

You can take snapshots to protect your share from errors. You can browse and restore files. When you create a snapshot a Resource Lock by the name of `AzureBackupProtectionLock` is created to prevent accidental deletion of the snapshot (backup).

# [Soft Delete](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-enable-soft-delete?tabs=azure-portal)

This is to help recover from accidental deletion **of the file share**. It is enabled for 14 days by default and can be set to more days so you have more time to recover from mistakes. 

## Identity Based Access

See [FS-Access](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-active-directory-overview).

## Storage Encryption

> Note: Any reference to an encryption key in this section refers to the key required to decrypt the raw data.

You have the option of using Azure Key Vault to deliver encryption at rest, this is known as a CMK[^1]. You always have the option to use Microsoft-managed keys, this is enabled and ran by default.




[^1]: Customer Managed Key
