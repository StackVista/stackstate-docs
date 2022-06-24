# Configure traces

{% hint style="warning" %}
**This page describes StackState v4.4.x.**

The StackState 4.4 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.4 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/traces/configure_tracing).
{% endhint %}

Traces can be viewed in the [Traces Perspective](../../use/stackstate-ui/perspectives/traces-perspective.md) screen in the StackState UI. To enable tracing, you first need to install the StackState Agent V2 StackPack and configure one or more tracing integrations, see [how to set up traces](how_to_setup_traces.md). This page describes how to override the default tracing configuration and hide traces from the StackState UI.

{% hint style="info" %}
Note that it is not advised to change the default configuration for tracing.
{% endhint %}

## Retention limits

It is not advised to change the default settings for retention!

Retention limits specify the index size of StackState and how long data is stored. Changing the default value here can lead to reduced stability and may cause trace and topology data to go out of sync.

If required, overrides to the default retention limits can be placed in the file `etc/kafka-to-es/application.conf`:

```text
stackstate.kafkaTraceToES.elasticsearch.index.splittingStrategy = "days" // defines the unit of time for which data is retained
stackstate.kafkaTraceToES.elasticsearch.index.maxIndicesRetained = 8 // defines the total number of time units to be retained, e.g. 8 days
```

Restart the component for changes to take affect.

For more details, see [how to configure the StackState metrics, events and traces data store](../../setup/data-management/data_retention.md#stackstate-events-metrics-and-traces-data-store).

## Rate limits

It is not advised to change the default settings for rate limits!

If required, overrides to the default rate limits can be placed in the file `etc/stackstate-receiver/application.conf`:

```text
stackstate.processAgent.tracesVolumeLimit.capacity = 256 MiB // data volume quota per time unit
stackstate.processAgent.tracesVolumeLimit.period = 1 hour // quota time unit
```

Restart the component for changes to take affect.

## Turn off tracing

Tracing cannot be turned off in StackState. If required, you can hide traces from the StackState UI in the file `etc/application_stackstate.conf` by setting:

```text
stackstate.webUIConfig.featureFlags.enableTraces = false
```

Restart the component for changes to take affect.

