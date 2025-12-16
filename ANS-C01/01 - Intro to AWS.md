# Intro to AWS
- Items required for this course

## Personal Information
| AWS Account Name | Email Extensions | Account Usage |
| -----------------| -----------------| ---- |
| sandbox-dev      | +ansc01          | networking |

Sign in [here](https://ansc01dev.signin.aws.amazon.com/console) to my AWS Account as an IAM User.

## IAM Basics

- Account Root User - User which has FULL access WHICH CANNOT be restricted.
  - MFA Should be used here. 
- Identities start with ZERO access
  - It is also possible to permit *cross-account* access.
- IAM as a service is fully trusted by the AWS account, so it can do anything.
- Free Service
- Global Service
- Supports Federation & MFA

IAM objects are
- User
- Group
- Roles
  - Can be used by AWS Services OR by external services which want access to items in your account
- Policy
  - Documents which outline `Allow` or `Deny`
  - Policies are useless if they arent attached to an Identity (first 3 objects)
 

### Credentials

- IAM Access Keys
  - IAM User can have at most 2 Access keys which can be made to be active or not at anytime. Regeneration/Rotation is also possible

### AWS Organizations

Organizations helps manage larger organizations manage their large number of AWS Accounts. One account becomes the `management` account, it can invite other accounts to be in the organization OR create accounts directly within the org. There are OU (Organizational units), a container for grouping AWS accounts within an AWS Organization, creating a hierarchy to simplify centralized management. One benefit of AWS Organizations, is consolidated. 

See that this changes the way we think about IAM now, one AWS account[^1] can simply have all the users & roles and then issue roles to access aws accounts within the org. 


[^1]: Does not have to be the `management` account. Can be a seperate "login" account. 
