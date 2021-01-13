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

### Pre-requisites

### Install

### Configure


### Status

To check the status of the DynaTrace integration, run the status subcommand and look for DynaTrace under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events



#### Metrics



#### Topology



| Data | Description |
|:---|:---|
|  |  |
|  |  | 

#### Traces



### REST API endpoints


### Open source


## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState AWS StackPack](https://support.stackstate.com/hc/en-us/articles/360016959719-Troubleshooting-StackState-AWS-StackPack).

## Uninstall


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