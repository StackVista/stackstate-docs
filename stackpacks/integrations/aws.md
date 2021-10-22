---
old-description: Get topology and telemetry data from AWS services
---

# AWS StackPack

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

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

![Data flow](/.gitbook/assets/stackpack-aws.png)

- Three AWS Lambdas collect topology data from AWS and push this to StackState:
    - `stackstate-topo-cron` scans AWS resources every hour using the AWS APIs and pushes this to StackState.
    - `stackstate-topo-cwevents` listens to CloudWatch events, transforms the events and publishes them to Kinesis.
    - `stackstate-topo-publisher` publishes [retrieved topology data](#data-retrieved) from a Kinesis stream to StackState.
- StackState translates incoming data into topology components and relations.
- The StackState CloudWatch plugin pulls available telemetry data per resource at a configured interval from AWS.
- StackState maps retrieved telemetry (metrics) onto the associated AWS components and relations.

## Setup

### Prerequisites

To set up the StackState AWS integration, you need to have:

* AWS CLI version 2.0.4 or later installed and configured.
* An AWS user with the required access to retrieve Cloudwatch metrics:
    - `cloudwatch:GetMetricData`
    - `cloudwatch:ListMetrics`
  A policy file to create a user with the correct rights can be downloaded from the the StackState UI screen **StackPacks** > **Integrations**  > **AWS**.
* An AWS user with the required access rights to install StackState monitoring in your account. See [AWS IAM policies](#aws-iam-policies), below.

### Proxy URL

If your StackState instance is behind a proxy, you need to configure the proxy URL and port for the AWS authorization to work.
You can configure a proxy URL environment variable or JVM system property.

- Environment variable `HTTP_PROXY` and/or `HTTPS_PROXY`
- Pass following properties when starting StackState instance `-Dhttp.proxyHost -Dhttp.proxyPort` and/or `-Dhttps.proxyHost -Dhttps.proxyPort`

### Install

Install the AWS StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **AWS instance name** - the user-defined name of the AWS account shown in configurations such as views.
* **AWS Access Key id** - the access key for the user for retrieving Cloudwatch metrics.
* **AWS Secret Access Key** - the secret key for the user for retrieving Cloudwatch metrics.
* **AWS Role ARN** - Optional: IAM role ARN - the ARN of the IAM role to be used

### Deploy AWS Cloudformation stacks

The StackState AWS Cloudformation stacks are deployed on your AWS account to enable topology monitoring. There are two options for StackState monitoring:

* [Full install](#full-install) - all changes to AWS resources will be picked up and pushed to StackState.
* [Minimal install](#minimal-install) - changes will be picked up only at a configured interval.

#### Full install

A full installation will install the following CloudFormation Stacks:

- `stackstate-topo-cron`
- `stackstate-topo-kinesis`
- `stackstate-topo-cloudtrail`
- `stackstate-topo-cwevents`
- `stackstate-topo-publisher`

Follow the steps below to complete a full install:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

2. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState.
    - For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).

3. From the command line, run the command:
```
./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

If you wish to use a specific AWS profile or an IAM role during installation, run either of these two commands:

```
AWS_PROFILE=profile-name ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
AWS_ROLE_ARN=iam-role-arn ./install.sh {{config.baseUrl}} {{config.apiKey}} {{configurationId}}
```

These environment variables have the same names used by the AWS_CLI utility and will be overridden with options:
`--profile`
`--role-arn`
`--session-name`
`--external-id`.

#### Minimal install

The minimal installation is useful when less permissions are available. This installs only the `stackstate-topo-cron` Cloudformation stack, which means StackState's topology will only get a full topology update every hour. Updates between the hour are not sent to StackState. 

Follow the steps below to complete a minimal install:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

2. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState.
    - For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).
 
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

These environment variables have the same names used by the AWS_CLI utility and will be overridden with options:
`--profile`
`--role-arn`
`--session-name`
`--external-id`


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

- Components
- Relations

#### Traces

The AWS integration does not retrieve any Traces data.

### AWS lambdas

The StackState AWS integration installs the following AWS lambdas:

| Lambda | Description |
|:---|:---|
| `stackstate-topo-cron` | Scans the initial topology based on an interval schedule and pushes to StackState. |
| `stackstate-topo-cwevents` | Listens to CloudWatch events, transforms the events and publishes them to Kinesis. Full install only.|
| `stackstate-topo-publisher` | Pushes topology from a Kinesis stream to StackState. Full install only. |

### Costs

The AWS lightweight agent uses Amazon resources (Lambda and Kinesis) for which Amazon will charge a minimal fee. Amazon also charges a fee for the use of CloudWatch metrics. Metrics are only retrieved when viewed or when a check is configured on a CloudWatch metric.

### AWS views in StackState

When the AWS integration is enabled, three [views](/use/views/README.md) will be created in StackState for each instance of the StackPack.

- **AWS - \[instance_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
- **AWS - \[instance_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [action](/configure/topology/component_actions.md) available in the component context menu and component details pane on the right side of the screen. This provides a deep link through to the relevant AWS console at the correct point.

For example, in the StackState topology perspective: 

- Components of type aws-subnet have the action **Go to Subnet console**, which links directly to this component in the AWS Subnet console.
- Components of type ec2-instance have the action **Go to EC2 console**, which links directly to this component in the EC2 console.

### Tags and labels

The AWS StackPack converts tags in AWS to labels in StackState. In addition, the following special tags are supported:

| Tag | Description |
| :--- | :--- |
| `stackstate-identifier` | Adds the specified value as an identifier to the StackState component |
| `stackstate-environment` | Places the StackState component in the environment specified |

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall

To uninstall the StackState AWS StackPack, click the *Uninstall* button from the StackState UI **StackPacks** &gt; **Integrations**  &gt; **AWS** screen. This will remove all AWS specific configuration in StackState. 

Once the AWS StackPack has been uninstalled, you will need to manually uninstall the StackState AWS Cloudformation stacks from the AWS account being monitored. To execute the manual uninstall follow these steps:

1. Download the manual installation zip file and extract it. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

2. Make sure the AWS CLI is configured with the proper account and has the default region set to the region that should be monitored by StackState. 
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

These environment variables have the same names used by the AWS_CLI utility and will be overridden with options:
`--profile`
`--role-arn`
`--session-name`
`--external-id`

## Release notes

**AWS StackPack v5.0.2 \(2020-11\)**

* Bugfix: Fixed and improved the parsing of custom StackState identifier tags making it more flexible and ignoring case sensitivity.
* Bugfix: Fixed the merging between ECS service components with Traefik trace service components.
* Bugfix: Fixed profile selection doesn't work when you run `./install --profile`.

**AWS StackPack v5.0.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer.

**AWS StackPack v5.0.0 \(2020-08-13\)**

* Bugfix: Fixed the upgradation of other StackPacks due to AWS old layers using common. 

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
