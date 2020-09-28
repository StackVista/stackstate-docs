---
title: AWS StackPack
kind: documentation
---

# AWS

## What is the AWS StackPack?

Amazon Web Services \(AWS\) is a major cloud provider. This StackPack enables in-depth monitoring of the following AWS services:

* API Gateway
* Auto Scaling Group
* Cloud Formation
* DynamoDB
* Elastic Compute Cloud \(EC2\)
* Elastic Container Services \(ECS\)
* Elastic Load Balancer Classic \(ELB\)
* Elastic Load Balancer V2 \(ELB\)
* Kinesis Data Firehose
* Kinesis Stream
* Lambda
* Relational Database Service \(RDS\)
* Redshift
* Route 53
* Simple Storage Service \(S3\)
* Simple Notification Service \(SNS\)
* Simple Queue Service \(SQS\)
* Virtual Private Cloud \(VPC\)
* VPN Gateway

We also support monitoring X-Ray Traces with the [StackState Agent](agent.md).

Read [the announcement](https://stackstate.com/blog/stackstate-announces-aws-cloud-monitoring) for more information about the benefits of the AWS StackPack.

## Prerequisites

* An installed and configured AWS CLI
* An AWS user with the required access rights for installing StackState monitoring in your account

Policy files for the access rights can be downloaded from the AWS StackPack installed in your StackState instance.

Please refer to the AWS [documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html) for further information on authentication via the AWS CLI.

## AWS StackPack lambdas

The AWS StackPack requires installation of three lambda functions to monitor your AWS resources:

* `stackstate-topo-cron` - Scans the initial topology based on an interval schedule and publishes to StackState
* `stackstate-topo-cwevents` - A Lambda function that listens to CloudWatch events, transforms the events and publishes them to Kinesis
* `stackstate-topo-publisher` - A Lambda function that publishes topology from a Kinesis stream to StackState

## Installation

The AWS StackPack is installed with an installation script that you can download from the AWS StackPack in your StackState instance.

There are two versions of StackState monitoring that you can install on your AWS account:

* Full installation
* Minimal installation

### Full installation

The full installation enables both periodic and real-time monitoring of your AWS resources. It installs the following CloudFormation stacks:

* `stackstate-topo-cron`
* `stackstate-topo-cwevents`
* `stackstate-topo-publisher`
* `stackstate-topo-cloudtrail`
* `stackstate-topo-kinesis`

### Minimal installation

The minimal installation enables periodic monitoring of your AWS resources. It installs the following CloudFormation stack:

* `stackstate-topo-cron`

#### Minimal installation options

When you use the AWS StackPack minimal installation, you have the following additional options:

* **Custom S3 bucket** - You can specify a custom S3 bucket to be used during deployment using the option `--topo-cron-bucket`. The install files necessary for CloudFormation Stack installation are deployed there.
* **Custom IAM role** - Custom AWS IAM role can be specified with the option `--topo-cron-role`. It must have an attached policy defined like in file `sts-topo-cron-policy.json`

## AWS IAM Policies for installation and uninstallation

The following AWS policies are available for the installation of the AWS StackPack:

* `StackStateIntegrationPolicyInstall.json` - this is used for the normal installation that deploys all CloudFormation Stacks.
* `StackStateIntegrationPolicyTopoCronInstall.json` - this is for deploying just `stackstate-topo-cron` CloudFormation Stack.
* `StackStateIntegrationPolicyTopoCronMinimal.json` - a minimal set of policies as the S3 bucket and the role are provided by user.
* `StackStateIntegrationPolicyUninstall.json` - this is used for normal uninstallation
* `StackStateIntegrationPolicyTopoCronUninstall.json` - if only `stackstate-topo-cron` is installed this set of policies is needed for uninstallation

These policy files can be downloaded during the installation of AWS StackPack in your StackState instance.

### Specifying profile and role with environment variables

You can specify the concrete CLI profile to be used for installation:

example: `AWS_PROFILE=profile ./install.sh YOUR_INTAKE_URL YOUR_API_KEY YOUR_CONFIG_INSTANCE_ID`

Alternatively, you can specify the role ARN of the IAM role you wish to use during installation:

example: `AWS_ROLE_ARN=roleArn AWS_SESSION_NAME=sessionName AWS_EXTERNAL_ID=externalId ./install.sh YOUR_INTAKE_URL YOUR_API_KEY YOUR_CONFIG_INSTANCE_ID`

## Special tags

The AWS StackPack converts tags in AWS to labels in StackState. In addition, the following special tags are supported:

|  |  |
| :--- | :--- |
| `stackstate-identifier` | Adds the specified value as an identifier to the StackState component |
| `stackstate-environment` | Places the StackState component in the environment specified |

## Uninstalling

Execute the uninstall script to deprovision the StackState AWS StackPack resources created in your environment. This script requires the AWS CLI and read/write permissions to some AWS resources.

example: `./uninstall.sh YOUR_CONFIG_INSTANCE_ID` in order to deprovision resources associated to the particular StackPack YOUR\_CONFIG\_INSTANCE\_ID

example: `./uninstall.sh` in order to deprovision all resources related to any StackPack.

You can specify the concrete CLI profile to be used for deinstallation:

example: `AWS_PROFILE=profile ./uninstall.sh`

Alternatively, you can specify the role ARN of the IAM role you wish to use during uninstallation:

example: `AWS_ROLE_ARN=roleArn AWS_SESSION_NAME=sessionName AWS_EXTERNAL_ID=externalId ./uninstall.sh`

### Environment variables and options

These environment variables have the same names as AWS\_CLI utility uses. They can be overridden with options `--profile`, `--role-arn`, `--session-name`, and `--external-id`.

