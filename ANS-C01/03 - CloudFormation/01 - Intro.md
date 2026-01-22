# Cloud Formation

- YAML or JSON defined
- CloudFormation Files define Templates which define stacks
    - Note: Stacks are a complilation of Template, Parameters and options
- Stacks are the "how", they manage the lifecycle (Create,Update, or Delete) the resources

## Template Params

- Parameters are vars which influence behavior when deployed
    - Values can be filled in before deployment via CLI or AWS Console
- Can be configured with min/max/patterns/types/allowed-values,...

Example

```yaml
Paramaters:
    InstanceType:
        Type: String
        Default: t3.micro
        AllowValued:
            - t3.micro
            - t3.medium
            - t3.large
        Description: "Instance Size for Bastion EC2"
    InstanceAmiID:
        Type: String
        Description: "AMI ID for Bastion EC2"
```

### Pusedo Params

These params are able to be referenced but are not inputted by the user, they are filled in by AWS. One example is the `AWS::Region` puesdo parameter. This will refer to the region the template is being deployed to.

Other examples are `AWS::StackName` or `AWS::AccountId`.

## Intrinsic Functions

- Functions you can call at runtime

Examples

- Ref
    - used to get parameter value ex: `ImageId: !Ref InstanceAmiID`
- Fn::GetAtt
    - used on logical params to get outputs like ID or ARN
- Fn::GetAZs
    - used to get All AZs of region, Example `!GetAz ''` gets [...] where ... is all AZ of current Region. The '' implies the default region `AWS::Region`.
- Fn::Select
    - Selects the nth value. Example: `!Select [0, !GetAz '']`
- ...

## Mappings

- Maps keys to values allowing for internal look up
- you can allow nested maps two to 3 total layers (key -> key -> Value)

Example:

```yaml
Mappings:
    RegionMap:
        us-east-1:
            AMI: ami-0c55b159cbfafe1f0
            InstanceType: t3.micro
        us-west-2:
            AMI: ami-0d1cd67c26f5fca19
            InstanceType: t3.small
        eu-west-1:
            AMI: ami-0d71ea30463e0ff8d
            InstanceType: t3.micro
    EnvironmentConfig:
        dev:
            MinSize: 1
            MaxSize: 2
        prod:
            MinSize: 2
            MaxSize: 10
```

Getting information is via the `!FindInMap`:

```yaml
amiId: !FindInMap ["RegionMap", !Ref "AWS::Region", "AMI"]
```

## Outputs

- optional
- **Important**: Outputs can only be read on the console OR if the stack is nested, then a parent can read it. Otherwise it cannot be read.
    - If you want other stacks to be able to read outputs then outputs need to be _exported_. 
        - This exported output name has to be unique to a AWS account to a region. 
        - This export can only be imported within the same account & region

Example For Regular Output:

```yaml
Outputs:
    url:
        Description: "URL of Website" # this is shown in portal / CLI
        Value: !Join ["", ["http://", !GetAtt Instance.DNSName]]
```

Example for Exported Output:

```yaml
Outputs:
    url:
        Description: "URL of Website" # this is shown in portal / CLI
        Value: !Join ["", ["http://", !GetAtt Instance.DNSName]]
        Export:
            Name: <UniqueName...URL>
```

## Conditions

- optional section
- processed before resources are created/updated
- can use other functions freely
- evaluates to `True`/`False`

Example:

```yaml
Parameters:
    OperatingEnv:
        Default: "dev"
        AllowedValues:
            - "dev"
            - "tst"
            - "prd"
        Type: String

Conditions:
    IsProd: !Equals [!Ref OperatingEnv, "prd"]

Resources:
    WebServer:
        Type: AWS::EC2::Instance
        Properties: ...
        Condition: isProd                       # creation only IF isProd condition => True
```

## Depends On (Resources)

- CloudFormation manages dependecies and attempts to perform parallel resource creations

If a dependency isnt understood or you want to force it you can use the `dependsOn` attribute. 

```yaml
Resources:
    IgwToVpcAttachment:
        ...
    WebServerPublicIP:
        Type: AWS::EC2::EIP
        Properties: ...
        DependsOn: IgwToVpcAttachment
```

Note: For an EIP to be attached to a VPC, the VPC needs to have a provisioned IGW. You do not want this attachment to occur before the attachment is created. 