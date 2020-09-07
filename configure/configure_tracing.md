# Configure tracing

Traces can be viewed in the [trace perspective](../use/perspectives/trace-perspective.md) screen in the StackState UI. To enable tracing, you first need to install the StackState Agent StackPack and configure one or more tracing integrations. See [how to set up traces](how_to_setup_traces.md). This page describes how to override the default tracing configuration and hide traces from the StackState UI.

{% hint style="info" %}
Note that it is not advised to change the default configuration for tracing.
{% endhint %}

## Retention limits

It is not advised to change the default settings for retention!

Retention limits specify the index size of StackState and how long data is stored. Changing the default value here can lead to reduced stability and may cause trace and topology data to go out of sync.

If required, overrides to the default retention limits can be placed in the file `etc/kafka-to-es/application.conf`:

```
stackstate.kafkaTraceToES.elasticsearch.index.splittingStrategy = "days" // defines the unit of time for which data is retained
stackstate.kafkaTraceToES.elasticsearch.index.maxIndicesRetained = 8 // defines the total number of time units to be retained, e.g. 8 days
```
Restart the component for changes to take affect.

## Rate limits

It is not advised to change the default settings for rate limits! These have been hand-picked to optimize stability and performance.

If required, overrides to the default rate limits can be placed in the file `etc/stackstate-receiver/application.conf`:

```
stackstate.processAgent.tracesVolumeLimit.capacity = 256 MiB // data volume quota per time unit
stackstate.processAgent.tracesVolumeLimit.period = 1 hour // quota time unit
```
Restart the component for changes to take affect.

## Turn off tracing

Tracing cannot be turned off in StackState. If required, you can hide traces from the StackState UI in the file `etc/application_stackstate.conf` by setting:

```
stackstate.webUIConfig.featureFlags.enableTraces = false
```
Restart the component for changes to take affect.
