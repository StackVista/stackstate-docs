---
description: StackPack description
---

# AWS StackPack

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of the following AWS services:

| | | |
|:---|:---|:---|
| API Gateway | Elastic Load Balancer V2 (ELB) | Simple Storage Service (S3) |
| Auto Scaling Group | Kinesis Data Firehose | Simple Notification Service (SNS) |
| Cloud Formation | Kinesis Stream | Simple Queue Service (SQS) |
| DynamoDB | Lambda | Virtual Private Cloud (VPC) |
| Elastic Compute Cloud (EC2) | Relational Database Service (RDS) | VPN Gateway |
| Elastic Container Services (ECS) | Redshift | |
| Elastic Load Balancer Classic (ELB) | Route 53 | |

![Data flow](/.gitbook/assets/stackpack-aws.svg)

- The StackState AWS Agent is [a collection of Lambdas](#stackstate-aws-lambdas):
    - `stackstate-topo-cron` connects to the [AWS APIs](#rest-api-endpoints) every hour to collect information about available resources and publishes this to the StackState Kinesis Event Stream.
    - `stackstate-topo-cwevents` listens for any changes made to AWS resources and publishes these directly to the StackState Kinesis Event Stream.
    - `stackstate-topo-publisher` listens to the StackState Kinesis Event Stream and pushes [retrieved data](#data-retrieved) to StackState.
- StackState translates incoming data into topology components and relations.
- The StackState CloudWatch plugin pulls available telemetry data per resource at a configured interval from AWS.
- StackState maps retrieved telemetry (metrics) onto the associated AWS components and relations.

## Setup

### Prerequisites

To set up the StackState AWS integration, you need to have:

* An installed and configured AWS CLI. Note that AWS CLI version 2.0.0 has a bug that reports a false ValidationError on properly formatted YAML files. Upgrade AWS CLI to version 2.0.4.
* An AWS user with the required access to retrieve Cloudwatch metrics:
    - `cloudwatch:GetMetricData`
    - `cloudwatch:ListMetrics`
  A policy file to create a user with the correct rights can be downloaded from the the StackState UI screen **StackPacks** &gt; **Integrations**  &gt; **AWS**.
* An AWS user with the required access rights to install StackState monitoring in your account. Policy files to create a user with the correct rights can be downloaded from the the StackState UI screen **StackPacks** &gt; **Integrations**  &gt; **AWS** after you have installed the AWS StackPack.

### Install

Install the AWS StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **AWS instance name** - the user-defined name of AWS account shown in configurations such as views.
* **AWS Access Key id** - the access key for the user for retrieving Cloudwatch metrics.
* **AWS Secret Access Key** - the secret key for the user for retrieving Cloudwatch metrics.
* **AWS Role ARN** - Optional: IAM role ARN - the ARN of the IAM role to be used

### Deploy AWS Agent

The StackState AWS Agent is deployed on your AWS account to enable topology monitoring. There are two options for StackState monitoring:

* [Full install](#full-install) - all changes to AWS resources will be picked up and pushed to StackState.
* [Minimal install](#minimal-install) - changes will be picked up only at a configured interval.

#### Full install

A full installation will install the following CloudFormation Stacks:

- `stackstate-topo-cron`
- `stackstate-topo-kinesis`
- `stackstate-topo-cloudtrail`
- `stackstate-topo-cwevents`
- `stackstate-topo-publisher`

To complete a full install the of StackState AWS Agent, follow the steps below:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

2. Make sure the AWS CLI is logged in with the proper account and has the default region set to the region that should be monitored by StackState.

3. From the command line, run the command:
```
./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```
AWS_PROFILE=profile-name ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

For details on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).

#### Minimal install

The minimal installation is useful when less permissions are available. This installs only the `stackstate-topo-cron` stack, which means StackState's topology will only get a full topology update every hour. Updates between the hour are not sent to StackState. 

To complete a minimal install of the StackState AWS Agent, follow the steps below:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

2. Make sure the AWS CLI is logged in with the proper account and has the default region set to the region that should be monitored by StackState.
 
3. From the command line, run the command:
```
./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```
   You can also optionally specify the following:
    - **--topo-cron-bucket** - a custom S3 bucket to be used during deployment.
    - **--topo-cron-role** - a custom AWS IAM role. Note that the role must have an attached policy like that specified in the file `sts-topo-cron-policy.json` included in the manual install zip file.

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```
AWS_PROFILE=profile-name ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh --topo-cron-only {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

For details on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).

#### AWS IAM Policies for install and uninstall

The following AWS policies can be downloaded during the installation of AWS StackPack in your StackState instance:

* `StackStateIntegrationPolicyInstall.json` - used for the full installation that deploys all CloudFormation Stacks.
* `StackStateIntegrationPolicyTopoCronInstall.json` - used for the minimal install that only deploys the `stackstate-topo-cron` CloudFormation Stack.
* `StackStateIntegrationPolicyTopoCronMinimal.json` - a minimal set of policies as the S3 bucket and the role are provided by user.
* `StackStateIntegrationPolicyUninstall.json` - used to uninstall a full installation.
* `StackStateIntegrationPolicyTopoCronUninstall.json` - used to uninstall a minimal installation.

### Status


## Integration details

### Data retrieved

#### Events

The AWS integration does not retrieve any Events data.

#### Metrics

Metrics data is pulled at a configured interval directly from AWS by the StackState ClourWatch plugin. Retrieved metrics are mapped onto the associated topology component.

#### Topology

Each AWS integration retrieves topology data for resources associated with the associated AWS access key.

- Components
- Relations

#### Traces

The AWS integration does not retrieve any Traces data.

### REST API endpoints

### StackState AWS lambdas

The StackState AWS Agent installs the following AWS lambdas:

| Lambda | Description |
|:---|:---|
| `stackstate-topo-cron` | Scans the initial topology based on an interval schedule and publishes to StackState. |
| `stackstate-topo-cwevents` | Listens to CloudWatch events, transforms the events and publishes them to Kinesis. |
| `stackstate-topo-publisher` | Publishes topology from a Kinesis stream to StackState. |

### AWS views in StackState

When the AWS integration is enabled, three [view](/use/views/README.md) will be created in StackState for each instance of the StackPack.

- **AWS - \[instance_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [action](/use/views/topology-perspective.md#actions) available in the component context menu and component details pane on the right side of the screen. This provides a deep link through to the relevant AWS console at the correct point.

For example, in the StackState topology perspective: 

- Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
- Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall

To uninstall the StackState AWS Agent, click the *Uninstall* button from the StackState UI **StackPacks** &gt; **Integrations**  &gt; **AWS** screen. This will remove all AWS specific configuration in StackState. 

Once the AWS StackPack has been uninstalled, you will need to manually uninstall the StackState AWS Agent from the AWS account being monitored. To execute the manual uninstall folow these steps:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

2. Make sure the AWS CLI is logged in with the proper account and has the default region set to the region that should be monitored by StackState. 
    - For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).

3. From the command line, run the below command to deprovision all resources related to the StackPack instance:
```
./uninstall.sh {{configurationId}}
```

If you wish to use a specific AWS profile or an IAM role during uninstallation, run either of these two commands:

```
AWS_PROFILE=profile-name ./uninstall.sh {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./uninstall.sh {{configurationId}}
```

## Release notes

**AWS StackPack v5.0.2 \(2020-11\)**

* Bugfix: Fixed and improved the parsing of custom stackstate identifier tags making it more flexible and ignoring case sensitivity.
* Bugfix: Fixed the merging between ECS service components with Traefik trace service components.
* Bugfix: Fixed profile selection doesn't work when you run `./install --profile`.

**AWS StackPack v5.0.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer.

**AWS StackPack v5.0.0 \(2020-08-13\)**

* Bugfix: Fixed the upgradation of other stackpacks due to AWS old layers using common. 

**AWS StackPack v4.3.0 \(2020-08-04\)**

* Improvement: Deprecated StackPack specific layers and introduced a new common layer structure.

**AWS StackPack v4.2.2 \(2020-07-16\)**

* Bugfix: AWS Lambda uninstall scripts now properly deletes Cloudtrail S3 bucket.

**AWS StackPack v4.2.1 \(2020-06-22\)**

* Improvement: Fixed the icons for few component types of power 2.

**AWS StackPack v4.2.0 \(2020-06-19\)**

* Improvement: Set the stream priorities on all streams.

**AWS StackPack v4.1.0 \(2020-06-01\)**

* Improvement: Manual installation zip has StackPack version number.
* Improvement: StackState resources created on AWS are tagged with StackPack version.

**AWS StackPack v4.0.2 \(2020-06-03\)**

* Bugfix: Remove duplicate streams.

**AWS StackPack v4.0.1 \(2020-05-19\)**

* Bugfix: Fixed parsing CloudFormation when a resource has no Physical ID.

**AWS StackPack v4.0.0 \(2020-04-10\)**

* Feature: Full installation of all lambdas or minimal installation of just Topology gathering lambda.
* Feature: Manual install script has help message with all parameters.
* Feature: Split AWS IAM policies in installation and uninstallation group for each type of installation.
* Improvement: Updated StackPacks integration page, categories, and icons for the SaaS trial.
* Bugfix: AWS resource tags are kept in original format.

## See also

- [Troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack)
- [Using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html)