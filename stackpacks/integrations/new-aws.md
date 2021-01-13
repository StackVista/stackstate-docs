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

![Data flow](/.gitbook/assets/stackpack-NAME.png)



## Setup

### Prerequisites

To set up the StackState AWS integration, you need to have:

* An installed and configured AWS CLI.
* An AWS user with the required access to retrieve Cloudwatch metrics:
    - `cloudwatch:GetMetricData`
    - `cloudwatch:ListMetrics`
    - A policy file to create a user with the correct rights can be downloaded from the the StackState UI **StackPacks** &gt; **Integrations**  &gt; **AWS** screen.
* An AWS user with the required access rights to install StackState monitoring in your account.
    - Policy files to create a user with the correct rights can be downloaded from the the StackState UI **StackPacks** &gt; **Integrations**  &gt; **AWS** screen after you have installed the AWS StackPack.

For further information on authentication via the AWS CLI, see [using an IAM role in the AWS CLI \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).

### Install

Install the AWS StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **AWS instance name** - the user-defined name of AWS account shown in configurations such as views.
* **AWS Access Key id** - the access key for the user for retrieving Cloudwatch metrics.
* **AWS Secret Access Key** - the secret key for the user for retrieving Cloudwatch metrics.
* **AWS Role ARN** - Optional: IAM role ARN - the ARN of the IAM role to be used

### Deploy AWS Agent

#### Required access rights to install


### Status


## Integration details

### Data retrieved

#### Events

The AWS integration does not retrieve any Events data.

#### Metrics

The AWS integration does not retrieve any Metrics data.

#### Topology

| Data | Description |
|:---|:---|
|  |  |
|  |  | 

#### Traces

The AWS integration does not retrieve any Traces data.

### REST API endpoints


## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall

To uninstall the StackState AWS Agent, click the *Uninstall* button from the StackState UI **StackPacks** &gt; **Integrations**  &gt; **AWS** screen. This will remove all AWS specific configuration in StackState. 

Once the AWS StackPack has been uninstalled, you will need to manually uninstall the StackState AWS Agent from the AWS account being monitored. To execute the manual uninstall folow these steps:

1. Download the manual installation zip file. This is included in the AWS StackPack and can be accessed at the link provided in StackState after you install the AWS StackPack.

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