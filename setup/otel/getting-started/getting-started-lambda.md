---
description: SUSE Observability
---

# Getting started for AWS Lambda

We'll setup monitoring for one or more AWS Lambda functions:
* The monitored AWS Lambda function(s) (instrumented using Open Telemetry)
* The Open Telmetry collector
* SUSE Observability or SUSE Cloud Observability

![AWS Lambda Instrumentation With Opentelemetry with Open Telemetry collector running in Kubernetes](/.gitbook/assets/otel/open-telemetry-collector-lambda.png)

## The Open Telemetry collector

{% hint type="info" %}
For a production setup it is strongly recommended to install the collector, since it allows your service to offload data quickly and the collector can take care of additional handling like retries, batching, encryption or even sensitive data filtering.
{% endhint %}

First we'll install the OTel (Open Telemetry) collector, in this example we use a Kubernetes cluster to run it close to the Lambda functions. A similar setup can be made using a collector installed on a virtual machine instead. The configuration used here only acts as a secure proxy to offload data quickly from the Lambda functions and runs within trusted network infrastructure. 

### Create a secret for the API key

We'll use the receiver API key generated during installation (see [here](/use/security/k8s-ingestion-api-keys.md#api-keys) where to find it):

```bash
kubectl create secret generic open-telemetry-collector \
    --namespace open-telemetry \
    --from-literal=API_KEY='<suse-observability-api-key>' 
```

### Configure and install the collector

We install the collector with a Helm chart provided by the Open Telemetry project. Make sure you have the Open Telemetry helm charts repository configured:

```bash
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
```

Create a `otel-collector.yaml` values file for the Helm chart. Here is a good starting point for usage with SUSE Observability, replace `<otlp-suse-observability-endpoint>` with your OTLP endpoint (see [OTLP API](../otlp-apis.md) for your endpoint) and insert the name for your Kubernetes cluster instead of `<your-cluster-name>`:

{% code title="otel-collector.yaml" lineNumbers="true" %}
```yaml
mode: deployment
presets:
  kubernetesAttributes:
    enabled: true
    # You can also configure the preset to add all the associated pod's labels and annotations to you telemetry.
    # The label/annotation name will become the resource attribute's key.
    extractAllPodLabels: true
extraEnvsFrom:
  - secretRef:
      name: open-telemetry-collector
image:
  repository: "otel/opentelemetry-collector-k8s"

config:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318
  extensions:
    # Use the API key from the env far for authentication
    bearertokenauth:
      scheme: SUSEObservability
      token: "${env:API_KEY}"
  exporters:
    otlp:
      auth:
        authenticator: bearertokenauth
      # Put in your own otlp endpoint
      endpoint: <otlp-suse-observability-endpoint>

  service:
    extensions: [health_check, bearertokenauth]
    pipelines:
      traces:
        receivers: [otlp]
        processors: [batch]
        exporters: [otlp]
      metrics:
        receivers: [otlp]
        processors: [batch]
        exporters: [otlp]
      logs:
        receivers: [otlp]
        processors: [batch]
        exporters: [otlp]

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: ingress-nginx-external
    nginx.ingress.kubernetes.io/ingress.class: ingress-nginx-external
    nginx.ingress.kubernetes.io/backend-protocol: GRPC
    # "12.34.56.78/32" IP address of NatGateway in the VPC where the otel data is originating from
    #  nginx.ingress.kubernetes.io/whitelist-source-range: "12.34.56.78/32"
  hosts:
    - host: "otlp-collector-proxy.${CLUSTER_NAME}"
      paths:
        - path: /
          pathType: ImplementationSpecific
          port: 4317
  tls:
    - secretName: ${CLUSTER_NODOT}-ecc-tls
      hosts:
        - "otlp-collector-proxy.${CLUSTER_NAME}"
```
{% endcode %}

Now install the collector, using the configuration file:

```bash
helm upgrade --install opentelemetry-collector open-telemetry/opentelemetry-collector \
  --values otel-collector.yaml \
  --namespace open-telemetry
```

Make sure that the proxy is accessible by the Lambda functions by connecting them to the same VPC. It is recommended to use a source-range whitelist to filter out data from untrusted and/or unknown sources. 

The collector offers a lot more configuration receivers, processors and exporters, for more details see our [collector page](../collector.md). For production usage often large amounts of spans are generated and you will want to start setting up [sampling](../sampling.md).

## Instrument a Lambda function

Open Telemetry supports instrumenting Lambda functions in multiple languages using Lambda layers. The configuration of those Lambda layers should use the address of the collector from the previous step to ship the data. To instrument a Node.js lambda follow our [detailed instructions here](../instrumentation/node.js/auto-instrumentation-of-lambdas.md). For instrumenting other languages apply the same configuration as for Node.js but use one of the other [Open Telemetry Lambda layers](https://opentelemetry.io/docs/platforms/faas/lambda-auto-instrument/).

## View the results
Go to SUSE Observability and make sure the Open Telemetry Stackpack is installed (via the main menu -> Stackpacks). 

After a a short while and if your Lambda function(s) are getting some traffic you should be able to find the functions under their service name in the Open Telemetry -> services and service instances overviews. Traces will appear in the [trace explorer](/use/traces/k8sTs-explore-traces.md) and in the [trace perspective](/use/views/k8s-traces-perspective.md) for the service and service instance components. Span metrics and language specific metrics (if available) will become available in the [metrics perspective](/use/views/k8s-metrics-perspective.md) for the components.

# More info

* [API keys](/use/security/k8s-ingestion-api-keys.md)
* [Open Telemetry API](../otlp-apis.md)
* [Customizing Open Telemetry Collector configuration](../collector.md)
* [Open Telemetry SDKs](../instrumentation/README.md)