---
description: StackState Self-hosted v5.1.x
---

# Data retention

## Overview

StackState imposes data retention limits to save storage space and improve performance. You can configure the data retention period to provide a balance between the amount of data stored, StackState performance, and data availability.

## Retention of topology graph data

By default, topology graph data will be retained for 8 days. This works in a way that the latest state of topology graph will always be retained; only history older than 8 days will be removed. You can check and alter the configured retention period this using the StackState CLI.

{% tabs %}
{% tab title="CLI: sts" %}
{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```shell
$ sts graph retention
```

{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

```shell
# Check the current retention period
$ stac graph retention get-window
```
{% endtab %}
{% endtabs %}

In some cases, it may be useful to keep historical data for more than eight days.

{% tabs %}
{% tab title="CLI: sts" %}
{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```shell
$ sts graph retention --set 10d
```

\(note that the duration can be specified as a duration string\)
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

```shell
# Set the configured retention period to 10 days
$ stac graph retention set-window --window 864000000
```

\(note that time value is provided in milliseconds - 10 days equals 864000000 milliseconds\)
{% endtab %}
{% endtabs %}

Note that by adding more time to the data retention period, the amount of data stored is also going to grow and need more storage space. This may also affect the performance of the Views.

After the new retention window is applied, you can schedule a new removal with this command:

{% tabs %}
{% tab title="CLI: sts" %}
{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```shell
$ sts graph retenstion --set 10d --schedule-removal
```

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}

```shell
# Schedule a new removal
$ stac graph retention set-window --schedule-removal
```
{% endtab %}
{% endtabs %}

After changing the retention period to a smaller window, you may end up with some data that is already expired and will wait there until the next scheduled cleanup. To schedule an additional removal of expired data, use the following command:

Note that this may take some time to have an effect.

{% tabs %}
{% tab title="CLI: sts" %}

{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```shell
$ sts graph delete-expired-data
```
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}


```shell
# Schedule removal of expired data
$ stac graph retention remove-expired-data
```

{% endtab %}
{% endtabs %}

However, if you would like to perform data deletion without having to wait for an additional scheduled cleanup, you can use `--immediately` argument:

{% tabs %}
{% tab title="CLI: sts" %}

{% hint style="info" %}
From StackState v5.0, the old `sts` CLI has been renamed to `stac` and there is a new `sts` CLI. The command(s) provided here are for use with the new `sts` CLI.

➡️ [Check which version of the `sts` CLI you are running](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endhint %}

```shell
$ sts graph delete-expired-data --immediate
```
{% endtab %}
{% tab title="CLI: stac (deprecated)" %}
{% hint style="warning" %}
**From StackState v5.0, the old `sts` CLI is called `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")
{% endhint %}


```shell
# Remove expired data immediately
$ stac graph retention remove-expired-data --immediately
```
{% endtab %}
{% endtabs %}

## Retention of events, metrics and traces

### StackState data store

If you are using the event/metrics/traces store provided with StackState, your data will by default be retained for 30 days. In most cases, the default settings will be sufficient to store all indices for this amount of time.

#### Configure disk space for Elasticsearch

In some circumstances it may be necessary to adjust the disk space available to Elasticsearch and how it's allocated to each index group, for example if you anticipate a lot of data to arrive for a specific index.

{% tabs %}
{% tab title="Kubernetes" %}
The settings can be adjusted by using environment variables to [override the default configuration](../install-stackstate/kubernetes_openshift/customize_config.md#environment-variables) of the parameters described below.

Note that `elasticsearchDiskSpaceMB` will scale automatically based on the disk space available to Elasticsearch in Kubernetes.
{% endtab %}

{% tab title="Linux" %}
The settings can be adjusted in the file `/opt/stackstate/etc/kafka-to-es/application.conf` using the parameters described below.
{% endtab %}
{% endtabs %}

| Parameter | Default | Description |
| :--- | :--- | :--- |
| `elasticsearchDiskSpaceMB` | `400000` | The total disk space assigned to Elasticsearch in MB. The default setting is the recommended disk space for a StackState production setup \(400GB\). |
| `splittingStrategy` | `"days"` | The frequency of creating new indices. Can be one of "none", "hours", "days", "months" or "years". If "none" is specified, only one index will be used. |
| `maxIndicesRetained` | `30` | The number of indices that will be retained in each index group. Together with the `splittingStrategy` governs how long historical data will be kept in Elasticsearch. |
| `diskSpaceWeight` | Varies per index group | Defines the share of disk space an index will get based on the total `elasticsearchDiskSpaceMB`. If set to `0` then no disk space will be allocated to the index. See the [disk space weight examples](data_retention.md#disk-space-weight-examples) below. |
| `replicas` | Linux: `0` Kubernetes: `1` | The number of nodes that a single piece of data should be available on. Use for redundancy/high availability when more than one Elasticsearch node is available. |

{% tabs %}
{% tab title="Example application.conf" %}
```json
stackstate {
  ...

  // Total size of disk assigned to Elasticsearch in MB
  elasticsearchDiskSpaceMB = 400000

  ...

  // For each index group:
  // kafkaMetricsToES - the sts_metrics index
  // kafkaMultiMetricsToES - the sts_multi_metrics index
  // kafkaGenericEventsToES - the sts_generic_events index
  // kafkaTopologyEventsToES - the sts_topology_events index
  // kafkaStateEventsToES - the sts_state_events index
  // kafkaStsEventsToES - the sts_events index
  // kafkaTraceToES - the sts_trace_events index

  kafkaMultiMetricsToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 1
      }
    ...
    }
  }
  ...
}
```
{% endtab %}
{% endtabs %}

#### Disk space weight examples

Use the `diskSpaceWeight` configuration parameter to adjust how available disk space is allocated across Elasticsearch index groups. This is helpful if, for example, you expect a lot of data to arrive in a single index. Below are some examples of disk space weight configuration.

{% hint style="info" %}
Note that increasing the total limit or the `diskSpaceWeight` will increase the amount of data that can be stored in each index. If the total value of metrics received is too high, it could affect telemetry stream performance due to increased metrics processing time.
{% endhint %}

**Allocate no disk space to an index group**
Setting `diskSpaceWeight` to 0 will result in no disk space being allocated to an index group. For example, if you are not going to use traces, then you can stop reserving disk space for this index group and make it available to other index groups with the setting:

```text
 kafkaTraceToES.elasticsearch.index.diskSpaceWeight = 0
```

**Distribute disk space unevenly across index groups**
The available disk space \(the configured `elasticsearchDiskSpaceMB`\) will be allocated to index groups proportionally based on their configured `diskSpaceWeight`. Disk space will be allocated to each index group according to the formula below, this will then be shared between the indices in the index group:

```text
# Total disk space allocated to an index group
index_group_disk_space = (elasticsearchdiskSpaceMB * diskSpaceWeight / sum(diskSpaceWeights)
```

For example, with `elasticsearchDiskSpaceMB = 300000`, disk space would be allocated to the index groups and indexes be as follows:

| Parameter | Index group disk space |
| :--- | :--- |
| `kafkaMetricsToES.elasticsearch.index {` `diskSpaceWeight = 0` `maxIndicesRetained = 20` `}` | 0MB |
| `kafkaMultiMetricsToES.elasticsearch.index {` `diskSpaceWeight = 1` `maxIndicesRetained = 20` `}` | 20,000MB or 300,000\*1/15 |
| `kafkaGenericEventsToES.elasticsearch.index{` `diskSpaceWeight = 2` `maxIndicesRetained = 20` `}` | 40,000MB or 300,000\*2/15 |
| `kafkaTopologyEventsToES.elasticsearch.index{` `diskSpaceWeight = 3` `maxIndicesRetained = 20` `}` | 60,000MB or 300,000\*3/15 |
| `kafkaStateEventsToES.elasticsearch.index{` `diskSpaceWeight = 4` `maxIndicesRetained = 20` `}` | 80,000MB or 300,000\*4/15 |
| `kafkaStsEventsToES.elasticsearch.index{` `diskSpaceWeight = 5` `maxIndicesRetained = 20` `}` | 100000MB or 300,000\*5/15 |
| `kafkaTraceToES.elasticsearch.index{` `diskSpaceWeight = 0` `maxIndicesRetained = 20` `}` | 0MB |

### External data store

If you have configured your own data source to be accessed by StackState, the retention policy is determined by the metric/event store that you have connected.

