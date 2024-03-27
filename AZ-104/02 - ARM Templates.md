# ARM Templates

> ARM stands for Azure Resource Manager

The last section covered how to create resources via the command line. ARM Templates is similar but it is IaC in the form of JSON.

See these docs for a smooth introduction: [learn.microsoft](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)

The first section goes over the nodes[^1] present in all JSON ARMT[^2]. Refer to the first section to build any template as it defines the baseline for all ARMTs.

## Structure

From: [learn.microsoft](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)

```jsonc
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "languageVersion": "",
    "contentVersion": "",
    "apiProfile": "",
    "definitions": {},
    "parameters": {},
    "variables": {},
    "functions": [],
    "resources": [] /* or "resources": { } with languageVersion 2.0 */,
    "outputs": {}
}
```

### Resource Field

Each resource you want to deploy should be present in the `resources` array:

```json
{
    "resources": ["Resources go here. type: Object"]
}
```

Each internal `resource` block inside the array will contain a `apiVersion` field. This allows the internal resource manager to contact the correct version of the API to deploy the resource.

#### Multiple Copies of a resources

A naive approch would be to copy over blocks:

```js
{
    "resources": [A, A, B]
}
```

Where `A` and `B` refer to unique resource blocks. However, there is a better way:

We can define `A` as

```jsonc
{
    // ... properties and fields here
    "copy": {
        "count": int
    }
}
```

There may be other properties we need to define, for example a `"name"`.

Here is a concrete example:

```json
"resources": [
        {
            "name": "[concat(copyIndex(),'appstore10554344')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2022-09-01",
            "location": "North Europe",
            "kind": "StorageV2",
            "sku": {
                "name": "Standard_LRS"
            },
            "copy": {
                "name":"storagecopy",
                "count":3
            }
        }
    ],
```

> `copyIndex()` starts at $0$ .

The `[]` are used to call functions. The meaning of the function calls can be easily understool here.[^4]

### Variables

You can define variables under the `variables` node.

```json
"variables": {
    "loc": "East US"
}
```

Then you can refer to it via:

```json
"[variables('loc')]"
```

### Parameters

Similar to `variables` but used to inject values during runtime.

Example:

```json
"parameters": {
    "loc": {
        "type": "string",
        "defaultValue": "East US",
        "allowedValues" : ["East US", "West US"]
    }
}
```

and you can use it via:

```json
"[parameters('loc')]"
```

If there is no `defaultValue` you are required to provide one during runtime or if you are on the azure portal there is a input field for them. There is a `type` called `securestring`, when used it makes the field on the portal _password_ like.

Alternatively, you can do thw following to use secrets in ARMTs:
1. create a paramater file
2. create a `reference` to a Key Vault via its `id`
3. specify the secret name you are refering to
4. Now the parameter you want to fill in points to a Key Vault secret. 

#### Parameter Files

These files are used to **pass** params into ARM files. In this file you only define your params. See the [docs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files) for structure.

## Deployment

Options (not all) to deploy are:

1. Azure Portal via `Template Deployment`. The UI shows your changes before deployment
2. Azure Powershell / [Azure CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-cli)

You still need to specify which containers[^3] you want to deploy under.

[^1]: Often times fields in a JSON document are called nodes.
[^2]: ARM Template abbreviated
[^3]: Management Group, Subscription, Resource Group
[^4]: Recall all storage account names MUST be globally unique.
