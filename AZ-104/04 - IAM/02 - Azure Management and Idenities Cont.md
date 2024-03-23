# Azure Management and Idenities Cont.

## Guest Users

The need for guests will arise for example if a company invites another company for some consulting work for example. This feature is available via the `Users` tab. 

## Bulk Creation / Delation

This is possinle via the `Bulk Operations` button on the users tab. Azure will give you a CSV file to fill out and use it to do the Bulk creation. 

## Conditional Access

> This requires understanding of MFA[^1] first.
> Requires Preimum License for this but not for MFA.

This allows you to trigger MFA on certain conditions (signals). 

### Conditional Access Polices

Policy Creation Steps

1. Policy Name
2. Selecting which Identites this policy applies too (User, Groups) via inclution or exclusion of identities.
3. Select Apps or Actions that require MFA when a user attempts to access or excute them. The Azure Portal[^2] is one of these "Apps".
4. Select Conditions to trigger MFA. Examples are:
    + User Risk
        + _Note_: Risk based login (User Risk, Sign-In Risk[^3]) is only possible on `Microsoft Entra ID P2`    
    + Device Platforms (ex: Android)
    + Locations
    + ...
5. Select Block or Grant as a policy result[^4]. 
    + `Block` will result in the user not getting ANY access based on the conditions above
    + `Grant` allows you to set up options to what occurs when the conditons above are met. You can trigger a MFA and subsequently require actions like a password change.






[^1]: Multi Factor Authenication
[^2]: Not Under this specific name
[^3]: From MSFT: "[Sign-in Risk] represents the probability that a given authentication request isn't authorized by the identity owner"
[^4]: This term "Policy Result" is not a general term I use it because it fits well.

