# PIM

> EntraID P2 feature.


There are many roles in Entra Id which you can assign to a user or group manually.[^2] Azure roles[^3] are far more flexible, you may assign azure roles to a more extensive set of groups (dynamic, ...) and a broader control of scope (MG, Subscription, RG, ...).

This aformentioned method of permanent role assignment poses a large security risk as exposed credentials will have these entitlements until removed. Since removal takes time, a threat actor may do real damage. Thus the solution is `JIT` (Jist in time) access. The base user may have basic perms but when elevated, they are able to select from a their eligible assignments after proving their identity[^4].

For Admins there are features like:
- Access Audits (Access Review)
- Elevation Approval & Delegations
- Notifications on PIM Events

A PIM assignment is either:
- `eligible` (user is able to request for role in this time period)
- `active` (permanent within a time period or forever)

## Feature Analysis

### Base Settings

With PIM you are able to get an overview of all Entra Roles and setup some settings. With these settings you are able to alter many items:

![PIM-portal](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/media/pim-resource-roles-configure-role-settings/resources-role-setting-details.png)

This is an example of altering the settings of an Entra ID.

Notice we have 2 time windows. One is shown in the image above and one is on the actual PIM assigment. So the key idea to understand is that you are able to 
- have an assignment that makes you eligible (_able to request_) to elevate up for some time. (ex: 6 Month)
- Once the request is approved you have access for the set time in the image above.

A user may activate a role they have assiged as stated [here](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-how-to-activate-role). See that they are able to _schudule_ a time for elevation and deactivate their roles early if they are no longer required.

You may look at your audit history [here](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-how-to-use-audit-log). This screen will change based on the user that is logged in as some events will be more private.


### Settings for Azure Resources

You also have the ability to apply PIM to **azure resources**. But first you have to _discover_ them and import the resources to PIM.

With this pane you have the option to allow PIM-ing to your azure roles (custom or built-in) and select the scope you require. Much like the above section you have the base settings. 

### Group Based Role Assignments w/PIM


This method is a lot more efficient than regular PIM assignments. Suppose you need 3 Entra Roles and 3 Azure Roles. It is not practical for an Admin to give you 6 PIM Eligible Assignments. It will be easier on the Admin to create a group with those roles assigned and **allow** you to elevate yourself to be a temporary member of the group.

Here is an API ive found that enables control over PIM using an [API Endpoint](https://learn.microsoft.com/en-us/graph/api/privilegedaccessgroup-post-eligibilityschedulerequests?view=graph-rest-1.0&tabs=http)

[^1]: Other tenants that trust tenant T.
[^2]: Group requires a boolean set to be the target of role assignments
[^3]: Roles that pertain to Azure Resources and not Entra ID. 
[^4]: MFA, Security Question, ...
