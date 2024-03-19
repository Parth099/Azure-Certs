# Azure Management and Idenities

For machines only `Win10 (not Home) and Windows 2019 DS` can join the Azure Entra ID.

## Subscriptions

> Used for billing and high-level management.

When creating Subscriptions you can select from different payment models like:

- PAYG (pay as you go)
- Azure Student (reduced cost for first 12 months)

## Microsoft Entra ID

Formerly known as Azure Active Directory (**AD**), it is an identity provider. Inside azure, it provides both auths via RBAC.

There are different versions with different limits and security features; bigger orgs may need to purchase a more _premium_ subscription[^1].

### Pricing

See Entra Id pricing at: [ms](https://www.microsoft.com/en-us/security/business/microsoft-entra-pricing)

Each Tier has a trial period which you are not charged for. For example P2 Free Trial gives you a 100 licenses which simple deactivate on free trial expiry; you are not charged if you do not delete the resource before your time is up.


### Entra ID and Subscriptions

> The trust between an AD Directory and a subscription is 1 to many. A subscription can trust at most ONE directory whereas a many subscriptions can trust the same AD directory.

### User Creation

You can create Users under your AAD Tenant and domain. After creation, you can sign in with the new user where you will have to create a new password. By default, these users cannot do or see anything until permissions ar given. 

### Group Creation

This is for when you want to pool identities and assign them the same roles/permissions without the overhead of managing each one directly. 

#### Dynamic Groups

> Requires P1 License

These type of groups feature rules that auto-add users into groups.

The rules are not too complex but are laid out here: [rules](https://learn.microsoft.com/en-us/entra/identity/users/groups-dynamic-membership#constructing-the-body-of-a-membership-rule)

You are **not** allowed to add members to the DG yourself.

There also exists dynamic device groups. These groups will filter and assign machines to the correct dynamic group.


### RBAC - Role based Access Control

> Notice: There is a delay between role assignment and permissions gained

There are many in-built roles for general purpose behavior like granting read access to VM Resources.

Access control can be applied at many layers. You can add rules at the resource level, resource group level or subscription level. Moreover you can also give users RBAC to the data-plane[^2]. This means that it is possible users can see a SA exists, but may not be able to see the data inside of it. This is why there are two different roles for SA Reading: the general reader (acknowledgement of SA) and the Data Reader role (acknowledgement of the data) where you **are** able to see the internal data of the SA.

There are many special roles included as in-built roles too. For example there exists a role you can give a user that allows them to log into a Windows Server VM. This type of role does not fall into the general RBAC setup.

**Example**:
Consider giving a user read access to a Azure Virtual Machine. You will NOT be able to view the Networking information of this VM since that access is under Networking. To solve this issue you can try assigning roles at a higher scope level such as at the research group level or subscription level.

There are many rules on how roles can be created and what scope that can be assigned to: [How to add Custom Role](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles).



### Azure AD Roles

> Can be assigned to groups or users

These are roles that deal with AD permissions like creating users or modifying roles. The regular RBAC roles we defined before are called "Azure Role Assignments."

Roles here can be of type "Eligible" or "Active":
+ Active will permanently assigns the role
+ Eligible will allow the user to take up the role between the time window

### Custom AD Domain

You first need to own a domain (ex: `www.cloud.com`)

After verification, you can use this domain instead of the default domain.

[^1]: Examples of more premium subscription: Premium P1 and Premium P2.
[^2]: Inside a role these data access fields are marked as 'dataActions' and 'notDataActions'

### Self-Service Password Reset

> Needs P1 higher License

This is when a user can reset their password without IT's help.

+ Changes are synced on a pw reset to the Azure AD
+ You can define auth methods to reset the password and how many of them are required
+ You can define a timeline for password resets
+ You can notify users when a password is reset
