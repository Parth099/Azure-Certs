# Azure DNS

## Azure Private DNS

Allows for custom name resolutions in _linked_ VNets. You are able to link VNets to private DNS zones via `Virtual Network Links`. You are unable to override certain domains like MS Service domains or Azure Gov domains.

### Virtual Network Links

Once a private zone is created it needs to be linked to a VNet. Once linked, any VM in that VM will, by default, have access to the records in the private zone. You also have the option for `auto-registration`. This allows all present and new VMs to have records automatically created when spawned. If this is not enabled, the private zone is used **only** for resolution.
