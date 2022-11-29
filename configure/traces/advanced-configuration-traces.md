---
description: StackState Self-hosted v5.1.x 
---

# Configure traces

Traces can be viewed in the [Traces Perspective](../../use/stackstate-ui/perspectives/traces-perspective.md) screen in the StackState UI. To enable tracing, you first need to install the StackState Agent V2 StackPack and configure one or more tracing integrations, see [how to set up traces](set-up-traces.md). This page describes how to override the default tracing configuration and hide traces from the StackState UI.

{% hint style="info" %}
**Note that it isn't advised to change the default configuration for tracing.**
{% endhint %}

## Retention limits

{% hint style="info" %}
It isn't advised to change the default settings for retention!
{% endhint %}

Retention limits specify the index size of StackState and how long data is stored. Changing the default value here can lead to reduced stability and may cause trace and topology data to go out of sync.

If required, overrides to the default retention limits can be placed in the file `etc/kafka-to-es/application.conf`:

```text
stackstate.kafkaTraceToES.elasticsearch.index.splittingStrategy = "days" // defines the unit of time for which data is retained
stackstate.kafkaTraceToES.elasticsearch.index.maxIndicesRetained = 8 // defines the total number of time units to be retained. For example, 8 days
```

Restart the component for changes to take effect.

For more details, see [how to configure the StackState metrics, events and traces data store](/setup/data-management/data_retention.md#retention-of-events-metrics-and-traces).

## Rate limits

{% hint style="info" %}
It isn't advised to change the default settings for rate limits!
{% endhint %}

If required, overrides to the default rate limits can be placed in the file `etc/stackstate-receiver/application.conf`:

```text
stackstate.processAgent.tracesVolumeLimit.capacity = 256 MiB // data volume quota per time unit
stackstate.processAgent.tracesVolumeLimit.period = 1 hour // quota time unit
```

Restart the component for changes to take effect.

## Turn off tracing

Tracing cannot be turned off in StackState. If required, you can hide traces from the StackState UI in the file `etc/application_stackstate.conf` by setting:

```text
stackstate.webUIConfig.featureFlags.enableTraces = false
```

Restart the component for changes to take effect.

