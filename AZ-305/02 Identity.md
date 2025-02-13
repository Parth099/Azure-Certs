# Identity Management

## Role Based Access Control (RBAC) - Basics

-   In this Identity model, a user is assigned one or roles. A role has a given permission to perform an action at a given scope.
    -   This is unlike a Claims-Based Access control which uses an item like a password or certificate to get access.
    -   The permise here is to manage the roles and not the individual users.
-   A Tenant represents an Organization (a.k.a Azure AD Tenant)
    -   The top level role within a tenant is the `Global Administrator`
    -   There are 90+ Roles
-   The same user can have different roles within multiple tenants
-   A resource can also have a set of permissions associated with a role. This is known as `Resource Roles`.
    -   Example: `Storage Blob Data Contributor`

## Azure Identity Management

Microsoft Entra ID (formerly Azure AD) is the identity solution for cloud-based applications. There can be senarios where Entra ID [Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) will be required.

Here are sample app auth flows via [[OAuth2](https://learn.microsoft.com/en-us/entra/architecture/auth-oauth2)](https://media.tutorialsdojo.com/Azure-AD-OAuth-2.png).

Entra ID supports:

1. Users
2. Security Groups (Recall Dynamic vs Assigned)
3. Roles
4. Application Registration
5. Device Registration
6. Licensing
7. MFA via _Conditional Access_ which allows you to define access controls based on specific conditions.
8. SSO via _Enterprise Applications_ which allow you to integrate your on-premises financial application with Microsoft Entra for SAML-based SSO.

Some Entra ID Features:

-   With Entra ID [B2B](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b) you can invite users to your orgainzation and register in your domain. Essentially, you send an email to the user you want to invite and they can join the domain via the sent link.
-   There is also [B2C](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview#azure-ad-b2c) which allows you to work with identities generated via social media[^1].
-   With Entra ID [Connect] you are able to sync on your on-prem identities with on-cloud identities.
    - This does a lot more then Azure AD Directory Connect (on-prem service)
-   Entra ID has advanced features:
    1. Domain Joins - when a computer joins a domain and gains access based on its permissions
    2. Group Policy
    3. LDAP
    4. Kerboros Authentication
-   [Federation](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/whatis-fed) is the concept where domains trust each other with _varying_ levels of trust.

### Authentication

> Proving who you have

Preface:

1. on-prem AAD[^2] may use different protocols such as LDAP for authentication while Entra ID on-cloud can use internet-based authentication such a `HTTP`.
2. You are able to create more tenants[^3] and switch between them. ("Switch Directory")

There are many methods to proving who you are

-   Password
-   MFA
-   Security Questions
-   Signals (Source IP, Location, ...)
-   ...

#### Authentication Management

You can allow Entra ID to manage this authentication via:

-   password policies
-   Entra ID Sync
    -   SSO can enable sync-ed IDs so corperate users can use existing credentials in the cloud
    - Allows management in one place (ex: updating user passwords or revoking permissions)
-   MFA
-   RBAC
-   External Identities like Social Media
-   External partner access (think B2C)
    -   You may use this if you want people to access items inside your domain yet do not want them to be a part of your domain

**Helpful Services**
1. **Microsoft Entra Enterprise Applications** allows you to integrate external applications, including on-premises applications, with Microsoft Entra. By configuring the application as an Enterprise Application, you can enable single sign-on (SSO) for remote users without the need for VPN access.
2. **Microsoft Entra entitlement management** leverages Microsoft Entra business-to-business (B2B) functionality to facilitate access sharing and collaboration with external individuals who are not part of your organization.
3. **Azure Identity Governance** is a service that helps orgs to manage and govern user access to resources. It provides a set of features that allow the creation of access policies and reviews.
	+ "Access reviews allow you to automate the process of reviewing and removing access to resources. You can create a review that targets all users who have access to the specific app, and then set the review to run monthly. The Administrator will be notified of the review, and they can then attest to whether each user still needs access to the app. If a user no longer needs access, the review will automatically remove them as a guest."

#### Authentication Security

1. IPSec - Usually for VPNs at the IP Layer and uses Auth Header Signing to prove identity.
2. S2S VPN - No traffic sees the internet
3. MFA
4. **App Registration** is a feature that allows you to configure Microsoft Entra authentication
5. **Microsoft Entra Application Proxy**
	+ This provides a secure remote access to WebApps after a SSO to Entra ID. Users can access both cloud applications and on-prem applications.
6. **Microsoft Entra pass-through authentication** this focuses on authenticating and validating against a on-prem active directory.
7. ***Microsoft Entra entitlement management**: functionality to facilitate access sharing and collaboration with external individuals who are not part of your organization. With this feature, users can authenticate via their home AD but still have a presense in your AD, allowing you to assign permissions.

#### Password Resets

This Entra ID feature allows users to reset based on reset policies.It does require a [P1 or P2 license](https://www.microsoft.com/en-us/security/business/microsoft-entra-pricing). The user does require additional authentication methods to prove their identity like `security-questions` or `mobile-phone` access. This feature can be sync-ed to on-prem directories. 

### Authorization

> What actions you are able to commit

There are different types of authorization in terms of the cloud:

1. What you as the **user** are allowed to do
2. What the resource is allowed to do

The two based Authoization granting methods are:
1. Role based
2. Claim based

A very useful authorization feature is conditional access, this feature gives a user a different experience based on signals. For example if your empployee is working from a remote location they may get a different experience than someone who works in-office. You can also alter experience based on sign-in risk.

Another method of protecting secrets is via Azure Key Vault and granting access to secrets via Entra ID roles.

#### Groups

You can use groups to assign a set of permissions (role_s_) to many people at once. Groups can be dynamic or user-assigned. Under dyanmic groups (requires P2), users cannot be added/removed manually but are managed internally. Management depends on a user property. For example if a user is part of the Tax department, a group can be created to hold all Tax employees.

#### JIT Access

This is a paid feature from the Azure Defender & Azure Security Center. Recall that many VMs will have open RDP and SSH ports inbound. This feature will lock down those ports until a connection is required. You can obtain RBAC access for a limited time after which the ports are closed down, existing connections are **not** terminated. 

[^1]: Think "Login With Facebook" but can also be applied to other identity forms such as Goverment IDPs.
[^2]: Azure Active Directory.
[^3]: This can be refered to a "Directory".
