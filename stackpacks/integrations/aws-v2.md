# AWS V2

## Overview

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of AWS services.

![Data flow](../../.gitbook/assets/stackpack-aws-v2.svg)

TODO: Describe data flow diagram

## Setup

### Prerequisites

To set up the StackState AWS V2 integration, you need to have:

### Install

Install the AWS V2 StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

### Configure

TODO: Details of how to configure Agent V2 for both required checks (logs and topology)

### Deploy AWS Cloudformation stacks

### AWS IAM Policies


## Integration details

### Data retrieved

#### Events

The AWS integration does not retrieve any Events data.

#### Metrics

Metrics data is pulled at a configured interval directly from AWS by the StackState CloudWatch plugin. Retrieved metrics are mapped onto the associated topology component.

TODO: are all metrics mapped to components/relations? Also possible to find in a data source?

#### Topology

**Components**

The following AWS service data is available in StackState as components:



**Relations**

The following relations between components are retrieved:



#### Traces

The AWS integration does not retrieve any Traces data.

### Costs

TODO: Similar info to below

The AWS lightweight agent uses Amazon resources \(Lambda and Kinesis\) for which Amazon will charge a minimal fee. Amazon also charges a fee for the use of CloudWatch metrics. Metrics are only retrieved when viewed or when a check is configured on a CloudWatch metric.

### AWS views in StackState

When the AWS integration is enabled, three [views](../../use/views.md) will be created in StackState for each instance of the StackPack.

* **AWS - \[instance\_name\] - All** - includes all resources retrieved from AWS by the StackPack instance.
* **AWS - \[instance\_name\] - Infrastructure** - includes only Networking, Storage and Machines resources retrieved from AWS by the StackPack instance.
* **AWS - \[instance\_name\] - Serverless** - includes only S3 buckets, lambdas and application load balancers retrieved from AWS by the StackPack instance.

### AWS actions in StackState

Components retrieved from AWS will have an additional [action](../../configure/topology/component_actions.md) available in the component context menu and component details pane on the right side of the screen. This provides a deep link through to the relevant AWS console at the correct point.

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

TODO: Create a similar troubleshooting guide for AWS V2

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall

TODO: Confirm steps below

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



## See also



