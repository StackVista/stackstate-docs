---
description: StackState Self-hosted v5.1.x 
---

# AWS \(legacy\)

{% hint style="info" %}
The AWS \(legacy\) StackPack has been deprecated. It is recommended to use the [new AWS integration](aws.md).
{% endhint %}

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of AWS services.

![Data flow](../../../.gitbook/assets/stackpack-aws.svg)

* Three AWS Lambdas collect topology data from AWS and push this to StackState:
  * `stackstate-topo-cron` scans AWS resources every hour using the AWS APIs and pushes this to StackState.
  * `stackstate-topo-cwevents` listens to CloudWatch events, transforms the events and publishes them to Kinesis.
  * `stackstate-topo-publisher` publishes [retrieved topology data](aws-legacy.md#topology) from a Kinesis stream to StackState.
* StackState translates incoming data into topology components and relations.
* The StackState CloudWatch plugin pulls available telemetry data per resource at a configured interval from AWS.
* StackState maps retrieved telemetry \(metrics\) onto the associated AWS components and relations.

## Setup

### Prerequisites

To set up the StackState AWS integration, you need to have:

* AWS CLI version 2.0.4 or later is installed on the environment where StackState is running.
* An AWS user with the required access to retrieve CloudWatch metrics:
  * `cloudwatch:GetMetricData`
  * `cloudwatch:ListMetrics`

    A policy file to create a user with the correct rights can be downloaded from the StackState UI screen **StackPacks** &gt; **Integrations** &gt; **AWS**.
* An AWS user with the required access rights to install StackState monitoring in your account. See [AWS IAM policies](aws-legacy.md#aws-iam-policies), below.

### Proxy URL

If your StackState instance is behind a proxy, you need to configure the proxy URL and port for the AWS authorization to work. You can configure a proxy URL environment variable or JVM system property.

* Environment variable `HTTP_PROXY` and/or `HTTPS_PROXY`
* Pass following properties when starting StackState instance `-Dhttp.proxyHost -Dhttp.proxyPort` and/or `-Dhttps.proxyHost -Dhttps.proxyPort`

### Install

Install the AWS StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **AWS instance name** - the user-defined name of the AWS account shown in configurations such as views.
* **AWS Access Key id** - the access key for the user for retrieving CloudWatch metrics.
* **AWS Secret Access Key** - the secret key for the user for retrieving CloudWatch metrics.
* **AWS Role ARN** - Optional: IAM role ARN - the ARN of the IAM role to be used

### Deploy AWS Cloudformation stacks

The StackState AWS Cloudformation stacks are deployed on your AWS account to enable topology monitoring. There are two options for StackState monitoring:

* [Full install](aws-legacy.md#full-install) - all changes to AWS resources will be picked up and pushed to StackState.
* [Minimal install](aws-legacy.md#minimal-install) - changes will be picked up only at a configured interval.

#### Full install

A full installation will install the following CloudFormation Stacks:

* `stackstate-topo-cron`
* `stackstate-topo-kinesis`
* `stackstate-topo-cloudtrail`
* `stackstate-topo-cwevents`
* `stackstate-topo-publisher`

Follow the steps below to complete a full install:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.
2. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState.
   * For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).
3. From the command line, run the command:

   ```text
   ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
   ```

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```text
AWS_PROFILE=profile-name ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

These environment variables have the same names used by the AWS\_CLI utility and will be overridden with options:

* `--profile`
* `--role-arn`
* `--session-name`
* `--external-id`

#### Minimal install

The minimal installation is useful when less permissions are available. This installs only the `stackstate-topo-cron` Cloudformation stack, which means StackState's topology will only get a full topology update every hour. Updates between the hour are not sent to StackState.

Follow the steps below to complete a minimal install:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.
2. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState.
   * For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).
3. From the command line, run the command:

   ```text
   ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
   ```

   You can also optionally specify the following:

   * **--topo-cron-bucket** - a custom S3 bucket to be used during deployment.
   * **--topo-cron-role** - a custom AWS IAM role. Note that the role must have an attached policy like that specified in the file `sts-topo-cron-policy.json` included in the manual install zip file.

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```text
AWS_PROFILE=profile-name ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

These environment variables have the same names used by the AWS\_CLI utility and will be overridden with options:

* `--profile`
* `--role-arn`
* `--session-name`
* `--external-id`

### AWS IAM Policies

The following AWS policies can be downloaded during the installation of the AWS StackPack in your StackState instance:

* **Full install** - `StackStateIntegrationPolicyInstall.json`
* **Minimal install** - `StackStateIntegrationPolicyTopoCronInstall.json` 
* **Minimal set of policies** - `StackStateIntegrationPolicyTopoCronMinimal.json` S3 bucket and role are provided by user.
* **Uninstall a full install** - `StackStateIntegrationPolicyUninstall.json`
* **Uninstall a minimal install** - `StackStateIntegrationPolicyTopoCronUninstall.json`

### Timeout

The default read timeout for AWS is set to 30 seconds. You can specify custom read timeout with the `AWS_CLI_READ_TIMEOUT` environment variable.

## Integration details

### Data retrieved

#### Events

The AWS integration does not retrieve any Events data.

#### Metrics

Metrics data is pulled at a configured interval directly from AWS by the StackState CloudWatch plugin. Retrieved metrics are mapped onto the associated topology component.

#### Topology

Each AWS integration retrieves topology data for resources associated with the associated AWS access key.

**Components**

The following AWS service data is available in StackState as components:

|  |  |  |
| :--- | :--- | :--- |
| API Gateway Resource | API Gateway Stage | API Gateway Method |
| AutoScaling Group | CloudFormation Stack | DynamoDB Stream |
| DynamoDB Table | EC2 Instance | ECS Cluster |
| ECS Service | ECS Task | Firehose Delivery Stream |
| Kinesis Stream | Lambda | Lambda Alias |
| Load Balancer Classic | Load Balancer V2 | RDS Instance |
| Redshift Cluster | Route53 Domain | Route53 Hosted Zone |
| S3 bucket | Security Group | SNS Topic |
| SQS Queue | Subnet | Target Group |
| Target Group Instance | VPC | VPN Gateway |

**Relations**

The following relations between components are retrieved:

* API Gateway Method → \(Service\) Integration Resource \(varies\)
* API Gateway Resource → API Gateways Method
* API Gateway Stage → API Gateway Resource
* AutoScaling Group → EC2 Instance, Load Balancer Classic
* CloudFormation Stack → Any Resource \(many supported\), CloudFormation Stack Parent
* DynamoDB Table → DynamoDB Stream
* EC2 Instance → Security Group, Subnet, VPC
* ECS Cluster → EC2 Instance, ECS Task \(when no group service\)
* ECS Service → ECS Cluster, ECS Task, Route53 Hosted Zone, Target Group
* ECS Task → ECS Cluster
* Firehose Delivery Stream → Kinesis Source, S3 Bucket Destination\(s\)
* Lambda → Event Source Mapping, Security Group, VPC
* Lambda Alias → VPC
* Load Balancer Classic → EC2 Instance, VPC
* Load Balancer V2 → Security Group, Target Group, VPC
* RDS Cluster → RDS Instance
* RDS Instance → Security Group, VPC
* Redshift Cluster → VPC
* S3 Bucket → Lambda \(notification configuration of the bucket\)
* Security Group → VPC
* SNS Topic → Subscription
* Subnet → VPC
* Target Group → AutoScaling Group, EC2 Instance, VPC
* VPN Gateway → VPC

#### Traces

The AWS integration does not retrieve any Traces data.

### AWS lambdas

The StackState AWS integration installs the following AWS lambdas:

| Lambda | Description |
| :--- | :--- |
| `stackstate-topo-cron` | Scans the initial topology based on an interval schedule and pushes to StackState. |
| `stackstate-topo-cwevents` | Listens to CloudWatch events, transforms the events and publishes them to Kinesis. Full install only. |
| `stackstate-topo-publisher` | Pushes topology from a Kinesis stream to StackState. Full install only. |

### Costs

The AWS lightweight agent uses Amazon resources \(Lambda and Kinesis\) for which Amazon will charge a minimal fee. Amazon also charges a fee for the use of CloudWatch metrics. Metrics are only retrieved when viewed or when a check is configured on a CloudWatch metric.

### AWS views in StackState

When the AWS integration is enabled, three [views](../../../use/stackstate-ui/views/about_views.md) will be created in StackState for each instance of the StackPack.

* **AWS - \[instance\_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
* **AWS - \[instance\_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
* **AWS - \[instance\_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [Action](/use/stackstate-ui/perspectives/topology-perspective.md#actions) available in the component context menu and in the right panel details tab - **Component details** - when you select the component. This provides a deep link through to the relevant AWS console at the correct point.

For example, in the StackState Topology Perspective:

* Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
* Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

### Tags and labels

The AWS StackPack converts tags in AWS to labels in StackState. In addition, the following special tags are supported:

| Tag | Description |
| :--- | :--- |
| `stackstate-identifier` | Adds the specified value as an identifier to the StackState component |
| `stackstate-environment` | Places the StackState component in the environment specified |

## Troubleshooting

Check the StackState support site for:

* [The AWS \(legacy\) StackPack troubleshooting guide](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-Legacy-StackPack).
* [Known issues relating to the AWS \(legacy\) StackPack](https://support.stackstate.com/hc/en-us/search?utf8=%E2%9C%93&query=tags%3Aaws-legacy).


## Uninstall

To uninstall the StackState AWS StackPack, click the _Uninstall_ button from the StackState UI **StackPacks** &gt; **Integrations** &gt; **AWS** screen. This will remove all AWS specific configuration in StackState.

Once the AWS StackPack has been uninstalled, you will need to manually uninstall the StackState AWS Cloudformation stacks from the AWS account being monitored. To execute the manual uninstall follow these steps:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.
2. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState.
   * For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).
3. From the command line, run the below command to de-provision all resources related to the StackPack instance:

   ```text
   ./uninstall.sh {{configurationId}}
   ```

If you wish to use a specific AWS profile or an IAM role during uninstallation, run either of these two commands:

```text
AWS_PROFILE=profile-name ./uninstall.sh {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./uninstall.sh {{configurationId}}
```

These environment variables have the same names used by the AWS\_CLI utility and will be overridden with options:

* `--profile`
* `--role-arn`
* `--session-name`
* `--external-id`

## Release notes

**AWS \(legacy\) StackPack v5.3.3 (2021-11-16)**

* Improvement: Updated AWS CLI prerequisite text.

**AWS \(legacy\) StackPack v5.3.2 (2021-08-20)**

* Improvement: Add description to Views.

**AWS \(legacy\) StackPack v5.3.1 \(2021-07-16\)**

* Feature: Added Legacy logo and deprecation message, the new AWS stackpack is ready to use on StackState 4.4+.
* Bugfix: Fixed problem when uninstalling CloudFormation Stack that CloudTrail was still producing logs.
* Improvement: Updated documentation.

## See also

* [Troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack)
* [Using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html)

