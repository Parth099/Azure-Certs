# Azure Management and Idenities Cont.

## Administrative Units 

![AU](https://cybermsi.com/wp-content/uploads/2021/05/image002.png)

This also helps by creating permission boundaries. For example a 'User Admin' Role inside an AU will ensure this admin does not have User altering access outside the AU. 

## Locks - Resourse Locks

> Preventive measure

There are two types of locks[^1]:

1. `CanNotDelete`
2. `ReadOnly`

> You cannot add a resource lock at a Management Group Level

**Important**: A `CanNotDelete` locked resource can still be moved[^2] if the locks are placed on the actual resource. This not true if the resource container[^3] is locked itself. This effectivily states that lock effects trickle down.

## Azure Policy Service[^4]

> For Governance

Enforce certain policies on your resources like location or tagging based on compliance standards. The policy can be specific like disallowing specific NACL rules.

Azure Policy needs to often _remediate_ non-compliant resources. For this it needs an _Identity_. You can choose between System Assigned or User Assigned, both with the level of permissions. 

Suppose there is a policy assigned at two different levels where each policy prescribes a different effect for the same resource. There are rules to determine which policy effect will be applied:
1. a `deny` overrides all other effects
2. ---

## Management Groups

A MG is used to logically segregate subscriptions. There is only one root however known as the `Tenant Root Group`. A MG can have child MGs but the limit is 6 layers deep excluding the `root`. Applying a policy to a MG (scope: MG) the policy will apply to all children (even nested).

Note: You cannot move subscriptions between MGs not can many MGs be the parent of a subscription.

[^1]: For any lock the user still must have access to the object to see it initially.
[^2]: Azure gives users the ability to move resources to another RG or Subscription.
[^3]: Resource Container: RG, Subscription, or MG.
[^4]: ACE :)
