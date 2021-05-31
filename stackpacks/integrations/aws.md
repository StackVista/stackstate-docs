---
description: StackState core integration
---

# AWS V2

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of AWS services.

![Data flow](../../.gitbook/assets/stackpack-aws-v2.svg)

TODO: Describe data flow diagram

## Setup

### Prerequisites

To set up the StackState AWS V2 integration, you need to have:

- [StackState Agent V2](agent.md) installed on a single machine which can connect to AWS and StackState.
- An AWS account for the agent. The AWS Account ID is needed in the next step, when deploying resources to the target AWS accounts. It is recommended to use a separate shared account outside of the accounts that will be monitored by StackState, but this is not required.
  - If the agent is running within an AWS environment, The EC2 instance, EKS or ECS task must have an IAM role attached to it.
  - If the agent is running outside an AWS account, an IAM user must be made available.
- The IAM user/role must have following IAM policy. This policy grants the IAM principal permission to assume the role created in each target AWS account.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::*:role/StackStateAwsIntegrationRole"
    }
  ]
}
```

### Moving from V1 (Legacy) to V2

As V2 has been rebuilt from the ground up, it is not possible to migrate an existing installation automatically to V2. To move, the V1 (Legacy) stackpack must be removed, and the V2 stackpack installed. It is possible to run both stackpacks side by side during the migration process, however this configuration is not supported and will likely not work in the next major StackState release.

To remove an existing V1 (Legacy) installation, view the removal instructions for

### Deploy AWS Cloudformation stack

The StackState AWS Cloudformation stack is deployed in your AWS account, providing the minimum level of access necessary to collect topology, telemetry and logs. There are three methods of deployment:

- [**Quick deploy**](#quick-deploy) - Quickly deploy all resources to a region in an account with a link.
- [**Manual deploy**](#manual-deploy) - Download a CloudFormation template to integrate into your own deployment workflow.
- [**Manual installation**](#manual-installation) - Deploy all resources manually to gain full control over StackState's access.

The automated install uses a CloudFormation template to deploy all necessary resources in a single region, in one account.

The CloudFormation template requires 3 parameters:

- **Main Region:** Choose your primary AWS region. This can be any region, as long as this region is the same for every template deployed within the AWS account. Global resources will be deployed in this region such as the IAM role and S3 bucket. Example: `us-east-1`
- **Agent Account ID:** The AWS account that the StackState Agent is deployed in, or has an IAM user in. This will be the account that the IAM role can be assumed from, the perform actions on the target AWS account. Example: `0123456789012`
- **External ID:** A shared secret that the StackState agent will present when assuming a role. Use the same value across all AWS accounts that the agent is monitoring. Example: `uniquesecret!1`

#### Quick deploy

Click the links in the table below to quickly deploy a template. You must be already logged in to the target AWS account in the web console.

| Region Name   | Template link                                                                                                                                                                                                                                                                                                           |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ireland       | [eu-west-1](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources)                |
| Frankfurt     | [eu-central-1](https://eu-central-1.console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources)       |
| N. Virginia   | [us-east-1](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources)                |
| Ohio          | [us-east-2](https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources)                |
| N. California | [us-west-1](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources)                |
| Hong Kong     | [ap-east-1](https://ap-east-1.console.aws.amazon.com/cloudformation/home?region=ap-east-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources)                |
| Singapore     | [ap-southeast-1](https://ap-southeast-1.console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| Sydney        | [ap-southeast-2](https://ap-southeast-2.console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |

This list specifies popular AWS regions. For any regions not listed, follow the manual CloudFormation deploy steps below.

#### Manual deploy

For more control over the deployment, download the CloudFormation template below:

https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml

This template can be deployed to multiple AWS accounts and regions at once by deploying it in a CloudFormation Stackset. For more information on how to deploy, check the documentation here.

#### Manual installation

The default CloudFormation template gives read-only least-privilege access to only the resources that StackState requires to function. It is recommended that this template is used as it provides an easy upgrade path for future versions, and reduces the maintenance burden.

The IAM role created by StackState is not able to bypass IAM permissions boundaries or Service Control Policies. These can be used as a way to restrict access while retaining the original CloudFormation template and policy.

If these options do not provide enough flexibility, see section [Required AWS resources](#required-aws-resources) for full information on the resources that StackState requires. If the agent does not have permission to access a certain component, it will skip it.

### Install

Install the AWS V2 StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You following parameters provided will be used by StackState to query live telemetry from the AWS account; the AWS Agent V2 must be configured to create topology.

#### Role ARN

Enter the ARN of the IAM Role that was created as part of [Deploy AWS Cloudformation stack](#deploy-aws-cloudformation-stack), example: `arn:aws:iam::<account id>:role/StackStateAwsIntegrationRole`. Replace the `<account id>` with the 12-digit AWS account ID.

#### External ID

A shared secret that StackState will present when assuming a role. Use the same value across all AWS accounts. Example: `uniquesecret!1`

#### AWS Access Key ID (Optional)

The Access Key ID of the IAM user created in [Prerequisites](#prerequisites). If the StackState instance is running within AWS, this can be left empty and the instance will authenticate using the attached IAM role.

#### AWS Secret Access Key (Optional)

The Secret Access Key of the IAM user created in [Prerequisites](#prerequisites). If the StackState instance is running within AWS, this can be left empty and the instance will authenticate using the attached IAM role.

### Configure

TODO: Details of how to configure Agent V2

## Integration details

### Data retrieved

#### Events

The AWS integration does not retrieve any Events data.

#### Metrics

Metrics data is pulled at a configured interval directly from AWS by the StackState CloudWatch plugin. Retrieved metrics are mapped onto the associated topology component.

TODO: are all metrics mapped to components/relations? Also possible to find in a data source?

#### Topology

The following AWS service data is available in StackState as components:

| Service        | Resource                  | Relations                                                                                                      |
| -------------- | ------------------------- | -------------------------------------------------------------------------------------------------------------- |
| API Gateway    | Method                    | SQS Queue, Lambda Function                                                                                     |
| API Gateway    | Method - HTTP Integration |                                                                                                                |
| API Gateway    | Resource                  | API Gateway Method                                                                                             |
| API Gateway    | Rest API                  | API Gateway Stage                                                                                              |
| API Gateway    | Stage                     | API Gateway Resource                                                                                           |
| Auto Scaling   | Group                     | EC2 Instance, Classic Load Balancer, Auto Scaling Target Group                                                 |
| CloudFormation | Stack                     | All Supported Resources\*, Nested CloudFormation Stack                                                         |
| DynamoDB       | Stream                    |                                                                                                                |
| DynamoDB       | Table                     | DynamoDB Stream                                                                                                |
| EC2            | Instance                  | EC2 Security Group                                                                                             |
| EC2            | Security Group            | EC2 Instance                                                                                                   |
| EC2            | Subnet                    | EC2 Instance, EC2 VPC                                                                                          |
| EC2            | VPC                       | EC2 Security Group, EC2 Subnet                                                                                 |
| EC2            | VPN Gateway               | EC2 VPC                                                                                                        |
| ECS            | Cluster                   | EC2 Instance, ECS Service, ECS Task, Route53 Hosted Zone                                                       |
| ECS            | Service                   | Load Balancing Target Group, ECS Task                                                                          |
| ECS            | Task                      |                                                                                                                |
| Kinesis        | Data Stream               | Kinesis Firehose Delivery Stream                                                                               |
| Kinesis        | Firehose Delivery Stream  | S3 Bucket                                                                                                      |
| Lambda         | Alias                     |                                                                                                                |
| Lambda         | Function                  | All Supported Resources\* (Input), EC2 VPC, Lambda Alias                                                       |
| Load Balancing | Application Load Balancer | EC2 VPC, Load Balancing Target Group, Load Balancing Target Group Instance                                     |
| Load Balancing | Classic Load Balancer     | EC2 Instance, EC2 VPC                                                                                          |
| Load Balancing | Network Load Balancer     | EC2 VPC, Load Balancing Target Group, Load Balancing Target Group Instance                                     |
| Load Balancing | Target Group              | EC2 VPC                                                                                                        |
| Load Balancing | Target Group Instance     | EC2 Instance                                                                                                   |
| RDS            | Cluster                   | RDS Instance                                                                                                   |
| RDS            | Instance                  | EC2 VPC, EC2 Security Group                                                                                    |
| Redshift       | Cluster                   | EC2 VPC                                                                                                        |
| Route53        | Domain                    |                                                                                                                |
| Route53        | Hosted Zone               |                                                                                                                |
| S3             | Bucket                    | Lambda Function                                                                                                |
| SNS            | Topic                     | All Supported Resources\*                                                                                      |
| SQS            | Queue                     |                                                                                                                |
| Step Functions | Activity                  |                                                                                                                |
| Step Functions | State                     | Step Functions (All), Lambda Function, DynamoDB Table, SQS Queue, SNS Topic, ECS Cluster, Api Gateway Rest API |
| Step Functions | State Machine             | Step Functions (All),                                                                                          |

\* "All Supported Resources" means that relations will be made to any other resource on this list, should the resource type support it.

#### Traces

The AWS integration does not retrieve any Traces data.

### Required AWS resources

![Account components](../../.gitbook/assets/stackpack-aws-v2-account-components.svg)

TODO detail every required resource

### Costs

TODO: Similar info to below

The AWS lightweight agent uses Amazon resources \(Lambda and Kinesis\) for which Amazon will charge a minimal fee. Amazon also charges a fee for the use of CloudWatch metrics. Metrics are only retrieved when viewed or when a check is configured on a CloudWatch metric.

### AWS views in StackState

When the AWS integration is enabled, three [views](../../use/views.md) will be created in StackState for each instance of the StackPack.

- **AWS - \[instance_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [action](../../configure/topology/component_actions.md) available in the component context menu and component details pane on the right side of the screen. This provides a deep link through to the relevant AWS console at the correct point.

For example, in the StackState Topology Perspective:

- Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
- Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

### Tags and labels

The AWS StackPack converts tags in AWS to labels in StackState. In addition, the following special tags are supported:

| Tag                      | Description                                                           |
| :----------------------- | :-------------------------------------------------------------------- |
| `stackstate-identifier`  | Adds the specified value as an identifier to the StackState component |
| `stackstate-environment` | Places the StackState component in the environment specified          |

## Troubleshooting

TODO: Create a similar troubleshooting guide for AWS V2

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall

To uninstall the StackState AWS StackPack, click the _Uninstall_ button from the StackState UI **StackPacks** &gt; **Integrations** &gt; **AWS** screen. This will remove all AWS specific configuration in StackState.

Once the AWS StackPack has been uninstalled, you will need to delete the StackState AWS Cloudformation stack from the AWS account being monitored. Follow these steps:

### Web console

1. Go to the CloudFormation service - ensure you are in the same region as the desired deployed CloudFormation template.
2. Select the CloudFormation template. This will be named `stackstate-resources` if created via the quick deploy method, otherwise the name was user-defined.
3. In the top right of the console, select "Delete".

If the template is in the main region, the S3 bucket used by StackState is not automatically cleaned up as CloudFormation is not able to delete a bucket with objects in it. Follow these steps:

1. Go to the S3 service
2. Select (don't open) the bucket named `stackstate-logs-${AccountId}` where `AccountId` is the 12-digit identifer of your AWS account.
3. Select "Empty", and follow the steps to delete all objects in the bucket.
4. Select "Delete", enter the bucket name and continue.

### Command line

These steps assume you already have the AWS CLI installed and configured with access to the target account. If not, follow the AWS documentation here.

1. Delete the CloudFormation template: `aws cloudformation delete-stack --stack-name stackstate-resources --region <region>`.

If `--region` is the main region, follow these steps to delete the S3 bucket:

1. Empty the S3 bucket. This is a versioned S3 bucket, so each object version must be deleted individually. If there are more than 1000 items in the bucket this command will fail; it's likely more convenient to perform this in the web console.

```bash
aws s3api delete-objects --bucket stackstate-logs-$(aws sts get-caller-identity --query Account --output text) \
    --delete "$(aws s3api list-object-versions \
    --bucket stackstate-logs-$(aws sts get-caller-identity --query Account --output text) \
    --output json \
    --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"
```

2. Delete the S3 bucket: `aws s3api delete-bucket --bucket stackstate-logs-$(aws sts get-caller-identity --query Account --output text)`

If you wish to use a specific AWS profile or an IAM role during uninstallation, add these switches to the commands:

`--profile <profile name`
`--session-name`
`--external-id`

## Release notes

### 1.0.0 (2021-??-??)

#### Improvements

- Full rewrite of the AWS Stackpack to use the StackState Agent V2
- Improved AWS multi-account support using IAM roles for account access
- Improved AWS multi-region support - each instance can create topology for multiple regions at once
- New, refreshed icon set, using the latest AWS branding

## See also
