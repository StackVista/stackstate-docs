---
description: SUSE Observability
---

# Getting Started with Open Telemetry operator on Kubernetes

Here is the setup we'll be creating, for an application that needs to be monitored:

* The monitored application / workload running in cluster A, auto-instrumented by the operator
* The Open Telemetry operator in cluster A
* A collector created by the operator
* SUSE Observability running in cluster B, or SUSE Cloud Observability

![Container instrumentation with Open Telemetry operator auto-instrumentation](/.gitbook/assets/otel/open-telemetry-kubernetes-operator.png)

## Install the operator

The Open Telemetry operator offers some extra features over the normal Kubernetes setup:
* It can auto-instrument your application pods for supported languages (Java, .NET, Python, Golang, Node.js), without having to modify the applications or docker images at all
* It can be dropped in as a replacement for the Prometheus operator and start scraping Prometheus exporter endpoints based on service and pod monitors

### Create the namespace and a secret for the API key

We'll install in the `open-telemetry` namespace and use the receiver API key generated during installation (see [here](/use/security/k8s-ingestion-api-keys.md#api-keys) where to find it):

```bash
kubectl create namespace open-telemetry
kubectl create secret generic open-telemetry-collector \
    --namespace open-telemetry \
    --from-literal=API_KEY='<suse-observability-api-key>' 
```

### Configure & Install the operator

The operator is installed with a Helm chart, so first configure the chart repository.

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Let's create a `otel-operator.yaml` file to configure the operator:

{% code title="otel-operator.yaml" lineNumbers="true" %}
```yaml
# Add image pull secret for private registries
imagePullSecrets: []
manager:
  image:
    # Uses chart.appVersion for the tag
    repository: ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator
  collectorImage:
    # find the latest collector releases at https://github.com/open-telemetry/opentelemetry-collector-releases/releases
    repository: otel/opentelemetry-collector-k8s
    tag: 0.123.0
  targetAllocatorImage:
    repository: ""
    tag: ""
  # Only needed when overriding the image repository, make sure to always specify both the image and tag:
  autoInstrumentationImage:
    java:
      repository: ""
      tag: ""
    nodejs:
      repository: ""
      tag: ""
    python:
      repository: ""
      tag: ""
    dotnet:
      repository: ""
      tag: ""
    # The Go instrumentation support in the operator is disabled by default.
    # To enable it, use the operator.autoinstrumentation.go feature gate.
    go:
      repository: ""
      tag: ""
      
admissionWebhooks:
  # A production setup should use certManager to generate the certificate, without certmanager the certificate will be generated during the Helm install
  certManager:
    enabled: false
  # The operator has validation and mutation hooks that need a certificate, with this we generate that automatically
  autoGenerateCert:
    enabled: true
```
{% endcode %}

Now install the collector, using the configuration file:

```bash
helm upgrade --install opentelemetry-operator open-telemetry/opentelemetry-operator \
  --namespace open-telemetry \
  --values otel-operator.yaml
```

This only installs the operator. Continue to install the collector and enable auto-instrumentation.

## The Open Telemetry collector

The operator manages one or more collector deployments via a Kubernetes custom resource of kind `OpenTelemetryCollector`. We'll create one using the same configuration as used in the [Kubernetes getting started guide](./getting-started-k8s.md). 

It uses the secret created earlier in the guide. Make sure to replace `<otlp-suse-observability-endpoint>` with your OTLP endpoint (see [OTLP API](../otlp-apis.md) for your endpoint) and insert the name for your Kubernetes cluster instead of `<your-cluster-name>`:

{% code title="collector.yaml" lineNumbers="true" %}
```yaml
apiVersion: opentelemetry.io/v1beta1
kind: OpenTelemetryCollector
metadata:
  name: otel-collector
spec:
  mode: deployment
  envFrom:
  - secretRef:
      name: open-telemetry-collector
  # optional service-account for pulling the collector image from a private registries
  # serviceAccount: otel-collector
  config:
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
      # Scrape the collectors own metrics
      prometheus:
        config:
          scrape_configs:
          - job_name: opentelemetry-collector
            scrape_interval: 10s
            static_configs:
            - targets:
              - ${env:MY_POD_IP}:8888
    extensions:
      health_check:
        endpoint: ${env:MY_POD_IP}:13133
      # Use the API key from the env for authentication
      bearertokenauth:
        scheme: SUSEObservability
        token: "${env:API_KEY}"
    exporters:
      debug: {}
      nop: {}
      otlp/suse-observability:
        auth:
          authenticator: bearertokenauth
        # Put in your own otlp endpoint
        endpoint: <otlp-suse-observability-endpoint>
        compression: snappy
    processors:
      memory_limiter:
        check_interval: 5s
        limit_percentage: 80
        spike_limit_percentage: 25
      batch: {}
      resource:
        attributes:
        - key: k8s.cluster.name
          action: upsert
          # Insert your own cluster name
          value: <your-cluster-name>
        - key: service.instance.id
          from_attribute: k8s.pod.uid
          action: insert
          # Use the k8s namespace also as the open telemetry namespace
        - key: service.namespace
          from_attribute: k8s.namespace.name
          action: insert
    connectors:
      # Generate metrics for spans
      spanmetrics:
        metrics_expiration: 5m
        namespace: otel_span
    service:
      extensions: [ health_check,  bearertokenauth ]
      pipelines:
        traces:
          receivers: [otlp]
          processors: [memory_limiter, resource, batch]
          exporters: [debug, spanmetrics, otlp/suse-observability]
        metrics:
          receivers: [otlp, spanmetrics, prometheus]
          processors: [memory_limiter, resource, batch]
          exporters: [debug, otlp/suse-observability]
        logs:
          receivers: [otlp]
          processors: []
          exporters: [nop]
      telemetry:
        metrics:
          address: ${env:MY_POD_IP}:8888
```
{% endcode %}

{% hint style="warning" %}
**Use the same cluster name as used for installing the SUSE Observability agent** if you also use the SUSE Observability agent with the Kubernetes stackpack. Using a different cluster name will result in an empty traces perspective for Kubernetes components and will overall make correlating information much harder for SUSE Observability and your users.
{% endhint %}

Now apply this `collector.yaml` in the `open-telemetry` namespace to deploy a collector:

```bash
kubectl apply --namespace open-telemetry -f collector.yaml
```

The collector offers a lot more configuration receivers, processors and exporters, for more details see our [collector page](../collector.md). For production usage often large amounts of spans are generated and you will want to start setting up [sampling](../sampling.md).

## Auto-instrumentation

### Configure auto-instrumentation

Now we need to tell the operator how to configure the auto instrumentation for the different languages using another custom resource, of kind `Instrumentation`. It is mainly used to configure the collector that was just deployed as the telemetry endpoint for the instrumented applications.

It can be defined in a single place and used by all pods in the cluster, but it is also possible to have a different `Instrumentation` in each namespace. We'll be doing the former here. Note that if you used a different namespace or a different name for the otel collector the endpoint in this file needs to be updated accordingly.

Create an `instrumentation.yaml`:

{% code title="instrumentation.yaml" lineNumbers="true" %}
```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: Instrumentation
metadata:
  name: otel-instrumentation
spec:
  exporter:
    # default endpoint for the instrumentation
    endpoint: http://otel-collector-collector.open-telemetry.svc.cluster.local:4317
  propagators:
    - tracecontext
    - baggage
  defaults:
    # To use the standard app.kubernetes.io/ labels for the service name, version and namespace:
    useLabelsForResourceAttributes: true
  python:
    env:
      # Python autoinstrumentation uses http/proto by default, so data must be sent to 4318 instead of 4317.
      - name: OTEL_EXPORTER_OTLP_ENDPOINT
        value: http://otel-collector-collector.open-telemetry.svc.cluster.local:4318
  dotnet:
    env:
      # Dotnet autoinstrumentation uses http/proto by default, so data must be sent to 4318 instead of 4317.
      - name: OTEL_EXPORTER_OTLP_ENDPOINT
        value: http://otel-collector-collector.open-telemetry.svc.cluster.local:4318
  go:
    env:
      # Go autoinstrumentation uses http/proto by default, so data must be sent to 4318 instead of 4317.
      - name: OTEL_EXPORTER_OTLP_ENDPOINT
        value: http://otel-collector-collector.open-telemetry.svc.cluster.local:4318
```
{% endcode %}

Now apply the `instrumentation.yaml` also in the `open-telemetry` namespace:

```bash
kubectl apply --namespace open-telemetry -f instrumentation.yaml
```

### Enable auto-instrumentation for a pod

To instruct the operator to auto-instrument your applicaction pods we need to add an annotation to the pod:
* Java: `instrumentation.opentelemetry.io/inject-java: open-telemetry/otel-instrumentation` 
* NodeJS: `instrumentation.opentelemetry.io/inject-nodejs: open-telemetry/otel-instrumentation`
* Python: `instrumentation.opentelemetry.io/inject-python: open-telemetry/otel-instrumentation`
* Go: `instrumentation.opentelemetry.io/inject-go: open-telemetry/otel-instrumentation`

Note that the value of the annotation refers to the namespace and name of the `Instrumentation` resource that we created. Other options are:

* "true" - inject and `Instrumentation` custom resource from the namespace.
* "my-instrumentation" - name of `Instrumentation` custom resource in the current namespace.
* "my-other-namespace/my-instrumentation" - namespace and name of `Instrumentation` custom resource in another namespace.
* "false" - do not inject

When a pod with one of the annotations is created the operator modifies the pod via a mutation hook:
* It adds an init container that provides the auto-instrumentation library
* It modifies the first container of the pod to load the instrumentation during start up and it adds environment variables to configure the instrumentation

If you need to customize which containers should be instrumented use the [operator documentation](https://github.com/open-telemetry/opentelemetry-operator?tab=readme-ov-file#multi-container-pods-with-multiple-instrumentations).

{% hint style="warning" %}
Go auto-instrumentation requires elevated permissions. These permissions are set automatically by the operator:

```yaml
securityContext:
  privileged: true
  runAsUser: 0
```
{% endhint %}

## View the results
Go to SUSE Observability and make sure the Open Telemetry Stackpack is installed (via the main menu -> Stackpacks). 

After a short while and if your pods are getting some traffic you should be able to find them under their service name in the Open Telemetry -> services and service instances overviews. Traces will appear in the [trace explorer](/use/traces/k8sTs-explore-traces.md) and in the [trace perspective](/use/views/k8s-traces-perspective.md) for the service and service instance components. Span metrics and language specific metrics (if available) will become available in the [metrics perspective](/use/views/k8s-metrics-perspective.md) for the components.

If you also have the Kubernetes stackpack installed the instrumented pods will also have the traces available in the [trace perspective](/use/views/k8s-traces-perspective.md).

## Next steps
You can add new charts to components, for example the service or service instance, for your application, by following [our guide](/use/metrics/k8s-add-charts.md). It is also possible to create [new monitors](/use/alerting/k8s-monitors.md) using the metrics and setup [notifications](/use/alerting/notifications/configure.md) to get notified when your application is not available or having performance issues.

The operator, the `OpenTelemetryCollector`, and the `Instrumentation` custom resource, have more options that are documented in the [readme of the operator repository](https://github.com/open-telemetry/opentelemetry-operator). For example it is possible to install an optional [target allocator](https://github.com/open-telemetry/opentelemetry-operator?tab=readme-ov-file#target-allocator) via the `OpenTelemetryCollector` resource, it can be used to configure the Prometheus receiver of the collector. This is especially useful when you want to replace Prometheus operator and are using its `ServiceMonitor` and `PodMonitor` custom resources.

# More info

* [API keys](/use/security/k8s-ingestion-api-keys.md)
* [Open Telemetry API](../otlp-apis.md)
* [Customizing Open Telemetry Collector configuration](../collector.md)
* [Open Telemetry SDKs](../instrumentation/README.md)
* [Open Telemetry Operator](https://github.com/open-telemetry/opentelemetry-operator)