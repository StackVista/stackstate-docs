---
description: StackPack description
---

# AWS StackPack

## Overview



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

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=DynaTrace).

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

-