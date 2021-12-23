---
description: StackState Self-hosted v4.5.x
---





# Migrate AWS \(Legacy\) to AWS

## Overview

The new AWS integration available from StackState v4.4 is an entirely new StackPack that replaces the old AWS \(Legacy\) StackPack. The AWS \(Legacy\) StackPack has now been deprecated, and it is advised that you migrate your StackState AWS integration to use the new AWS StackPack.

In the new AWS integration, topology data is collected using StackState Agent V2. Within StackState, each installed AWS StackPack instance can now be used to collect data from all regions in a single account.

## Migrate from AWS \(Legacy\)

The best way to start using the new AWS integration is to migrate one AWS account at a time. In the new AWS integration, data for all regions associated with an account can be gathered by one StackPack instance. This means that one AWS StackPack instance can replace a number of AWS \(Legacy\) StackPack instances.

To migrate AWS accounts from the AWS \(Legacy\) StackPack to the new AWS StackPack:

1. Install [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) on a machine that can connect to both AWS and StackState.
2. For each region that you will migrate, [deploy an AWS CloudFormation stack](aws.md#deploy-the-aws-cloudformation-stack).
3. For the account to be migrated, [install an AWS StackPack instance](aws.md#install-the-aws-stackpack).
4. Configure the [StackState Agent V2 AWS check](aws.md#configure-the-aws-check) with the `role_arn` and the `regions` associated with the account.
5. For the account and regions being migrated, [uninstall all related instances of the AWS \(Legacy\) StackPack](aws-legacy.md#uninstall).
6. [Restart StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) to apply the configuration changes and enable the updated AWS check.
7. Once the Agent has restarted, wait for data to be collected from AWS and sent to StackState.
8. Repeat steps 2 to 7 for each account you want to migrate.

## Labels in StackState

During migration, topology data from the new AWS integration and the AWS \(Legacy\) integration can be identified by the labels attached to components in StackState:

| Label | Integration |
| :--- | :--- |
| `stackpack:aws-v2` | New AWS integration |
| `stackpack:aws` | AWS \(Legacy\) integration |

