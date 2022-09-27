---
description: StackState Self-hosted v5.1.x 
---

# OpenMetrics

## Overview

StackState Agent V2 can be configured to retrieve metrics from an OpenMetrics endpoint and push these to StackState.

OpenMetrics is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Setup

### Installation

The OpenMetrics check is included in the [Agent V2 StackPack](/stackpacks/integrations/agent.md).

### Configuration

To enable the OpenMetrics integration and begin collecting metrics data from an OpenMetrics endpoint, the OpenMetrics check must be configured on StackState Agent V2. The check configuration provides all details required for the Agent to connect to your OpenMetrics endpoint and retrieve the available metrics.

{% tabs %}
{% tab title="Kubernetes, OpenShift" %}

1. Deploy the Agent on your Kubernetes or OpenShift cluster.
2. Add the annotations below when launching a pod that exposes metrics via an OpenMetrics endpoint. Add the following:
   - **<CONTAINER_NAME>** - the name of the container that exposes the OpenMetrics. It is possible to process multiple endpoints in a single pod (that's why there is a list in the JSON).
   - **prometheus_url** - the path (often just `metrics`) and port at which the OpenMetrics endpoint is exposed.
   - **namespace** - all metrics collected here will get this as a dot-separated prefix.
   - **metrics** - use `["*"]` to collect all available metrics. It is also possible to specify a list of metrics to be fetched. This should either be a string representing the metric name or a mapping to rename the metric`<EXPOSED_METRIC>:<SENT_METRIC>`
      ```yaml
      ...
      metadata:
        annotations:
          ad.stackstate.com/<CONTAINER_NAME>.check_names: '["openmetrics"]'
          ad.stackstate.com/<CONTAINER_NAME>.init_configs: '[{}]'
          ad.stackstate.com/<CONTAINER_NAME>.instances: |
           `[ 
             {
               "prometheus_url": "http://%%host%%:<METRICS_PORT>/<METRICS_PATH>",
               "namespace": "<METRICS_NAMESPACE>", 
               "metrics": ["*"] 
             } 
           ]'
      ...
      # This already exists in the pod spec, the container name needs to match the container that is exposing the openmetrics endpoint
      spec:
        containers:
         - name: <CONTAINER_NAME>
      ...
      ```
3. You can also add optional configuration and filters:
   - **prometheus_metrics_prefix** - prefix to add to exposed OpenMetrics metrics.
   - **health_service_check** - send a service check `<NAMESPACE>.prometheus.health` reporting the health of the OpenMetrics endpoint. Default `true`.
   - **label_to_hostname** - override the hostname with the value of one label.
   - **label_joins** - target a metric and retrieve it's label via a 1:1 mapping
   - **labels_mapper** - rename labels. Format is `<LABEL_TO_RENAME>: <NEW_LABEL_NAME>`.
   - **type_overrides** - override a type in the OpenMetrics the payload or type an untyped metric (these would be ignored by default). Supported `<METRIC_TYPE>` are `gauge`, `count` and `rate`. Format is `<METRIC_NAME>: <METRIC_TYPE>`.
   - **tags** - list of tags to attach to every metric, event and service check emitted by this integration.
   - **send_histograms_buckets** - send the histograms bucket. Default `true`.
   - **send_monotonic_counter** - set to `true` to convert counters to a rate (note that two runs are required to produce the first result). Set to `false` to send counters as a monotonic counter. Default `true`.
   - **exclude_labels** - list of labels to be excluded.
   - **prometheus_timeout** - set a timeout for the OpenMetrics query.
   - **ssl_cert** - If your OpenMetrics endpoint is secured, enter the path to the certificate and specify the private key in the `ssl_private_key` parameter, or provide the path to a file containing both the certificate and the private key.
   - **ssl_private_key** - required if the certificate linked in `ssl_cert` does not include the private key. Note that the private key to your local certificate must be unencrypted.
   - **ssl_ca_cert** - the path to the trusted CA used for generating custom certificates.
   - **extra_headers** - a list of additional HTTP headers to send in queries to the OpenMetrics endpoint. Can be combined with autodiscovery template variables. For example, `"Authorization: Bearer %%env_TOKEN%%"`.
4. Wait for the Agent to collect data from the OpenMetrics endpoint and send it to StackState.

{% endtab %}
{% tab title="Docker, Linux, Windows" %}

{% hint style="info" %}
Example OpenMetrics Agent check configuration file:  
[openmetrics/conf.yaml.example \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/openmetrics/stackstate_checks/openmetrics/data/conf.yaml.example)
{% endhint %}

1. Edit the StackState Agent V2 configuration file `/etc/stackstate-agent/conf.d/openmetrics.d/conf.yaml` to include details of the OpenMetrics endpoint and the metrics to be retrieved.
   - **prometheus_url** - the URL exposing metrics in the OpenMetrics format
   - **namespace** - the namespace to be prepended to all metrics.
   - **metrics** - a list of metrics to be fetched from the OpenMetrics endpoint at `prometheus_url`. Either a string representing the metric name or a mapping to rename the metric`<EXPOSED_METRIC>:<SENT_METRIC>`. This list should contain at least one metric.
    ```yaml
    init_config:
      
    instances:
      - prometheus_url: <OPENMETRICS_ENDOINT>
        namespace: "service"
        metrics:
          - processor: cpu
          - memory: mem
          - io
      #  prometheus_metrics_prefix: <PREFIX>_
      #  health_service_check: true
      #  label_to_hostname: <LABEL>
      #  label_joins:
      #    target_metric:
      #      label_to_match: <MATCHED_LABEL>
      #      labels_to_get:
      #        - <EXTRA_LABEL_1>
      #        - <EXTRA_LABEL_2>
      #  labels_mapper:
      #    flavor: origin
      #  type_overrides:
      #    <METRIC_NAME>: <METRIC_TYPE>
      #  tags:
      #    - <KEY_1>:<VALUE_1>
      #    - <KEY_2>:<VALUE_2>
      #  send_histograms_buckets: true
      #  send_monotonic_counter: true
      #  exclude_labels:
      #    - timestamp
      #  prometheus_timeout: 10
      #  ssl_cert: "<CERT_PATH>"
      #  ssl_private_key: "<KEY_PATH>"
      #  ssl_ca_cert: "<CA_CERT_PATH>"
      #  extra_headers:
      #    <HEADER_NAME>: <HEADER_VALUE>
    ```
2. You can also add optional configuration and filters:
   - **prometheus_metrics_prefix** - prefix to add to exposed OpenMetrics metrics.
   - **health_service_check** - send a service check `<NAMESPACE>.prometheus.health` reporting the health of the OpenMetrics endpoint. Default `true`.
   - **label_to_hostname** - override the hostname with the value of one label.
   - **label_joins** - target a metric and retrieve it's label via a 1:1 mapping
   - **labels_mapper** - rename labels. Format is `<LABEL_TO_RENAME>: <NEW_LABEL_NAME>`.
   - **type_overrides** - override a type in the OpenMetrics payload or type an untyped metric (these would be ignored by default). Supported `<METRIC_TYPE>` are `gauge`, `count` and `rate`.
   - **tags** - list of tags to attach to every metric, event and service check emitted by this integration.
   - **send_histograms_buckets** - send the histograms bucket. Default `true`.
   - **send_monotonic_counter** - set to `true` to convert counters to a rate (note that two runs are required to produce the first result). Set to `false` to send counters as a monotonic counter. Default `true`.
   - **exclude_labels** - list of labels to be excluded.
   - **prometheus_timeout** - set a timeout for the OpenMetrics query.
   - **ssl_cert** - If your OpenMetrics endpoint is secured, enter the path to the certificate and specify the private key in the `ssl_private_key` parameter, or provide the path to a file containing both the certificate and the private key.
   - **ssl_private_key** - required if the certificate linked in `ssl_cert` does not include the private key. Note that the private key to your local certificate must be unencrypted.
   - **ssl_ca_cert** - the path to the trusted CA used for generating custom certificates.
   - **extra_headers** - a list of additional HTTP headers to send in queries to the OpenMetrics endpoint. Can be combined with autodiscovery template variables. For example, `"Authorization: Bearer %%env_TOKEN%%"`.
3. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deployment) to apply the configuration changes.
4. Once the Agent has restarted, wait for the Agent to collect data from the OpenMetrics endpoint and send it to StackState.

{% endtab %}
{% endtabs %}

### Validation

{% tabs %}
{% tab title="Kubernetes, OpenShift" %}
Follow the instructions on the Kubernetes Agent page to [track the status of the OpenMetrics check](/setup/agent/kubernetes.md#agent-check-status)
{% endtab %}
{% tab title="Docker, Linux, Windows" %}
Run the Agent status subcommand and look for `openmetrics` under the `Checks` section.
{% endtab %}
{% endtabs %}

## Data collected

### Metrics

By default, all metrics are retrieved from the specified OpenMetrics endpoint and available in the **StackState multi metrics** data source. To optimize performance, a maximum of 2000 metrics will be retrieved. If the check is attempting to retrieve more than 2000 metrics, add a `metrics` filter to the [configuration](#configuration) to ensure that all important metrics can be retrieved within the limit.

Retrieved metrics will not automatically be mapped to topology elements. They can be browsed using the [telemetry inspector](/use/metrics/browse-telemetry.md) or added to a component as a telemetry stream. Select the data source **StackState Multi Metrics** and type the configured `namespace` in the **Select** box to get a full list of all available metrics. 

![Inspect OpenMetrics telemetry](/.gitbook/assets/v51_openmetrics_stream.png)

### Events

The OpenMetrics integration does not retrieve any events data.

### Traces

The OpenMetrics integration does not retrieve trace data.

## See also

* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md)