---
description: StackState core integration (legacy)
---

# AWS \(Legacy\)

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/aws/aws-legacy).
{% endhint %}

{% hint style="info" %}
The AWS \(Legacy\) StackPack has been deprecated. It is recommended to use the [new AWS integration](aws.md).
{% endhint %}

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of AWS services.

![Data flow](../../../.gitbook/assets/stackpack-aws.png)

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
* An AWS user with the required access to retrieve Cloudwatch metrics:
  * `cloudwatch:GetMetricData`
  * `cloudwatch:ListMetrics`

    A policy file to create a user with the correct rights can be downloaded from the the StackState UI screen **StackPacks** &gt; **Integrations** &gt; **AWS**.
* An AWS user with the required access rights to install StackState monitoring in your account. See [AWS IAM policies](aws-legacy.md#aws-iam-policies), below.

### Proxy URL

If your StackState instance is behind a proxy, you need to configure the proxy URL and port for the AWS authorization to work. You can configure a proxy URL environment variable or JVM system property.

* Environment variable `HTTP_PROXY` and/or `HTTPS_PROXY`
* Pass following properties when starting StackState instance `-Dhttp.proxyHost -Dhttp.proxyPort` and/or `-Dhttps.proxyHost -Dhttps.proxyPort`

### Install

Install the AWS StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **AWS instance name** - the user-defined name of the AWS account shown in configurations such as views.
* **AWS Access Key id** - the access key for the user for retrieving Cloudwatch metrics.
* **AWS Secret Access Key** - the secret key for the user for retrieving Cloudwatch metrics.
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

Components retrieved from AWS will have an additional [action](../../../configure/topology/component_actions.md) available in the component context menu and component details pane on the right-hand side of the screen. This provides a deep link through to the relevant AWS console at the correct point.

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

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

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

**AWS \(Legacy\) StackPack v5.3.1 \(2021-07-16\)**

* Feature: Added Legacy logo and deprecation message, the new AWS stackpack is ready to use on StackState 4.4+.
* Bugfix: Fixed problem when uninstalling CloudFormation Stack that CloudTrail was still producing logs.
* Improvement: Updated documentation.

**AWS \(Legacy\) StackPack v5.3.0 \(2021-04-19\)**

* Improvement: Following component types now show their tags as labels: API Gateway Stages, SNS Topics, Firehoses, Route53 HostedZones, Route53 Domains and Classic Elastic LoadBalancers.
* Improvement: Topology for EC2 instances now includes public-ip and private-ip, hostname, fqdn and instance-id labels.
* Improvement: Security group components moved to Networking layer.
* Improvement: Updated documentation.
* Bugfix: Updates IAM policies when reinstalling AWS integration lambdas.

**AWS \(Legacy\) StackPack v5.2.2 \(2021-04-09\)**

* Bugfix: Fixed upgrading AWS StackPack when you upgrade StackState from 4.2.x to 4.3.x

**AWS \(Legacy\) StackPack v5.2.1 \(2021-04-02\)**

* Bugfix: Updated the manual\_trigger.sh to verify if the lambda exists, Trigger and monitor the lambda outcome and if it failed then the error will be displayed with a possible solution to allow the user to fix the problem and 'press any key' to retry
* Improvement: Update documentation.
* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.2.3 to 2.5.1
* Improvement: StackState min version bumped to 4.3.0

**AWS \(Legacy\) StackPack v5.1.3 \(2021-03-01\)**

* Feature: Added support for security groups
* Feature: Give RDS databases an identifier so that they can be referred to by other StackPacks
* Bugfix: Fixed the EC2 instances being stranded. Relationship restored to either a Subnet or VPC fallback.
* Bugfix: Added a delete event for the removal of a ELB Target Group
* Bugfix: Fixed the ELB, ELB Target Group and ELB Target Group Instance not mapping on cloud watch events
* Bugfix: Restored the EC2 identifier to the i- _mapping instead of urn:aws/i-_
* Bugfix: Updated the ELB Instance identifier to map to urn:aws/target-group-instance/i- _instead of i-_

**AWS \(Legacy\) StackPack v5.1.2 \(2021-02-01\)**

* Bugfix: Merged the `elb_v2_target_group_instance` and `ec2-instance`. The `elb_v2_target_group_instance` will no longer display as a generic aws resource but rather show up as the merged EC2 instance.

**AWS \(Legacy\) StackPack v5.1.1 \(2021-01-22\)**

* Feature: New component type `elb_v2_gateway` and its metrics added. 
* Feature: Metrics added for type `elb_v2_network`.
* Improvement: Metrics fixed for different target group based on load balancer type 
* Improvement: Restricted the full, minimal and uninstall policies resources from all \(\*\) to only certain resources. This will restrict the IAM user to only access resources created by StackState or Specified by the user
* Improvement: Lambda version is send in the payload
* Improvement: Better error logs
* Improvement: Cloudformation memory cache improvements

**AWS \(Legacy\) StackPack v5.1.0 \(2021-01-04\)**

* Feature: Added support for EC2 Nitro based metrics EBSWriteBytes and EBSReadBytes.
* Improvement: Check if `TargetGrouArn` exist in the loadBalancer for relation.

**AWS \(Legacy\) StackPack v5.0.2 \(2020-11\)**

* Bugfix: Fixed and improved the parsing of custom StackState identifier tags making it more flexible and ignoring case sensitivity.
* Bugfix: Fixed the merging between ECS service components with Traefik trace service components.
* Bugfix: Fixed profile selection doesn't work when you run `./install --profile`.

**AWS \(Legacy\) StackPack v5.0.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer.

**AWS \(Legacy\) StackPack v5.0.0 \(2020-08-13\)**

* Bugfix: Fixed the upgradation of other StackPacks due to AWS old layers using common. 

## See also

* [Troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack)
* [Using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html)

