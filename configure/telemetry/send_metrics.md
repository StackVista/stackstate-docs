---
description: Rancher Observability Self-hosted v5.1.x 
---

# Push metrics to Rancher Observability over HTTP

## Overview

Rancher Observability can either pull metrics from a data source or can receive pushed metrics. Pushed metrics are stored by Rancher Observability, while pulled metrics aren't. Pushed metrics are stored for the duration of the configured retention period. This page describes how metrics can be pushed.

There are several ways to send metrics to Rancher Observability. A large number of [integrations](../../stackpacks/integrations/) are provided out of the box that may help you get started. If there is no out of the box integration, you can send metrics to Rancher Observability using either HTTP or the [Rancher Observability `stac` CLI](/setup/cli/cli-stac.md).

## Rancher Observability Receiver API

The Rancher Observability Receiver API accepts topology, metrics, events and health data in a common JSON object. The default location for the receiver API is the `<STACKSTATE_RECEIVER_API_ADDRESS>`, constructed using the `<STACKSTATE_BASE_URL>` and <`STACKSTATE_RECEIVER_API_KEY>`.

{% tabs %}
{% tab title="Kubernetes" %}
The `<STACKSTATE_RECEIVER_API_ADDRESS>` for Rancher Observability deployed on Kubernetes or OpenShift is:

```text
https://<STACKSTATE_BASE_URL>/receiver/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during Rancher Observability installation, for details see [Kubernetes install - configuration parameters](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}

The `<STACKSTATE_RECEIVER_API_ADDRESS>` for Rancher Observability deployed on Linux is:

```text
https://<STACKSTATE_BASE_URL>:<STACKSTATE_RECEIVER_PORT>/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during Rancher Observability installation, for details see [Linux install - configuration parameters](/setup/install-stackstate/linux/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

## Common JSON object

Topology, metrics, events and health data are sent to the receiver API via HTTP POST. There is a common JSON object used for all messages. One message can contain multiple metrics and multiple events.

```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection in seconds
  "events": {}, // see the section on "events", below
  "internalHostname": "local.test", // the host sending this data
  "metrics": [], // see the section on "metrics", below
  "service_checks": [],
  "topologies": [], // used for sending topology data
  "health": // used for sending health data
}
```

{% hint style="info" %}
Depending on your Rancher Observability configuration, received metrics that are too old will be ignored.
{% endhint %}

## JSON property: "metrics"

Metrics can be sent to the Rancher Observability Receiver API using the `"metrics"` property of the [common JSON object](send_metrics.md#common-json-object).

{% tabs %}
{% tab title="Example metric JSON" %}
```javascript
[
  "test.metric",
  1548857152,
  10.0,
  {
    "hostname": "local.test",
    "type": "gauge",
    "tags": [ 
      "tag_key1:tag_value1",
      "tag_key2:tag_value2"
    ]
  }
]
```
{% endtab %}
{% endtabs %}

Every metric has the following details:

* The metric name. You can also [specify a unit type](/use/metrics/add-telemetry-to-element.md#units-of-measurement) here. Note that the metric name must not start with any of the following prefixes: `host`, `labels`, `name`, `tags` , `timeReceived`, `timestamp`, `tags` or `values`. In the example above, the metric name is `test.metric`.
* The UTC timestamp of the metric expressed in epoch seconds.
* The value of the metric (double). In the example above, the value is `10.0`.
* **hostname** - The host this metric is from.
* **type** - The type of metric. Can be `gauge`, `count`, `rate`, `counter` or `raw`.
* **tags** - Optional.  A list of key/value tags to associate with the metric.

The `timestamp` and `value` are used to plot the metric as a time series. The `name` and `tags` can be used to define a metric stream in Rancher Observability.

## Send metrics to Rancher Observability

Multiple metrics can be sent in one JSON message via HTTP POST to the [Rancher Observability Receiver API address](#stackstate-receiver-api). For example:

{% tabs %}
{% tab title="curl" %}
```javascript
curl -X POST \
 'https://<STACKSTATE_RECEIVER_API_ADDRESS> \
 -H 'Content-Type: application/json' \
 -d '{
  "collection_timestamp": 1548857167,
  "internalHostname": "local.test",
  "metrics": [
    [
      "test.metric",
      1548857152,
      10.0,
      {
        "hostname": "local.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "type": "gauge"
      }
    ],
    [
      "test.metric",
      1548857167,
      10.0,
      {
        "hostname": "local.test",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
        ],
        "type": "gauge"
      }
    ]
  ]
}'
```
{% endtab %}
{% endtabs %}

You can also send metrics to Rancher Observability using the `stac` CLI `metric send` command.

## See also

* [Rancher Observability identifiers](../topology/identifiers.md)
* [Metrics Perspective](../../use/stackstate-ui/perspectives/metrics-perspective.md)

