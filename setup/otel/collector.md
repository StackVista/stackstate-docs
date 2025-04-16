---
description: SUSE Observability
---

# Open Telemetry Collector

The OpenTelemetry Collector offers a vendor-agnostic implementation to receive, process and export telemetry data. Applications instrumented with Open Telemetry SDKs can use the collector to send telemetry data to SUSE Observability (traces and metrics). 

Your applications, when set up with OpenTelemetry SDKs, can use the collector to send telemetry data, like traces and metrics, to SUSE Observability or another collector (for further processing). The collector is set up to receive this data by default via OTLP, the native open telemetry protocol. It can also receive data in other formats provided by other instrumentation SDKs like Jaeger and Zipkin for traces, and Influx and Prometheus for metrics.

The collector is running close to your application, in the same Kubernetes cluster, on the same virtual machine, etc. This allows SDKs to quickly offload data to the collector, which can then do transformations, batching and filtering. It can be used by multiple applications and allows for easy changes to your data processing pipeline.

For installation guides use the different [getting started guides](./getting-started/). The getting started guides give provide a basic collector configuration to get started, but over time you'll want to customize it to your needs and add additional receivers, processors, and exporters to customize your ingestion pipeline to your needs.

## Configuration

The collector configuration defines pipelines for processing the different telemetry signals. The components in the processing pipeline can be divided in several categories, and each component has its own configuration. Here we'll give an overview of the different configuration sections and how to use them.

### Receivers

Receivers accept telemetry data from instrumented applications, here via OTLP:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
```

There are many more receivers that accept data via other protocols, for example Zipkin traces, or that actively collect data from various sources, for example:
* Host metrics
* Kubernetes metrics
* Prometheus metrics (OpenMetrics)
* Databases

Some receivers support all 3 signals (traces, metrics, logs), others support only 1 or 2, for example the Prometheus receiver can only collect metrics. The opentelemetry-collector-contrib repository has [all receivers](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver) with documentation on their configuration.

### Processors

The data from the receivers can be transformed or filtered by processors.

```yaml
processors:
  batch: {}
```

The batch processor batches all 3 signals, improving compression and reducing the number of outgoing connections. The opentelemetry-collector-contrib repository has [all processors](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor) with documentation on their configuration.

### Exporters

To send data to the SUSE Observability backend the collector has exporters. There are exporters for different protocols, push- or pull-based, and different backends. Using the OTLP protocols it is also possible to use another collector as a destination for additional processing.

```yaml
exporters:
  # The gRPC otlp exporter
  otlp/suse-observability:
    auth:
      authenticator: bearertokenauth
    # Put in your own otlp endpoint
    endpoint: <otlp-suse-observability-endpoint>
    # Use snappy compression, if no compression specified the data will be uncompressed
    compression: snappy
```

The SUSE Observability exporter requires authentication using an api key, to configure that an [authentication extension](#extensions) is used. The opentelemetry-collector-contrib repository has [all exporters](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter) with documentation on their configuration.

If the gRPC exporter doesn't work for you (see also [troubleshooting](./troubleshooting.md#some-proxies-and-firewalls-dont-work-well-with-grpc)), you can switch to the, slightly less efficient, OTLP over HTTP protocol by using the `otlphttp` exporter instead. Replace all references to `otlp/suse-observability` with `otlphttp/suse-observability` (don't forget the references in the pipelines) and make sure to update the exporter config to:

```yaml
exporters:
  # The gRPC otlp exporter
  otlphttp/suse-observability:
    auth:
      authenticator: bearertokenauth
    # Put in your own otlp HTTP endpoint
    endpoint: <otlp-http-suse-observability-endpoint>
    # Use snappy compression, if no compression specified the data will be uncompressed
    compression: snappy
```

{% hint type="warning" %}
The OTLP HTTP endpoint for SUSE Observability is different from the OTLP endpoint. Use the [OTLP APIs](./otlp-apis.md) to find the correct URL.
{% endhint %}

### Service pipeline

For each telemetry signal a separate pipeline is configured. The pipelines are configured in the `service.pipeline` section and define which receivers, processors and exporters should be used in which order. Before using a component in the pipeline it must first be defined in its configuration section. The `batch` processor, for example, doesn't have any configuration but still has to be declared in the `processors` section. Components that are configured but are not included in a pipeline will not be active at all.

```yaml
service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, resource, batch]
      exporters: [debug, spanmetrics, otlp/suse-observability]
    metrics:
      receivers: [otlp, spanmetrics, prometheus]
      processors: [memory_limiter, resource, batch]
      exporters: [debug, otlp/suse-observability]
```

### Extensions

Extensions are not used directly in pipelines for processing data but extend the capabilities of the collector in other ways. For SUSE Observability it is used to configure the authentication using an api key. Extensions must be defined in a configuration section before they can be used. Similar to the pipeline components an extension is only active when it is enabled in the `service.extensions` section.

```yaml
extensions:
  bearertokenauth:
    scheme: SUSEObservability
    token: "${env:API_KEY}"
service:
  extensions: [ bearertokenauth ]
```

The opentelemetry-collector-contr ib repository has [all extensions](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension) with documentation on their configuration.

## Transforming telemetry

There are many processors in the [opentelemetry-collector-contrib repository](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor). Here we try to give an overview of commonly used processors and their capabilities. For more details and many more processors use the [opentelemetry-collector-contrib repository](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor).

### Filtering

Some instrumentations or applications may generate a lot of telemetry data that is just noisy and unneeded for your use-case. The [filter processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/filterprocessor) can be used to drop the data that you don't need in the collector, to avoid sending the data to SUSE Observability. For example to drop all the data of 1 specific service:

```yaml
processors:
  filter/ignore-service1:
    error_mode: ignore
    traces:
      span:
        - resource.attributes["service.name"] == "service1"
```

The filter processor uses the [Open Telemetry Transformation Lanuage (OTTL)](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/ottl/README.md) to define the filters.

### Adding, modifying or deleting attributes

The [attributes processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/attributesprocessor) can change attributes of spans, logs or metrics. 

```yaml
processors:
  attributes/accountid:
    actions:
      - key: account_id
        value: 2245
        action: insert
```

The [resource attributes processor]() can modify attributes of a [resource](concepts.md#resources). For example to add a Kubernetes cluster name to every resource:

```yaml
  processors:
    resource/add-k8s-cluster:
      attributes:
      - key: k8s.cluster.name
        action: upsert
        value: my-k8s-cluster
```

For changing metric names and other metric specific information there is also the [metrics transformer](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/metricstransformprocessor).

### Transformations

The [transform processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/transformprocessor) can be used to, for example, set a span status:

```yaml
processors:
  transform:
    error_mode: ignore
    trace_statements:
      - set(span.status.code, STATUS_CODE_OK) where span.attributes["http.request.status_code"] == 400
```

It supports many more transformations, like modifying the span name, converting metric types or modifying log events. See it's [readme](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/transformprocessor) for all the possibilities. It uses the [Open Telemetry Transformation Lanuage (OTTL)](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/ottl/README.md) to define the filters.

## Scrub sensistive data

The collector is the ideal place to remove or obfuscate sensitive data, because it sits right between your applications and SUSE Observability and has processors to [filter and transform your data](#transforming-telemetry). Next to the filtering and transformation capabilities already discussed there is also a [redaction processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/redactionprocessor) available that can mask attribute values that match a block list. It can also remove attributes that don't match a specified list of allowed attributes, however using this can quickly result in dropping most attributes resulting in very limited observability capabilities. Note that it does not process resource attributes.

An example that only masks specific attributes and/or values:

```yaml
processors:
  redaction:
    allow_all_keys: true
    # attributes matching the regexes on the list are masked.
    blocked_key_patterns:
      - ".*token.*"
      - ".*api_key.*"
    blocked_values: # Regular expressions for blocking values of allowed span attributes
      - '4[0-9]{12}(?:[0-9]{3})?' # Visa credit card number
      - '(5[1-5][0-9]{14})' # MasterCard number
    summary: debug
```

## Trying out the collector

The getting started guides show how to deploy the collector to Kubernetes or using Linux packages for a production ready setup. It is also possible to run it, for example for tests, directly as a docker container to try it out:

```bash
docker run \
  -p 127.0.0.1:4317:4317 \
  -p 127.0.0.1:4318:4318 \
  -v $(pwd)/config.yaml:/etc/otelcol-contrib/config.yaml \
  otel/opentelemetry-collector-contrib:latest
```

This uses the collector contrib image which includes all contributed components (receivers, processors, etc.). A smaller, more limited version of the image is also available, but it has only a very limited set of components available: 

```bash
docker run \
  -p 127.0.0.1:4317:4317 \
  -p 127.0.0.1:4318:4318 \
  -v $(pwd)/config.yaml:/etc/otelcol/config.yaml \
  otel/opentelemetry-collector:latest
```

Note that the Kubernetes installation defaults to the Kubernetes distribution of the collector image, `otel/opentelemetry-collector-k8s`, which has more components than the basic image, but less than the contrib image. If you run into missing components with that image you can simply switch it to use the contrib image , `otel/opentelemetry-collector-contrib`, instead.

# Troubleshooting

## HTTP Requests from the exporter are too big

In some cases HTTP requests for telemetry data can become very large and may be refused by SUSE Observability . SUSE Observability has a limit of 4MB for the gRPC protocol. If you run into HTTP requests limits you can lower the requests size by changing the compression algorithm and limiting the maximum batch size.

### HTTP request compression

The getting started guides enable `snappy` compression on the collector, this is not the best compression but uses less CPU resources than `gzip`. If you removed the compression you can enable it again, or you can switch to a compression algorithm that offers a better [compression ratio](https://github.com/open-telemetry/opentelemetry-collector/blob/main/config/configgrpc/README.md#compression-comparison). The same compression types are available for gRPC and HTTP protocols.

### Max batch size

To reduce the HTTP request size can be reduced by adding configuration to the `batch` processor limiting the batch size:

```yaml
processor:
  batch: {}
    send_batch_size: 8192 # This is the default value
    send_batch_max_size: 10000 # The default is 0, meaning no max size at all
```

The batch size is defined in number of spans, metric data points, or log records (not in bytes), so you might need some experimentation to find the correct setting for your situation. For more details please refer to the [batch processor documentation](https://github.com/open-telemetry/opentelemetry-collector/blob/main/processor/batchprocessor/README.md).

# Related resources

The Open Telemetry documentation provides much more details on the configuration and alternative installation options:

- Open Telemetry Collector configuration: https://opentelemetry.io/docs/collector/configuration/
- Kubernetes installation of the collector: https://opentelemetry.io/docs/kubernetes/helm/collector/
- Using the Kubernetes operator instead of the collector Helm chart: https://opentelemetry.io/docs/kubernetes/operator/
- Open Telemetry sampling: https://opentelemetry.io/blog/2022/tail-sampling/
