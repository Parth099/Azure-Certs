# Cram

- Azure AD is charged by User
- Dynamic Groups cannot have Azure AD Roles
- `Entra Id Cloud Sync/Enta Id Connect Sync` connects on-prem to Azure
    - `Cloud Sync` needs a lightweight agent in the Domain Servers
- Entra ID Connect Health provides health information about Azure Entra ID and On-Prem
- Password Hash Sync hashes the hash of the existing password and uses cloud to authenticate
- Pass-Through is similar but uses on-prem AD to connect
- Federation: Use some other 3rd party who would issue a token which would be used to authenticate to Azure
- licenses
    - Conditional Access is P1+
    - Self Service Password Reset is P1+
    - Identity Protection (User Risk, Sign-Risk) is P2
        - Not same as conditional access
    - PIM is P2
    - Access Review is P2

- Formerly Azure AD DS, Entra ID Domain Service is a **managed** service that provides a domain service which live in your virtual network and allow VMs to join the managed domain. The Servers are mamaged by azure however[^1].
  - Limited compared to hosting it yourself
- External Accounts can be added via EntraId B2B and authentication occurs on their tenant while authorization occurs on your tenant.
    - Examples of Account times: `email`, `facebook`, ...

- Entra ID roles are Tenant Roles *by default*
    - We can instead use Adminstrative Units where you must manually add groups and manually add users so we can only have control over those people.
        - Note: **Adminstrative Units** are targets for Scopes when assigning roles.

- You can use Azure Authentication via MSAL, this enabled developers to safely aquire security tokens to access Azure Secure Web APIs. Application Developers would use this for their development.


[^1]: You are not going to deploy these.

# Networking Misc

- Traffic Manager is a Global DNS LB

## VPN Gateways

> [Source](https://tutorialsdojo.com/azure-vpn-gateway/)

They support three connection types:

1. VNet to VNet
2. Site to Site
3. Point to Site

There are two routing policies:

1. Policy Based

- In this method there are rules and packets are _matched_ against the rules and based on the match the next hop is determined.

2. Route Based

SKU Levels

- VpnGw1 - Supports up to 250 Point-to-Site connections
- VpnGw2 - Supports up to 500 Point-to-Site connections
- VpnGw3 - Supports up to 1000 Point-to-Site connections
- Basic

There are also tiers 4 and 5.

Note there also exists Tiers: VpnGw1AZ - VpnGw5AZ which are zone resilient versions of the SKUs above.

---

To create a site to site connection you need to:

- Create a VNNet + Gateway Subnet
- Create a local network gateway[^1]
- Create VPN Connection
- Verify VPN Connection

---- 

**Tunneling Protocols**

- Site to Site only supports IKEv2

## Express Routes (ER)

- Provides connectivity between regions
- Express Route Preimum Tier
  - Allows you to by pass Gropolitical boundaries
  - 10000 Routes Capability
  - Increases Vnet Link to ExpressRoute Limit
- ER Direct provides 100 Gbps on two active active connections (so 200 Gbps)
- Priced only when data leaves Azure, rates differ by region

### Encryption over ERs

You can deploy the Azure WAN to establish IPsec/IKE VPN from your on-prem to azure. This works with the private peering feature of the Azure ExpressRoute.

### Creation of a Private ER Steps

1. Create ER and Connect it to VPN Gateway via WAN
2. Create Site to Site COnnection via WAN
3. Use Private Peering config for ER
4. Download VPN and set up on a device for testing.

## App Service

Here are the steps to add a custom domain:

1. Add a Custom Domain on Azure
2. Add the `.azurewebsites.com` CNAME record to your domain provider
3. Add your .pfx cert file to your app to allow it to securely communicate

- By Default VNet Integration is supported by the `Basic` Plan. To then use VNet Integration you need to created a dedicateed (Delegated) subnet and then enable Vnet Integration.

### Function Apps

- VNet Integration requires `Premium` Tier

[^1]: A Local network gateway is a Azure Object that represents your local on-prem network. It contains details about your on-prem network like the routable IP address of your firewall or router along with additional information like addres blocks in your local network. Note this is surface level, it requires more information than that.


# Intro

- Multi Tenant Cloud Based Directory for IAM
  - Users
  - Groups
  - Devices
  - ...
- Provides SSO Functionity
- Has Licences (Free, 365, `P1`, `P2`)
  - Certain Usecases will require higher Licences like `P2`. (Ex: Creating Custom Entra Id roles requires a P1/P2 License)
  - You can use different licences at the same time as there are certain identities you would like to protect

## Surface Level Features

- You can change your domain. By Default it is derived from your email.
- You can buy Licences and apply it to identites at a cost per month
- MS Entra Smart Lockout (Protects against Password Brute Force)
- Microsoft Entra ID Protection (Detects Risky Users/Apps/Sign-ins) from trillions of Signals
- Microsoft Entra entitlement management
  - uses Microsoft Entra business-to-business (B2B) functionality to facilitate access sharing and collaboration with external individuals who are not part of your organization.
- Microsoft Entra Password Protection - Prevents weak and common passwords
- Microsoft Entra Application Proxy (requires P1+ License)
- Access Reviews; Access reviews only manage Microsoft Entra Groups
- Microsoft Entra Permissions Management : cloud infrastructure entitlement management (CIEM) solution that provides comprehensive visibility into permissions assigned to all identities. For example, over-privileged workload and user identities, actions, and resources across multicloud infrastructures

# Users

Types:

- Internal
- External

External users can be invited to the AD via email. External users rely on their home tenant's admins/AD to manage their passwords where as login details for internal users can be managed from Azure AD.

## Self-Service Password Reset (SSPR)

Users can reset their own password based on a Admin defined procedure. The user needs to _vertify_ who they are such as email, text message, or authenticator app. On Azure, you can force users to provide one or two identity proofs. These proofs can be the ones listed above _or_:

1. Office Phone
2. Security Questions[^1]
3. App Notifications

The user can select to set these up on registration. This is similar to self-password reset on banking sites.

# Groups

Types

- Microsoft 365
  - These groups are NOT used to control access. They are usually onlyused for collaboration.
- Security

Groups cater to all types of Identities (Internal or external). You can manually add users or you can create dynamic mamberships to auto include/remove users from a group. You can have groups contain other groups.

Entra ID allows you to create rules and test them on users to ensure your rules appear to do the function you want.

The type of group that can be restored are Office 365 groups. You cannot restore Distribution Lists or Security groups.

Users can find their own groups to join, Admins can set up groups to require approval before joins or allow for auto-joins.

## Expiration

Groups can be configured to expire automatically after a period of inactivity. You are able to set an expiration period. Group owners are notified before expiration and if the group is actually expired you have 30 days to restore it.

In activity is defined by

1. No Members added/removed
2. No Permission Changes
3. No Resources shared within the group
4. No group messages

[^1]: Admin can create questions in addition to default questions. You can also select which users are able to SSPR.

## Administrative units

Administrative units offer a focused way for loads to manage users and groups specific to their geographical or organizational segment (unit). This granularity in management helps maintain localized control over access and permissions, while still aligning with the broader security policies and governance structures of the organization.

# RBAC

There is

- Entra RBAC
- Azure RBAC

## Entra RBAC

Azure RBAC deals with managing resources while your Entra RBAC focuses on acess to idenitity objects like groups or applications.

There are some prereqsites that need to be met when assigning Entra Roles. For some roles, MFA needs to be enabled. Many 365 roles are contained here. Examples of Entra Roles are `Global Administrator` and `User Administrator`.

## Session and Grant controls

> Microsoft Entra ID, provides various security and access control mechanisms to manage how users access applications and resources. Two important concepts in this context are grant controls and session controls.

**Grant controls** are used to enforce specific conditions that must be met before access to a resource is granted. These controls are evaluated at the time of authentication and can include requirements like MFA or a domain-joined device.

**Session controls** are used to manage and monitor user sessions after access has been granted. These controls can enforce additional security measures during the session and can include things like re-authentiation, presistent browser sessions, or Application Enforced Restrictions.

Session controls are applied after access is granted, managing the user's session and activities. 

## Misc Details

> Full docs are not kept since I am familar about this stuff

- You are able to assign roles at any level (resource, resource-grp, sub, mgmt-grp)
- Custom Entra Roles require P1/P2 license




# PIM

> Privileged Identity Management

Consider a user U which needs to sometimes create user accounts. Should this user have `User Administrator` role? No, as then they would be able to create users all the time. This is where PIM is needed.

Under PIM, a role is assigned to you but not active. You can _breakglass_ when you need to, and when you do this MFA[^1] or other items may trigger such as other admin approvals[^2]. With PIM there is a limit to the access, for example you can allow the _breakglass_ window to be as long as 24 hours long. Users can also provide an _optional_ justification for the PIM. Clearly the most important feature is the audit history of the access and access reviews which can remove access from stale accounts.

You are required to have ONE of the following licences
- P2
- Enterprise Mobility & EMS E5


---

As a admin you will use the PIM portal to make users eligible for the roles by selecting the role as well as selecting the date window where they are eligible.

You are able to select many options like:
- notifiying other users when role is activated
- time of activation window (How long role can be used to)
- selecting approvers (0 or more) to approve PIM request


[^1]: Std MFA proceduces such as text message or Authenticator Apps
[^2]: This includes MS Entra Conditional Access Authentication Context

# Identity Protection

> This speaks on Entra Indentities and not UMIs/SMIs

- requires P2
- Security Admin has Full access to Identity Protection
- Security Operator can perform actions like negating risk and approving sign-ins.

## How it Differs from Conditional Access

Identity Protection's Focus is primarily on detecting and mitigating identity-based risks using machine learning to determine risk from signals and it will automate response based on that risk. CA just enforces rules you have set up. CA is more so for compliance like enforcing IPs, Locations, devices, ... .

Used together, Identity Protection can inform CA of risks which can cause it to take actions.

## Zero Trust Model

- Never assume trust -> instead verify at each step
  - this is because most transactions are not under the same organization

## Entra ID Identity Protection

This service automates the detection and remediaiton of user risks and sign-in risks which [risks] can be exported.

It does this with he help of three sub-services

- Conditional Access
- Sign-in Risk Policy[^1]
  - See User Risk Policy below. Only difference is the action is block access or allow access with MFA
- User Risk Policy[^1]
  - With this you choose:
    - A Set of users
    - Risk level (High to Low)
    - Action to occur: Block Access or Allow access after a password change (optional)[^2]

With these you can enforce additional extra proof of Identity (MFA, Security Questions) when a user's sign-in risk is high. If your user risk policy threshold, actions to secure the user's sign-in will only trigger IF the the risk is determined to high.

Risk is determined with multiple dimentions

- Unfamilar Sigh-in properties - This is when a sign-in deviates from a users general pattern
- Known negative IP address
- Leaked Credentials Detected
- Admin Confirmation - This is when an admin flags a users as a risk
- Password Spray (Guessing) Attacks

**IMPORTANT**: Conditional Access is not used to enforce MFA or biometric sign-in. These will only be enforced if and only if their sign-in/user are risky.

**Risks**

- User Risk: Risk that the user account has been compromised
- Sign-in Risk: Likelihood this _session_ (sign-in) is compromised



## Identity Protection Roles

- Security Admin
- Security Operator
- Security Reader
- Global Reader - Can read all information in Identity Protection Tab
- Global Admin

Admins cannot reset passwords but can do everything else like manage policies or set alerts.

Operators can dismiss user risk and confirm sign-ins but cannot alter any policies. They are essentially a helpdesk person.

Readers can only view reports.

## Security Defaults

- These are defaults enabled in Entra ID. You are able to turn them all off. There are many defaults: see the MS Learn doc to see this.

Note: This does not need any liscense.

## Conditional Access

Conditional Access uses signals (See Below) to determine actions (block or grant acess, can be limited acess). For example, we can require users to have a limited experience from home and require MFA but not require MFA at the worksite.

**Signals**

1. User or Group Membership
2. Location Information
3. Device
4. Application
5. Real time Sign-in Risk Detection
6. User risk

There are many signals like IP, Device Type/OS, ... .

[^1]: Allows you to exclude users as well as enable enforcement of your created policy.
[^2]: Password reset is optional. You can simple allow access if needed.


# Key Vaults

Key Vaults will safe guard secrets. For example, KV can be used to encrypt PII and when see without permission it will be gibberish. 

With Key Vault, you need to allow users to use the keys from the key vault if you are the owner. As a developer you will use a URI to obtain your secrets. If you have permission you will be able to see the secret. 

**Roles**:
- Key Vault Crypto Officer : Full access to secrets (rwd)
- Key Vault Crypto Service Encryption User : Access to only read secrets (r)

## KV Benefits

- KV can hold most types of secrets
- KV can also generate keys meaning it can be used for encryption
- KV can be used to generate, manage and deploy public/private certs
- KV is internally protected by software OR hardware HSM
    - These HSMs are compliant to Govt's FIPS 140-2 standard
    - KV keys cannot exported
    - Supports custom keys/secrets
- Purge Protection: feature in Azure Key Vault that helps safeguard your cryptographic keys, secrets, and certificates from being permanently deleted. When Purge Protection is enabled, even if a key, secret, or certificate is deleted, it cannot be permanently removed (purged) from the Key Vault until a specified retention period has passed. 

> A keyvault CANNOT ever be moved due to how they are stored (HSM).  

## Backup Details

- Keys can only be restored to the same geography as the backup
- Keys must be restored to a Key Vault within the same subscription as the backup

## Using TDE/CMK Details

Here are the steps to allow a resource $R$ **via Entra ID** to access a key vault $K$ for CMK and TDE.

1. Assign a Microsoft Entra identity to $R$.
2. Grant $K$ permissions to $R$.[^1]
3. Add $K$ to $R$ and set the TDE protector.
4. Enable Transparent Data Encryption.


[^1]: this refers to setting up access policies on the key vault if needed, else we can use Azure RBAC.

# MFA

Azure MFA requires two or more elements for full authentication:
- Something you know
- Something you possess
- Something you are[^1]

You can use MFA via Premium Licenses and you can get MFA for O365.

## Azure MFA Features Highlight

- Lockout Configuration
    - You can configure number of failed attempts before Account Lockout
    - Lockout window
    - Time to Reset
- User Blocking
    - Block users from MFA => They cannot login as they do not have access to the MFA tooling
- Fruad Alert
    - Users can submit fraud alerts 
    - You can choose to block user on a triggered alert
- Setting Up MFA via Phone Caller

## Enablement

- You are able to Enable `per-user-mfa` from the Entra ID Portal


[^1]: This is like a biometric reading like a finger print.

# App Registration

App Registration is used when an application outsources authentication to Azure AD. The App Registration requires some details like

- Keys
- URLs for auth endpoints
- User Info

## App Registration Cases

- Web Application or API
- Native Applications
- Daemon

Here is how it works in simple flows:

![Azure Ad Flow](https://arjanvanbekkum.github.io/images/authenticationflow.png)

By default, all users can register an application. This ablity needs to be limited by an admin.

### Features

You are able to create an App Registration where you can allow users **outside** your tenant to sign in such as external consultants or personal accounts. 

There is a setup wizard that can assist you in terms of setting up your app. You can also allow your application to access Azure APIs like accessing a Key Vault for Secrets. There are delegated permissions and Application permissions. Delegated permissions are for users and are used when logged in while Application Permissions are for things like Deamons which just authenticate as the application when performing any actions.

# Network Security

## Network Security Groups

> Used to filter TO and FROM Azure resources with in a Azure VNet.

Each rule in a NSG has a priority. The Highest number rule is processed last.

## Network Watcher Resource

> Used to Monitor and help debug Network Related Issues.

When the first network related resource is deployed in a region, a `NetworkWatcherRG` resource group is generated in the same subscription. Inside this resource group there is a `Network Watcher` resource per region you have used.

### Features

#### Effective Network Rules

This tool helps you check which rules apply to which NSG. For example, it will display all rules which apply to a VM.

#### Topology

Visual Interactive map of your Networking resources

#### Connection Monitor

This Tool helps you monitor connection between two sources[^1] and it will generate alerts if the connection is ever broken based on your testing configuration. 


#### IP Flow Verify

This tool can be used to debug the NSG and figure out which NSGs are allowing/denying your traffic by sending traffic to it or from it.

## Application Security Groups (ASG)

ASGs allow you to enable security rules for a group of machines at the same time. The use case for this is for Groups of VMs which need different types of traffic. An ASG is mapped to a V-NIC card. 

Here is an example of a ASG:

```
Priority	          100
Source	              Internet
Source Ports	      *
Destination	          AsgWeb
Destination Ports	  80
Protocol	          TCP
Access                Allow
```

Now when a a VM[^2] is marked with `AsgWeb` in the network config, it will allow all `HTTP` traffic in.

ASGs can also be used as source/destinations meaning you can set up seamless communication between VMs.

ASGs can **NOT** be used in different VNets. Once an ASG is assigned to a resource in one VNet all subsequent 

## Azure Bastion

Bastion is a `PaaS` which provides connectivity to your VMs via the portal. It can connect to *any* VM in your `VNet` **without** the use of a public IP address. You may choose to authenticate via:

- Entra Id (*preview*)
- Password
- SSH Keys[^3]

Bastion employes SSL Certs on the portal to secure your information but uses a protocol of your choosing like `SSH` or `RDP` to actually connect to the machines.

Azure Bastion deploys objects in the `AzureBastionSubnet` Subnet. This name is required to use Azure Bastion on your VNet.

[^1]: Source has to be an Azure Compute Service (AKS, VM, App Service, ...)
[^2]: By default, Azure subnets do not block any traffic as no NSG is attached.
[^3]: Keys may be fetched from Key Vault


# Just In Time Access

THis blocks all remote access traffic[^1] (SSH, RDP, ...) unless it is needed at the time.

**Requirements**
- The Host Machine *does not** block the remote access protocol\
- Any Attached NSG Does not block the traffic


Once you enable JIT access on the VM a new network rule is created to allow the access. To request acess you must head to the portal to do it but, you then need to enter the requester IP. When access is enabled, a new rule is prepended which allows the remote access[^2].



Note: `JIT`-access is a part of the MDFC.


---

You are able to create youe own JIT rules where you specify:

- Protocol
- Allowed IPs or Blocks
- Access time length









[^1]: Blocks via inbound NSG Security Rule
[^2]: MSFT will use reserved NSG priority numbers to insert their rules for JIT.

# Azure Firewall

- fully managed 
- protections VNet Resources
- Stateful
- HA + Scalable

You can create create/enforce/log Network Connectivity Policies across Many Networks and Subscriptions. AZ Firewall uses a static Public IP for your VNet allowing resources from outside the firewall to know your firewall originated the traffic.[^1]

Firewall allows you to filter traffic including FQDNs.

There is a method for rule creation: [RuleObjectsAZFW](https://media.tutorialsdojo.com/azure-policy-rule-sets.png)

Within a firewall there are priority to the rules from 100 to 65000. Priority 100 is first evaluated. **However**, there priority is fully overridden by rule type. The ordering of Highest to least priority is:

1. DNET Rules
2. Network rules
3. Application Rules

## Using a Firewall

An Azure Firewall comes with both static **public** and **private** IP addresses. There needs to be a subnet called `AzureFirewallSubnet`. 

**Steps**
- A default route in the route table of the Vnet Needs to be created such that all internal traffic points to the Firewall. It should be `0.0.0.0/0 => Firewall Private IP`
- create application / create network rules on the firewall
    - Examples: Allowing DNS[^2] (networking) and then certain websites (application)
    - This is similar to NSGs

Note: A firewall and VNet must be in the same VNet to work. 
Note: An Azure Firewall can optionally have a ManagementSubnet called `AzureFirewallManagementSubnet`. This subnet is required when sku=basic but it is not require for higher level skus.


[^1]: Similar to NAT
[^2]: ensure that NIC cards have the DNS servers that were allowed else it will attempt the query un-allowed servers.

# DDos

The Aim of DDoS attacks is to prevent acess to systems.

> For DDoS Network Protection, under a tenant, a single DDoS protection plan can be used across multiple subscriptions
> _From Microsoft_

## Azure DDoS Protection Settings

There are two tiers

- Basic
  - This is enabled by default
- Standard[^1]
  - This can help protect against:
    - Volumetric Attacks
    - Protocol Attacks
    - Application Level Attacks

# Azure front Door

The Front Door is a

- global
- scaleble
- entry-point

used to create large web applications.

Here is a graphic:

![AFD](https://learn.microsoft.com/en-us/azure/frontdoor/media/overview/front-door-overview-expanded.png)

Within the context of security, FD provides automatic DDoS in addition to its CDN features. There is no security configuration here, it is all handled by microsoft.

**Tiers**

See [here](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-sku-comparison) for comprehensive report.

| DDos IP Protection     | DDos Network Protection |
| ---------------------- | ----------------------- |
| No Cost Protection     |                         |
| No WAF Discount        |                         |
| No DDoS Rapid Response |                         |

**Additional Features of Front Door**

- URL Based Routing
- SSL Termination
- Failure Over via Health Probes
- Costom Domain with SSL
- Traffic Analytics

---

[^1]: Gives specialized protection for Azure Network Resources

# Web Application Firewall

The WAF protects against common web vulnerabilities such as XSS or SQL injection. The WAF can work well with the Azure Front Door which can use the WAF to block traffic based on WAF rules.

The WAF is configured for use. When you create one you have to select a policy which will imply its use. For example you can select a policy which says "Front Door" if you plan to attach it to a front door.

By Default, the WAF will also provide you with rate-limiting features.

**Additional Settings**

- HTTP Packet Inspection
- WAF Rules (See section Below)

**WAF Rules**

WAF rules include

- Rule Types (Match vs Rate Limit)
- Rule Priority
- Conditions (_Some_ examples below)
  - Geo-Location
  - IP Address
  - Sizes
- Then (action)
  - this is where you take action if your rule matches.


# Disk Encryption

This uses the bitlocker feature of windows to provide the encryption feature. You can either use CMK or MSFT-provided keys.

## VM Extensions

VM extensions are small applications that provide post-deployment automations/configurations. For example it can be used to run a script on a VM after the provisioning process is complete.

# MDFC

- Unified Infra Sec Mgmt System. It can protect on-prem, non-azure, and azure resources.
- It employs agents to collect data via the Log Analytic Agents
- The events are collected and corrected in their Security Analytics Engine which then generates warnings and alerts.

## Secure Score

The secure score in Microsoft Defender for Cloud can help you to improve your cloud security posture. The secure score aggregates security findings into a single score so that you can assess, at a glance, your current security situation. The higher the score, the lower the identified risk level is.

$$
\text{score} = \frac{\text{Max Score}}{\text{Healthy} + \text{unhealthy}} \times \text{Healthy}
$$

## Alerts

> This section is shoirt since I know how alerting emails works due to a custom policy

To avoid alert fatigue, Defender for Cloud limits the volume of outgoing mails. For each subscription, Defender for Cloud sends:

- Approximately four emails per day for high-severity alerts
- Approximately two emails per day for medium-severity alerts
- Approximately one email per day for low-severity alerts

### Workflow Automations

Every security program includes multiple workflows for incident response. These processes might include notifying relevant stakeholders, launching a change management process, and applying specific remediation steps. 

You are able to set up workflow triggering on Alerts due to Native Defender Integration with Logic Apps.

## Deployment and Usage Details

- Portal shows dashboard with possible security holes
- There is also an Alert Map which breaks down alerts per location
- You can supress certain alerts
- Defender can also be used to enfore compliance standards via Policy Assignments

### Workbooks

> Powered by Azure Workbooks

This helps you generate Defender based Dashboards.

## Defender For Identity

This tool is for physical machines running Azure AD.

> Defender for Identity is fully integrated with Microsoft Defender XDR, and leverages signals from both on-premises Active Directory and cloud identities to help you better identify, detect, and investigate advanced threats directed at your organization.

## Custom Reccomendations

> Custom recommendations in Microsoft Defender for Cloud allow users to tailor security advice to their organization�s specific needs, including remediation steps, severity, and applicable standards. Creating these involves defining recommendation logic with KQL
>
> - tutorialsdojo



# SQL on Azure

Firewalls can be used to protect DB-based workloads by setting up access to the DB from only trusted IP origins. In additional to IP based Ruling, the firewall also contains VNet Rules which operate based on Service Endpoint. In this method, you allow traffic from a certain VNet.

There is a distinction between firewall rules for The Database vs the server level.

## Connectivity

> Refers to `Azure SQL Database` and not `Azure SQL Managed Instance`

### Machine on Azure

![Connectivity-Azure](https://learn.microsoft.com/en-us/azure/azure-sql/database/media/connectivity-architecture/connectivity-overview.svg?view=azuresql)

Since you are on azure you are able to directly bypass the SQL Gateways and talk to the node.

### Machine outside Azure

![Connectivity-nonAzure](https://learn.microsoft.com/en-us/azure/azure-sql/database/media/connectivity-architecture/connectivity-outside-azure.svg?view=azuresql)

This connection will _by default_ have a connection policy of `proxy` meaning all traffic MUST flow over the LB Gateways. This option is clearly worse performance.

## Auditing

`Auditing` is the process of writing trasaction logs to your

- Azure Storage Account
- LAW
- Eventhub

An _auditing policy_ can be defined to a single DB or the ensure server. If in the case there is an auditing policy for a SQL DB and one for the whole server, the logs are _double audited_.

## Misc Features

- DDM (Dynamic Data Masking) - hide data due to PPI reasons
- Encryption at Rest for Data & Logs
- Data Discovery & Classification
  - Helps to aid in protecting sensitive infomation (Credit Cards)
- SQL Ledger - immutable and verifiable record of all data changes using blockchain technology
- For TDE/CMK the strongest key algorithms are: RSA 2048 and RSA 3072


# App Service Security Notes[^1]

- Lock down deployment slot URLs. You can choose who gets access to these.
- You can view insights via `Application Insights` to find failures or bottlenecks along with user analytics.

# Container Services Security Notes[^1]

- Azure Containers
  - Check if your compliance documents require containers to run `isolated`. Container Services can provide this.[^2]
  - Alternate Solution are `container-groups`. Container Groups are containers which share the same resources (network, storage volumes, ...)[^3]
  - Billed by Seconds
- Azure k8s
  - MSFT manages the control plane while the customer just needs to worry about what is in the Nodes[^4] (`kubelet`, `kube-proxy`, Container Related details)

[^1]: The course includes information about the how the Service works and what it is. It is not included here as this is a security course.
[^2]: This is known as Hypervisor-level Security
[^3]: Nearly a K8s Pod
[^4]: Nodes are simply VMs on azure. 


# Sentinel

- Cloud Native SIEM[^1]
- Monitor Alerts, view incidents, view logs
- Its aim is to bring all LMAs into azure from various sources (Azure & External Tooling)
- Has AI integrations to get early detections
- View attacks **live**
- Fill Integration O365 and on-prem resources


To interact with Sentinel you need roles:
- `reader`
- `responder`
- `contributor`

Sentinel isnt like MDFC, you are still required to create a Sentinel resource. Sentinel works with external products via `connectors` which allows a connection between sentinel resources and the product. With this, integration is easy. The connector will list its prereqsits, for example for the `Azure AD Identity Protection` you are required to have a P2 license.

Once you connect a data source you are able to create **Sentinel Rules**.

## Sentinel Rules

A Sentinel Rule allows you to percive data from the connector and write logic to set up **Automated Responses**.

Logic can include
- Query Scheduling 
    - Scheduling is setting how often the data is collected and analyzed. You can choose the number of queries in which a violation is detected AND the timing of the queries. 
    - For example: A use of this is to prevent "slow hacking". An account may be compromised where someone attemps to guess passwords daily to avoid detection. We can simply schedule the query to have a larger time-window to generate failed login alerts based on number of password failures.

### Playbooks

> Playbooks are for users who need tooling but do not want to develop roles or the responses that go with the rules.

The Azure Sentinel Community will release playbooks for rules/connectors with common actions they want to do. One example is blocking a user from logging in after detection odd login signals on that account. It is too hard to learn the syntax so users can simple just use existing playbooks. This also applies to **Automated Responses**.

Sentinel can **also** perform the same service for other clouds like AWS.

### Notebooks

Jupyter notebooks are also integrated to provide ML-empowered CyberSecurity capablities.

### Entity Behavior

This tool builds a profile of behavior for each user to detect patterns and detect irregulaties.

### Threat Intelligence

List of new Threats and how they effect you and your resources

## Incident

Sentinel generates a timeline with links of detailed activity which can help you expose the root actor or issue in your environment.

[^1]: Security Information and Event Management

# Scure Storage

## Azure Files

- Authenticate with SAS (*needs `Microsoft.Storage/storageAccounts/listkeys/action` perm*)[^1]
- Entra ID

The above is the order of operations on the portal checking your access, you can change it to default to Entra.

[^1]: The action is a POST. So a `read-only` lock will prevent SAS Access.

## Azure Blobs

Same as files.

## Azure Tables & Queue

- Only Support for Entra ID which is used to obtain OAuth2.0 Token for access rights

## BYOK 

The point of BringYourOwnKey is to transfer an HSM Key from on-prem to a HSM-backed KV to off load key management properties. 

# Implementations

# Details *Misc*

- Entra Connect : Used to Sync Identities from on-prem to cloud
    - Provides:
        - Password Hash Sync
        - Pass Through Auth
        - Federation
        - Identity Sync
        - Health Monitoring (monitoring of your on-premises identity infrastructure)
            - requires health agent on each identity server on-prem
- Entra Cloud Sync - This is Entra Connect but with a easier install and more features
    - No more Pass Through Auth
    - No Support for Large Groups (Limit:50k)
    - No Device Support
- Entra Authentication 
    - SS Password Reset
    - Entra MFA : Enabled via Conditional Access
    - Passwordless Authentication
        - Methods
            - Device (Ex: Windows 10 Hello, Authenticator)
            - Security Key / Cert
            - Biometrics or PIN
            - Physical Key like a rotating RSA or FIDO2
- Entra Password Protection - detects and blocks known weak passwords and their variants, and can also block additional weak terms that are specific to your organization.
    - Can be deployed on-prem to DCs never have to connect to internet but use the same lists of banned passwords.
    - Supports *Partial Deployment*, as in it can be deployed on a Subset of DCs.
- Entra ID SSO - Sign on to multiple systems with one set of credentials
- Entra Verified ID - ??? over my head
    - Motivation: providing a secure and private way to manage identity data without relying on centralized authorities (from Microsoft.Learn)
- Microsoft Entra Application Proxy - used manage access to legacy on-premises applications that aren�t yet capable of using modern protocols. This tool can also be used to give remote access to internal resources without the need for a VPN or reverse proxy[^1]

## Authentication Options *On Prem*

- Password Hash Synchronization (A)
- Pass Through Authentication (B)
    - Agent on on-prem validates passwords
- Federated Authentication
    - Entra hands off authentication to a 3rd party like an on prem Active Directory Federation Services (AD FS) to validate the user's password. This can be used to implement custom controls.
    - You may enable Federation with Password Hash Sync to have disaster recovery and leak-pw reports (Identity Protection)



One senario is deploying both *A* + *B*, this allows the agents to go down without interrupting users ablity to sign-in. This fail over is NOT automatic, it must be triggered by a human.

## Manage Entra ID Applicaitons

- access can be granted via individual assignment or group assignments.
- you can limit access to applications by requireing explicit assignment
- App Registrations:
    - when an app is registered on Entra, an SPN is created. Access to Azure is then determined by this SPN's roles.
        - Note: SPNs can log in via Password or via a x509 Cert.
     

### Permission Scopes[^2]

To allow an application to request scopes you must create a scope in the portal. Here are the steps

1. Register the Application & API
2. Create an App Role + Assign App Owner
    - Example of App Role: `Employee Information Reader`. Now any application with this role will be able to access employee records. 

A request now will contain an access token which can be used to retrieve which scopes its asking for.

3. Now you create a Scope in the app registration

The way scopes work  is that if your web API's application ID URI is https://abc.com/apiv2 and the scope name is `Employees.Read.All`, the full scope is:

```
https://abc.com/apiv2/Employees.Read.All
```

This essentially shows you that App registrations can have different permissions (Delagated vs App permission).

### Securing External Identities

This is the job of Entra External ID:

- add authentication and access management to applications. Often times the approach is to add external users in a seperate tenant[^3] while keeping your employees in the main tenant. Then External ID can be used for collabration known as External ID b2b Collaboration
- 

[^1]: Server or cloud service that intercepts and forwards client requests to a web server
[^2]: Scopes are essentially permissions that the app requests from the user or admin.
[^3]: This allows you to have customized sign in experiences.

# Network

## VPn Connectivity

- A VPN Gateway is a subtype of VNet Gateway. Another example is ExpressRoute


### Express Route

- Connections to MSFT peering locations held by a 3rd party provider
- No Encryption by default
- Express Route direct implies direct connections to the MSFT routers via ports and can be protected by MACSec protocol 
- Another layer of protection is a S2S VPN over the express route

### S2S
- A S2S connection requires a VPN device located on-premises that has a public IP address assigned to it.



### P2S
- A point-to-site (P2S) VPN gateway connection lets you create a secure connection to your virtual network from an individual client computer


## Azure Firewall

- Can be applied at L4 or L7
- Can inspect TLS Packets via decryption
- Has DNat (Desination NAT) function.
- Has IDPS (Intrusion Detection Protection System)

The method of implementation is having a UDR which matches your traffic or `/0` and setting next hop to the firewall IP.

# Compute

## Disks

- CMK Encryption can be controlled by the KV (For managed Disks)
- OS disks are encrypted via Azure Methods like Windows bitlocker.

## Databases

> All Notes about SQL DB

- Auth: SQL Auth or Entra ID
- Encryption: 
    - TDE (MMC vs CMK)
    - SQL Always Encrypted (Data always encrypted on Azure only client can decrypt)
    - Dynamic Data Masking (not really Encryption, its more like hiding)
- Audit Feature for SQL is a transaction log
