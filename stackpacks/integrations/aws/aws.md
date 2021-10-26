---
description: StackState core integration
---

# AWS

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of AWS services. 

![Data flow](../../../.gitbook/assets/stackpack-aws-v2.svg)

* StackState Agent V2 collects all service responses from the target AWS account.
* Topology is updated in real time:
  * Once an hour, all services are queried to gain a full point-in-time snapshot of resources.
  * Once a minute, Cloudtrail and Eventbridge events are read to find changes to resources.
* Logs are retrieved once a minute from Cloudwatch and a central S3 bucket. These are mapped to associated components in StackState.
* Metrics are retrieved on-demand by the StackState CloudWatch plugin. These are mapped to associated components in StackState.
* [VPC FlowLogs](#configure-vpc-flowlogs) are retrieved once a minute from the configured S3 bucket. Private network traffic inside VPCs is analysed to create relations between EC2 and RDS database components in StackState.

## Setup

### Prerequisites

To set up the StackState AWS integration, you need to have:

* [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) installed on a machine which can connect to both AWS and StackState.
* An AWS account for the StackState Agent to use when deploying resources to the target AWS accounts. It is recommended to use a separate shared account for this and not use any of the accounts that will be monitored by StackState, but this is not required.
  * If StackState Agent is running within an AWS environment: The EC2 instance must have an IAM role attached to it.
  * If StackState Agent is running outside an AWS account: An IAM user must be made available.
* The IAM user/role must have the following IAM policy. This policy grants the IAM principal permission to assume the role created in each target AWS account.

{% tabs %}
{% tab title="IAM policy" %}
```javascript
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
{% endtab %}
{% endtabs %}

### Deploy the AWS CloudFormation stack

The StackState AWS Cloudformation stack is deployed in your AWS account. It provides the minimum level of access required for the StackState Agent to collect topology, telemetry and logs. Quick deployment links and a default StackState CloudFormation template are provided below.

* [Quick deployment](aws.md#quick-deployment) - Deploy all resources to a region in an account using a link.
* [StackState CloudFormation template](aws.md#stackstate-template-deployment) - Download the StackState CloudFormation template to integrate into your own deployment workflow.

{% hint style="info" %}
For special environments where the CloudFormation template may not function correctly, advanced AWS users can refer to the [required AWS resources](aws.md#required-aws-resources) for a reference on all resources that must be manually created..

**It is recommended to use the** [**StackState CloudFormation template**](aws.md#stackstate-template-deployment) **wherever possible** as this provides an easy upgrade path for future versions and reduces the maintenance burden.
{% endhint %}

#### Quick deployment

The necessary resources can be deployed for one account in a single region using an automated CloudFormation template.

The table below includes links to deploy the template in popular AWS regions. For any regions not listed, follow the steps described for the [StackState template deployment](aws.md#stackstate-template-deployment).

{% hint style="info" %}
You must be logged in to the target AWS account in the web console.
{% endhint %}

| Region Name | Template deployment link |
| :--- | :--- |
| Ireland | [eu-west-1 \(console.aws.amazon.com\)](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| Frankfurt | [eu-central-1 \(console.aws.amazon.com\)](https://eu-central-1.console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| N. Virginia | [us-east-1 \(console.aws.amazon.com\)](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| Ohio | [us-east-2 \(console.aws.amazon.com\)](https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| N. California | [us-west-1 \(console.aws.amazon.com\)](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| Hong Kong | [ap-east-1 \(console.aws.amazon.com\)](https://ap-east-1.console.aws.amazon.com/cloudformation/home?region=ap-east-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| Singapore | [ap-southeast-1 \(console.aws.amazon.com\)](https://ap-southeast-1.console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |
| Sydney | [ap-southeast-2 \(console.aws.amazon.com\)](https://ap-southeast-2.console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/review?templateURL=https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml&stackName=stackstate-resources) |

#### StackState template deployment

The default StackState CloudFormation template can be used to deploy all necessary resources. It can be deployed to multiple AWS accounts and regions at once by deploying it in a CloudFormation StackSet. It is recommended to use this template as it provides an easy upgrade path for future versions and reduces the maintenance burden compared to creating a custom template.

* [Download the default StackState CloudFormation template \(stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com\)](https://stackstate-integrations-resources-eu-west-1.s3.eu-west-1.amazonaws.com/aws-topology/cloudformation/stackstate-resources-1.0.cfn.yaml)

The template requires the following parameters:

* **MainRegion** - The primary AWS region. This can be any region, as long as this region is the same for every template deployed within the AWS account. Global resources will be deployed in this region such as the IAM role and S3 bucket. Example: `us-east-1`.
* **StsAccountId** - The 12-digit AWS account ID that the StackState Agent is deployed in, or has an IAM user for the Agent in. This will be the AWS account that the IAM role can be assumed from, to perform actions on the target AWS account. Example: `0123456789012`.
* **ExternalId** - A shared secret that the StackState Agent will present when assuming a role. Use the same value across all AWS accounts that the Agent is monitoring. Example: `uniquesecret!1`.

For more information on how to use StackSets, check the AWS documentation on [working with AWS CloudFormation StackSets \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html).

### Install the AWS StackPack

Install the AWS StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters, these will be used by StackState to query live telemetry from the AWS account. To create topology in StackState, you must [configure the AWS check](#configure-the-aws-check) on StackState Agent V2.

* **Role ARN** - the ARN of the IAM Role used to [deploy the AWS Cloudformation stack](aws.md#deploy-the-aws-cloudformation-stack). For example, `arn:aws:iam::<account id>:role/StackStateAwsIntegrationRole` where `<account id>` is the 12-digit AWS account ID.
* **External ID** - a shared secret that StackState will present when assuming a role. Use the same value across all AWS accounts. For example, `uniquesecret!1`
* **AWS Access Key ID** - The Access Key ID of the IAM user used by the StackState Agent. If the StackState instance is running within AWS, enter the value `use-role` and the instance will authenticate using the attached IAM role.
* **AWS Secret Access Key** - The Secret Access Key of the IAM user used by the StackState Agent. If the StackState instance is running within AWS, enter the value `use-role` and the instance will authenticate using the attached IAM role.

### Configure the AWS check

To enable the AWS check and begin collecting data from AWS, add the following configuration to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/aws_topology.d/conf.yaml` to include details of your AWS instances:

   ```yaml
   # values in init_config are used globally; these credentials will be used for all AWS accounts
   init_config:
     aws_access_key_id: '' # The AWS Access Key ID. Leave empty quotes if the Agent is running on an EC2 instance or ECS/EKS cluster with an IAM role
     aws_secret_access_key: '' # The AWS Secret Access Key. Leave empty quotes if the Agent is running on an EC2 instance or ECS/EKS cluster with an IAM role
     external_id: uniquesecret!1 # Set the same external ID when creating the CloudFormation stack in every account and region
     # full_run_interval: 3600 # Time in seconds between a full AWS topology scan. Intermediate runs only fetch events. Is not required.

   instances:
     - role_arn: arn:aws:iam::123456789012:role/StackStateAwsIntegrationRole # Substitute 123456789012 with the target AWS account ID to read
       regions: # The Agent will only attempt to find resources in regions specified below
         - global # global is a special "region" for global resources such as Route53
         - eu-west-1
       min_collection_interval: 60 # The amount of time in seconds between each scan. Decreasing this value will not appreciably increase topology update speed.
       # apis_to_run: # Optionally whitelist specific AWS services. It is not recommended to set this; instead rely on IAM permissions.
       #   - ec2
       # log_bucket_name: '' # The S3 bucket that the agent should read events from. This value should only be set in custom implementations.
       # tags:
       #   - foo:bar
   ```

2. [Restart the StackState Agent](../../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to apply the configuration changes.
3. Once the Agent has restarted, wait for data to be collected from AWS and sent to StackState.

### Configure VPC FlowLogs

VPC FlowLogs can be analysed to retrieve relations between EC2 instances and RDS database instances. For each VPC that you want to analyse, a FlowLog needs to be configured. The process of adding FlowLogs for new VPCs could be automated using a Lambda triggered by a CloudTrail event that creates the FlowLog. Relations will be retrieved for EC2 instances and RDS database instances with a static public or private IP address and emit the proper URNs. For public IP addresses `urn:host:/{ip-address}`, for private IP addresses the URN has the form `urn:vpcip:{vpc-id}/{ip-address}`.

For further details, see [Required AWS resources - VPC FlowLogs](#vpc-flowlogs).

To configure a VPC FlowLog from the AWS console:

1. From the **VPC Dashboard**, choose **Your VPCs** under **VIRTUAL PRIVATE CLOUD**.
2. Select the VPC that you want to configure.
3. Select **Flow logs** on the lower TAB-bar.
4. Click **Create flow log**.
5. Add the settings as shown in the screenshot.

![VPC FlowLog settings](/.gitbook/assets/vpc_flowlogs_config.png)

### Use an HTTP proxy

StackState Agent V2 must have access to the internet to call AWS APIs. If the Agent cannot be given direct internet access, an HTTP proxy can be used to proxy the API calls. [The AWS documentation \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-proxy.html) outlines the variables that can be set to do this. If a proxy is required, these can be set as environment variables for the Agent.

### Status

To check the status of the AWS integration, run the status subcommand and look for aws\_topology under `Running Checks`:

```bash
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events

The AWS StackPack supports the following event:

* EC2 Instance Run State: when the instance is started, stopped, or terminated. This will appear as the Run State in the EC2 instance component.

AWS events are primarily used to provide real-time updates to topology. These events are not displayed as StackState events.

#### Metrics

Metrics data is pulled at a configured interval directly from AWS by the StackState CloudWatch plugin. Retrieved metrics are mapped onto the associated topology component.

#### Topology

The following AWS service data is available in StackState as components:

| Service | Resource | Relations |
| :--- | :--- | :--- |
| API Gateway | Method | SQS Queue, Lambda Function |
| API Gateway | Method - HTTP Integration |  |
| API Gateway | Resource | API Gateway Method |
| API Gateway | Rest API | API Gateway Stage |
| API Gateway | Stage | API Gateway Resource |
| Auto Scaling | Group | EC2 Instance, Classic Load Balancer, Auto Scaling Target Group |
| CloudFormation | Stack | All Supported Resources\*, Nested CloudFormation Stack |
| DynamoDB | Stream |  |
| DynamoDB | Table | DynamoDB Stream |
| EC2 | Instance | EC2 Security Group |
| EC2 | Security Group | EC2 Instance |
| EC2 | Subnet | EC2 Instance, EC2 VPC |
| EC2 | VPC | EC2 Security Group, EC2 Subnet |
| EC2 | VPN Gateway | EC2 VPC |
| ECS | Cluster | EC2 Instance, ECS Service, ECS Task, Route53 Hosted Zone |
| ECS | Service | Load Balancing Target Group, ECS Task |
| ECS | Task |  |
| Kinesis | Data Stream | Kinesis Firehose Delivery Stream |
| Kinesis | Firehose Delivery Stream | S3 Bucket |
| Lambda | Alias |  |
| Lambda | Function | All Supported Resources\* \(Input\), EC2 VPC, Lambda Alias, RDS Instance\*\* |
| Load Balancing | Application Load Balancer | EC2 VPC, Load Balancing Target Group, Load Balancing Target Group Instance |
| Load Balancing | Classic Load Balancer | EC2 Instance, EC2 VPC |
| Load Balancing | Network Load Balancer | EC2 VPC, Load Balancing Target Group, Load Balancing Target Group Instance |
| Load Balancing | Target Group | EC2 VPC |
| Load Balancing | Target Group Instance | EC2 Instance |
| RDS | Cluster | RDS Instance |
| RDS | Instance | EC2 VPC, EC2 Security Group |
| Redshift | Cluster | EC2 VPC |
| Route53 | Domain |  |
| Route53 | Hosted Zone |  |
| S3 | Bucket | Lambda Function |
| SNS | Topic | All Supported Resources\* |
| SQS | Queue |  |
| Step Functions | Activity |  |
| Step Functions | State | Step Functions \(All\), Lambda Function, DynamoDB Table, SQS Queue, SNS Topic, ECS Cluster, Api Gateway Rest API |
| Step Functions | State Machine | Step Functions \(All\) |

* **\* "All Supported Resources"** - relations will be made to any other resource on this list, should the resource type support it.
* \*\* This relation is made by finding valid URIs in the environment variables of the resource. For example, the DNS hostname of an RDS instance will create a relation.

#### Traces

The AWS integration does not retrieve any Traces data.

### Required AWS resources

A high-level of overview of all resources necessary to run the StackState Agent with full capabilities is provided in the graph below. Users with intermediate to high level AWS skills can use these details to set up the StackState Agent resources manually. For the majority of installations, this is not the recommended approach. Use the provided [StackState CloudFormation template](aws.md#stackstate-template-deployment) unless there are environment-specific issues that must be worked around.

![Account components](../../../.gitbook/assets/stackpack-aws-v2-account-components.svg)

Hourly and event-based updates collect data:

* Hourly full topology updates - collected by the StackState Agent using an IAM role with access to the AWS services.
* Event-based updates for single components and relations - captured using AWS services and placed into an S3 bucket for the StackState Agent to read.

If the StackState Agent does not have permission to access a certain component, it will skip it.

#### StackState Agent IAM Role

The bare minimum necessary to run the StackState Agent is an IAM role with necessary permissions. The Agent will always attempt to fetch as much data as possible for the supported resources. If a permission is omitted, the Agent will attempt to create a component with the data it has.

For example, if the permission `s3:GetBucketTagging` is omitted, the Agent will fetch all S3 buckets and their associated configuration, but the tags section will be empty.

* [IAM policy with all required permissions - JSON object](aws-policies.md#stackstateawsintegrationrole)

{% hint style="info" %}
IAM is a global service. Only one IAM role is necessary per account.
{% endhint %}

#### S3 Bucket

{% hint style="warning" %}
Once the Agent has finished reading a file in this bucket, the file will be **deleted**. Do not use an existing bucket for this, the Agent should have its own bucket to read from. The S3 bucket will not be read from if it does not have bucket versioning enabled, to protect data.
{% endhint %}

The S3 bucket is used to store all incoming events from EventBridge and other event-based sources. The Agent then reads objects from this bucket. These events are used to provide features such as real-time topology updates, and creating relations between components based on event data such as VPC FlowLogs. If the S3 bucket is not available to the Agent it will fallback to reading CloudTrail directly, which introduces a 15 minute delay in real-time updates. EventBridge events and VPC FlowLogs are only available via the S3 bucket.

{% hint style="info" %}
Only one S3 bucket is necessary per account; all regions can send to the same bucket.
{% endhint %}

#### EventBridge Rule

A catch-all rule for listening to all events for services supported by the AWS StackPack. All matched rules are sent to a Kinesis Firehose delivery stream.

* [EventBridge Rule - JSON object](aws-policies.md#stseventbridgerule)
* [EventBridge IAM Role - JSON](aws-policies.md#stackstateeventbridgerole-region) - Give permission for EventBridge to send data to Kinesis Firehose

{% hint style="info" %}
A rule must be created in each region where events are captured, each sending to a Firehose delivery stream in the same region.
{% endhint %}

#### Kinesis Firehose

Kinesis Firehose is used to receive and batch events from EventBridge. This delivery stream batches events per 60 seconds and pushes an object to S3. 60 seconds is the recommended value - setting this value any higher will negligibly decrease storage costs while increasing the delay in topology updates.

The Prefix must be set to `AWSLogs/${AccountId}/EventBridge/${Region}/`, where `${AccountId}` and `${Region}` are the account ID and region, for example, eu-west-1. Files must be compressed using the GZIP option.

{% hint style="info" %}
A delivery stream must be created in each region where events are captured, however, the target S3 bucket can exist in any region.
{% endhint %}

* [Kinesis Firehose IAM Role - JSON](aws-policies.md#stackstatefirehoserole-region) - Gives permission for Firehose to send data to an S3 bucket.

#### KMS Key \(Optional\)

A KMS Customer Managed Key \(CMK\) can be used to secure data at rest in S3. The KMS key is used in the Firehose Delivery Stream. The S3 bucket also uses the KMS key as its default key.

Use of a KMS is key is not necessary for the operation of the StackPack, however as encryption at rest is a requirement in most environments, the CloudFormation template includes this by default.

{% hint style="info" %}
A KMS key must be created in each region where events are captured.
{% endhint %}

* [Sample KMS Key policy](aws-policies.md#stackstate-integration-kms-key).

#### VPC FlowLogs

{% hint style="warning" %}
VPC FlowLogs support is currently experimental.
{% endhint %}

A VPC configured to send flow logs to the `stackstate-logs-${AccountId}` S3 bucket. The agent requires the AWS default format for VPC FlowLogs, and expects data to be aggregated every 1 minute. The FlowLogs contain meta information about the network traffic inside VPCs. Only private network traffic is considered, traffic from NAT gateways and application load balancers will be ignored. 

S3 objects that have been processed will be deleted from the bucket to make sure they will not be processed again. On the default S3 bucket, object versioning is enabled, this means objects will not actually be immediately deleted. A lifecycle configuration will expire (delete) both current and non-current object versions after one day. When using a non default bucket, you can set these expiry periods differently.

If configuring FlowLogs using CloudFormation, the `stackstate-resources` template exports the ARN of the S3 bucket it creates, so this can be imported into your template.

{% hint style="info" %}
A [FlowLog must be configured](#configure-vpc-flowlogs) for each VPC that you want to analyse.
{% endhint %}

* [AWS Flow Logs documentation](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)

### Costs

The AWS StackPack CloudFormation template contains all resources that are necessary to run the AWS check on the StackState Agent. The installed resources are kept as minimal as possible. All costs incurred are minimal but variable, with costs scaling depending on how many events are emitted in a given account. In practice, the costs created by the AWS integration will be negligible.

* Kinesis Firehose: priced by the amount of data processed. Events use very small amounts of data. [Firehose pricing \(aws.amazon.com\)](https://aws.amazon.com/kinesis/data-firehose/pricing/)
* S3: priced by amount of data stored, and amount of data transferred. Running the Agent inside of AWS will reduce data transfer costs. [S3 pricing \(aws.amazon.com\)](https://aws.amazon.com/s3/pricing/)
* KMS: a flat fee of $1 per month per key, with additional costs per request. [KMS pricing \(aws.amazon.com\)](https://aws.amazon.com/kms/pricing/)
* CloudWatch metrics: priced per metric retrived. Metrics are only retrieved when viewed or when a check is configured on a CloudWatch metric. [CloudWatch pricing \(aws.amazon.com\)](https://aws.amazon.com/cloudwatch/pricing/)

### AWS views in StackState

When the AWS integration is enabled, three [views](../../../use/stackstate-ui/views/about_views.md) will be created in StackState for each instance of the StackPack.

* **AWS - \[instance\_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
* **AWS - \[instance\_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
* **AWS - \[instance\_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [action](/use/stackstate-ui/perspectives/topology-perspective.md#actions) available in the component context menu and component details pane on the right-hand side of the screen. This provides a deep link through to the relevant AWS console at the correct point.

For example, in the StackState Topology Perspective:

* Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
* Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

### Tags and labels

The AWS StackPack converts tags in AWS to labels in StackState. In addition, the following special tags are supported:

| Tag | Description |
| :--- | :--- |
| `stackstate-identifier` | Adds the specified value as an identifier to the StackState component |
| `stackstate-environment` | Places the StackState component in the environment specified |

You can distinguish topology from the new and legacy AWS integrations by the labels attached:

| Label | Integration |
| :--- | :--- |
| `stackpack:aws-v2` | New AWS integration |
| `stackpack:aws` | AWS \(Legacy\) integration |

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall

To uninstall the StackState AWS StackPack, click the _Uninstall_ button from the StackState UI **StackPacks** &gt; **Integrations** &gt; **AWS** screen. This will remove all AWS specific configuration in StackState.

Once the AWS StackPack has been uninstalled, you will need to delete the StackState AWS Cloudformation stack from the AWS account being monitored. This can be done using the [web console](aws.md#web-console) or the [command line](aws.md#command-line).

### Web console

To delete the StackState AWS Cloudformation stack from an AWS account using the web console: If the template is in the main region, the S3 bucket used by StackState must be emptied as CloudFormation can't delete an empty bucket. Follow these steps:

1. Disable the EventBridge rule. Go to EventBridge, and find the rule name starting with `stackstate-resources-StsEventBridgeRule`. Open this rule, and press the "Disable" button.
2. Delete all flowlogs that send to this bucket. Go to the VPC service, and select each VPC in the VPCs list. Look in the FlowLogs tab in the details section, and delete any flowlogs that are sent to the S3 bucket starting with `stackstate-logs`.
3. Go to the S3 service. Select \(don't open\) the bucket named `stackstate-logs-${AccountId}` where `${AccountId}` is the 12-digit identifier of your AWS account.
4. Select "Empty", and follow the steps to delete all objects in the bucket.
5. Go to the CloudFormation service. Select the CloudFormation template. This will be named `stackstate-resources` if created via the quick deploy method, otherwise the name was user-defined.
6. In the top right of the console, select "Delete".

### Command line

These steps assume you already have the AWS CLI installed and configured with access to the target account. If not, [follow the AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).

1. If `--region` is the main region, follow these steps to delete the S3 bucket. Before emptying the bucket, disable any event sources that are sending files to the bucket. This is a versioned S3 bucket, so each object version must be deleted individually. If there are more than 1000 items in the bucket this command will fail; it's likely more convenient to perform this in the web console.

   ```bash
   BUCKET=$(aws cloudformation describe-stack-resource --stack-name stackstate-resources --logical-resource-id StsLogsBucket --query "StackResourceDetail.PhysicalResourceId" --output=text)

   # Disable the eventbridge rule sending to Firehose
   aws events disable-rule --name $(aws cloudformation describe-stack-resource --stack-name stackstate-resources-debug --logical-resource-id StsEventBridgeRule --query "StackResourceDetail.PhysicalResourceId" --output=text)
   # Find all flowlogs sending to the bucket and delete them
   aws ec2 delete-flow-logs --flow-log-ids $(aws ec2 describe-flow-logs --query "FlowLogs[?LogDestination==$BUCKET].[FlowLogId]" --output=text | tr '\n' ' ')

   sleep 60 # To make sure all objects have finished writing to bucket
   aws s3api delete-objects --bucket $BUCKET \
       --delete "$(aws s3api list-object-versions \
       --bucket $BUCKET --query Account --output text) \
       --output json \
       --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"
   ```

2. Delete the CloudFormation template: `aws cloudformation delete-stack --stack-name stackstate-resources --region <region>`.

Find out how to [uninstall using a specific AWS profile or an IAM role \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-options.html).

## Release notes

### 1.0.0 \(2021-07-09\)

**AWS StackPack v1.0.1 \(2021-07-23\)**

* Bugfix: Use proper domain 

**AWS StackPack v1.0.0 \(2021-07-16\)**

* Improvement: Full rewrite of the AWS Stackpack to use the StackState Agent V2
* Improvement: Improved AWS multi-account support by using IAM roles for account access
* Improvement: Improved AWS multi-region support - each instance can create topology for multiple regions at once
* Improvement: New, refreshed icon set, using the latest AWS branding

## See also

* [AWS policies](aws-policies.md)
* [StackState AWS \(Legacy\) integration](aws-legacy.md)
* [Working with AWS CloudFormation StackSets \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)
* [Uninstall using a specific AWS profile or an IAM role \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-options.html)

