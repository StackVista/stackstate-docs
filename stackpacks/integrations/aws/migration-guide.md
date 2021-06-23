# Migration guide

## Overview

The new AWS integration available from StackState v4.4 is an entirely new StackPack that replaces the old AWS (Legacy) integration. With the release of the new AWS integration, the AWS (Legacy) integration has been deprecated. It is advised that you migrate your StackState AWS integration to use the new AWS StackPack.

The new AWS integration collects topology data using StackState Agent V2. In StackState, each installed StackPack instance can be used to collect data from all regions in one account.

## Migrate from AWS (Legacy)

The best way to start using the new AWS integration is to migrate one account at a time. In the new AWS integration, data for all regions associated with an account can be gathered by one StackPack instance. In the AWS (Legacy) integration a separate StackPack instance was required for each region.

Topology data from the new AWS integration and the AWS (Legacy) integration can be identified by the labels attached:

| Label              | Integration              |
| :----------------- | :----------------------- |
| `stackpack:aws-v2` | New AWS integration      |
| `stackpack:aws`    | AWS (Legacy) integration |

To migrate from the AWS (Legacy) StackPack to the new AWS StackPack:

1. Install [StackState Agent V2](/stackpacks/integrations/agent.md) on a machine that can connect to both AWS and StackState.
2. For the region you will migrate, [deploy an AWS CloudFormation stack](aws.md#deploy-aws-cloudformation-stack).
3. For the account you will migrate, [install an AWS StackPack instance](aws.md#install-the-aws-stackpack).
4. Configure the StackState Agent V2 AWS check with the `role_urn` and the `regions` associated with the account.
5. For the account and regions being migrated, [uninstall all related instances of the AWS (Legacy) StackPack](/stackpacks/integrations/aws/aws-legacy.md#uninstall).
6. [Restart StackState Agent V2](/stackpacks/integrations/agent.md#start--stop--restart-the-stackstate-agent) to apply the configuration changes and enable the updated AWS check.
7. Once the Agent has restarted, wait for data to be collected from AWS and sent to StackState.
8. Repeat steps 2 to 7 for each account you want to migrate.