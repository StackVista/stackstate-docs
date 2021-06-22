# Migration guide

## Overview

The new AWS integration available from StackState v4.4 is an entirely new StackPack that replaces the old AWS (Legacy) integration. With the release of the new AWS integration, the AWS (Legacy) integration has been deprecated. It is advised that you migrate your StackState AWS integration to use the new AWS StackPack.

## Migrate from AWS (Legacy)



When you migrate to the AWS integration, topology history and health state for AWS (Legacy) instances will be lost. Metrics are fetched directly from CloudWatch and will still be available.
{% endhint %}

The new AWS integration has been rebuilt from the ground up. This means that it is not possible to migrate an existing AWS (Legacy) integration to the new AWS integration.

To start using the new AWS integration with your AWS instance, the AWS (Legacy) StackPack must first be removed. It is possible to run the AWS (Legacy) StackPack and the new AWS StackPack side by side, however, this configuration is not supported and will likely not be available in the next major StackState release.

You can distinguish topology from the new AWS integration and the AWS (Legacy) integration by the labels attached:

| Label              | Integration              |
| :----------------- | :----------------------- |
| `stackpack:aws-v2` | New AWS integration      |
| `stackpack:aws`    | AWS (Legacy) integration |

Read how to [uninstall an existing AWS (Legacy) integration](/stackpacks/integrations/aws/aws-legacy.mdy.md#uninstall).