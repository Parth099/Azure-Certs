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
 

