# CloudFormation Stacks

## Nested Stacks

- A deployment may need many stacks, some reasons are:
    - 500 Resource / Stack Limits
    - Code Reuse (forced to write modules of sub-stacks)
    - All resources are linked to same lifecycle[^1]

- Nested Stacks have a root/parent stack and then stacks underneath. Even those may be nested.
- The status of the root stack depends on the status of the child stacks

Example:

```yaml
Resourcs:
	VPCStack:
		Type: AWS::CloudFormation::Stack
		Properties:
			TemplateURL: ...
			Parameters: ...
		# You may even have a stack depend on another stack

Outputs:
	VPCId:
		Value: VPCStack.id
		Description: "ID of the VPC created"
```

## Cross Stack References

> Exported Outputs can be read from other stacks.

- Cross Stack References can be used when
    - Resources are NOT sharing same lifecycle, otherwise they should be part of the same _deployment_.

Example:

```yaml
Resources:
	SecurityGroup:
		Type: AWS::EC2::SecurityGroup
		Properties:
			GroupDescription: "Security group using imported VPC"
			VpcId: !ImportValue shared-vpc-id
```

[^1]: same as single stack
