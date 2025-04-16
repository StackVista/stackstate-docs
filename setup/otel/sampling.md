---
description: SUSE Observability
---

# Sampling

Sampling is used to reduce the volume of data that is exported to SUSE Observability, while compromising the quality of the telemetry data as little as possible. The main reason to apply sampling is to reduce cost (of network, storage, etc). 

If your applications generate little data there is no need for sampling and it can even hinder observability due to a lack of telemetry data. However if your application has a significant amount of traffic, for example more than 1000 spans per second, it can already make sense to apply sampling.

There are 2 main types of sampling, head sampling and tail sampling.

## Head sampling

Head sampling makes the sampling decision (whether to export the data or not) as early as possible. Therefore the decision cannot be based on the entire trace but only on the, very limited, information that is available. The otel collector has the [probabalistic sampling processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/probabilisticsamplerprocessor) which implements Consistent Probabality Sampling. The sampler is configurable and makes a sampling decision based of the trace id (useful for traces) or of a hash of an attribute (useful for logs). This ensures that all spans for a trace are always sampled or not and you will have complete traces in SUSE Observability.

The advantages of head sampling are:
* Easy to understand
* Efficient
* Simple to configure

But a down side is that it is impossible to make sampling decisions on an entire trace, for example to sample all failed traces and only a small selection of the successful traces.

To enable head sampling configure the processor and include it in the pipelines. This example samples 1 out of 4 traces based on the trace id:

```yaml
processors:
  probabilistic_sampler:
    sampling_percentage: 25
    mode: "proportional"
```

## Tail sampling

Tail sampling postpones the sampling decision until a trace is (almost) complete. This allows the tail sampler to make  based on the entire traces, for example to always sample failed traces and/or slow traces. There are many more possibilities of course. The Open Telemetry collector has a [tail sampling processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/tailsamplingprocessor) to apply tail sampling.

So the main advantage of tail sampling is the much bigger flexibility it provides in making sampling . But it comes at a price:
* Harder to configure properly and understand
* Must be stateful to store the spans for traces until a sampling decision is made
* Therefore also (a lot) more resource usage
* The sampler might not keep up and needs extra monitoring and scaling for that

To enable tail sampling configure the processor and include in the pipelines.

```yaml
processors:
  tail_sampling:
    decision_wait: 10s
    policies:
    - name: rate-limited-composite
      type: composite
      composite:
        max_total_spans_per_second: 500
        policy_order: [errors, slow-traces, rest]
        composite_sub_policy:
        - name: errors
          type: status_code
          status_code: 
            status_codes: [ ERROR ]
        - name: slow-traces
          type: latency
          latency:
            threshold_ms: 1000
        - name: rest
          type: always_sample
        rate_allocation:
        - policy: errors
          percent: 33
        - policy: slow-traces
          percent: 33
        - policy: rest
          percent: 34
```

The example samples:
* A maximum of 500 spans per second
* all spans in traces that have errors up to 33% of the maximum
* all spans in traces slower than 1 second up to 33% of the maximum
* other spans up to the maximum rate allowed

For more details on the configuration options and different policies use the [tail sampling readme](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/tailsamplingprocessor).

It his however not completely set-it-and-forget-it, if its resource usage starts growing you might want to scale out to use multiple collectors to handle the tail sampling which will then also require [routing](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/connector/routingconnector/README.md) to route traffic based on trace id.

## Sampling traces in combination with span metrics

In the getting started section the collector configuration doesn't include sampling. When adding sampling we want to be careful to keep the metrics that are calculated from traces as accurate as possible. Especially tail-sampling can result in very skewed metrics, because typically the relative amount of errors is much higher. To avoid this we split the traces pipeline into multiple parts and connect them with the forward connector. Modify the config to include the extra connector and sampling processor. And modify the pipelines as shown here:

```yaml
connectors:
  # enable the forwarder
  forward:
processors:
  # Configure the probabilistic sampler to sample 25% of the traffic
  probabilistic_sampler:
    sampling_percentage: 25
    mode: "proportional"
service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, resource]
      exporters: [forward]
    traces/spanmetrics:
      receivers: [forward]
      processors: []
      exporters: [spanmetrics]
    traces/sampling:
      receivers: [forward]
      processors: [probabilistic_sampler, batch]
      exporters: [debug, otlp/stackstate]
    metrics:
      receivers: [otlp, spanmetrics, prometheus]
      processors: [memory_limiter, resource, batch]
      exporters: [debug, otlp/stackstate]
```

The example uses the probabilistic sampler configured to sample 25% percent of the traffic. You'll likely want to tune the percentage for your situation or switch to the [tail sampler](#tail-sampling) instead. The pipeline setup is the same for the tail sampler, just replace the reference to the `probabilistic_sampler` with `tail_sampling`.
