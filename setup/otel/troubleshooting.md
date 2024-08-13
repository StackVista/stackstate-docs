---
description: Rancher Observability v6.0
---

# Troubleshooting Open Telemetry

There are a lot of configuration options but more importantly, every (Kubernetes) environment is slightly different. To find out where the problem is the quickest approach is to pick a pod from which telemetry data is expected:

1. Check the beginning of the logs for the pod, SDKs will log warnings or errors when instrumentation fails at startup
2. Check the logs also for any errors related to sending data to the collector
3. Check the logs of the collector pod(s) for configuration or initialization errors, these will be logged right after the startup of the pod
4. Check the collector logs also for errors related to sending data to Rancher Observability

The error(s) in the logs usually give a good indication of the problem. We list the most common causes for Open Telemetry data not being available for some or all of your instrumented applications. If the problem is not listed here you can also look at the [language-specific SDK documentation](https://opentelemetry.io/docs/languages/) or the [collector documentation](https://opentelemetry.io/docs/collector/troubleshooting/) from Open Telemetry.

## Use the same Kubernetes cluster name

Make sure you use the same Kubernetes cluster name for the same cluster when:
* Installing the Open Telemetry Collector
* Installing the Rancher Observability agent
* Installing the Kubernetes StackPack

When different names are used for the same cluster Rancher Observability will not be able to match the data from Open Telemetry with the data from the Rancher Observability agent and the traces perspective will remain empty.

## The collector cannot send data to Rancher Observability

### Rancher Observability's OTLP endpoint and API key are misconfigured

If there are connection errors it is possible the OTLP endpoint is incorrect. If there are authentication/authorization errors (status codes 401 and 403) it is likely the API key is not valid (anymore). Check that the configured OTLP endpoint is the URL for your Rancher Observability, prefixed with `otlp-` and suffixed with `:443`. For example, the  OTLP endpoint for `play.stackstate.com` is `otlp-play.stackstate.com:443`. 

To ensure the api key is configured correctly check that:
1. the secret contains a valid API key (verify this in Rancher Observability)
2. the secret is used as environment variables on the pod
3. the `bearertokenauth` extension is using the correct scheme and the value from the `API_KEY` environment variable
4. the `bearertokenauth` extension is used by the `otlp/stackstate` exporter

### Some proxies and firewalls don't work well with gRPC

If the collector needs to send data through a proxy or a firewall it can be that they either block the traffic completely or possibly drop some parts of the gRPC messages or unexpectedly drop the long-lived gRPC connection completely. The easiest fix is to switch from gRPC to use HTTP instead, by replacing the `otlp/stackstate` exporter configuration and all its references with the  `otlp-http/stackstate` exporter with this configuration.

```yaml
    otlp-http/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: <otlp-http-stackstate-endpoint>:4318
```

Here `<otlp-http-stackstate-endpoint>` is similar to the `<otlp-stackstate-endpoint>`, but instead of a `otlp-` prefix it has `otlp-http-` prefix, for example, `otlp-http-play.stackstate.com`.

## The instrumented application cannot send data to the collector

### The URL is incorrect or traffic is blocked

If the SDK logs errors about not being able to resolve the collector DNS name it may be the configured collector URL is incorrect. In Kubernetes, your application is usually deployed in a separate namespace from the collector. This means that the SDK needs to be configured with the fully qualified domain name for the collector service:
`http://<service-name>.<namespace>.svc.cluster.local:4317`. In the [collector installation steps](./collector.md), this was `http://opentelemetry-collector.open-telemetry.svc.cluster.local:4317`, but if you used a different namespace or release name for the collector this may be different for your situation.

If the SDK logs network connection timeouts it can be that either there is a misconfiguration on the collector or the [wrong port](#the-language-sdk-uses-the-wrong-port) is used. But it is also possible that Kubernetes network policies are blocking network traffic from your application to the collector. This is best verified with your Kubernetes administrator. Network policies should at least allow TCP traffic on the configured port (4317 and/or 4318) from all of your applications to the collector.

### The language SDK doesn't support gRPC

Not all language SDKs have support for gRPC. If OTLP over gRPC is not supported it is best to switch to OTLP over HTTP. The [SDK exporter config](./languages/sdk-exporter-config.md#grpc-vs-http) describes how to make this switch.

### The language SDK uses the wrong port

Using the wrong port usually appears as a connection error but can also show up as network connections being unexpectedly closed. Make sure the SDK exporter is using the right port when sending data. See the [SDK exporter config](./languages/sdk-exporter-config.md#grpc-vs-http).

### Some proxies and firewalls don't work well with gRPC 

If the collector needs to send data through a proxy or a firewall it can be that they either block the traffic completely or possibly drop some parts of the gRPC messages or unexpectedly drop the long-lived gRPC connection completely. The [SDK exporter config](./languages/sdk-exporter-config.md#grpc-vs-http) describes how to switch from gRPC to HTTP instead. 

## Kubernetes pods with hostNetwork enabled

The Open Telemetry collector enriches the telemetry data with Kubernetes metadata. The way it is configured all telemetry data that cannot be enriched is dropped. However, the collector cannot enrich pods that are running with `hostNetwork: true` set automatically. This is not possible because pod identification happens using the IP address of the pod and pods that use the host network use the IP address of the host.

To help the collector to identify a pod we can add the `k8s.pod.uid` attribute to the metadata by instructing the SDK to add it directly. To do this modify your pod spec and add the following environment variables to your instrumented application container:

```yaml
env:
  - name: POD_UID
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.uid
  - name: OTEL_RESOURCE_ATTRIBUTES
    value: k8s.pod.uid=$(POD_UID)
```

If the `OTEL_RESOURCE_ATTRIBUTES` env var is already set simply add the `k8s.pod.uid`, using a comma as separator. The value is a comma-separated list.

## Node.js application on Google Kubernetes Engine

The Node.js SDK, only on GKE, expects that the Kubernetes namespace is set via the `NAMESPACE` environment variable. If it is not set it will still add the `k8s.namespace.name` attribute but with an empty value.  This prevents the Kubernetes attributes processor from inserting the correct namespace name. Until this is fixed a workaround is to update your pod spec and add this environment variable to the instrumented container(s):

```yaml
env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
```

## No metrics available for Node.js application

The auto instrumentation for Node.js, configured via environment variables, only supports traces. At least until this [Open Telemetry issue](https://github.com/open-telemetry/opentelemetry-js/issues/4551) is resolved. To enable metrics from the automatic instrumentation code changes are needed. Please follow the instructions in the [Open Telemetry documentation](https://opentelemetry.io/docs/languages/js/exporters/#usage-with-nodejs) to make these changes. 

## Kubernetes attributes cannot be added

During the installation of the collector, a cluster role and cluster role binding are created in Kubernetes that allows the collector to read metadata from Kubernetes resources. If this fails or they get removed the collector will not be able to query the Kubernetes API anymore. This will appear as errors in the collector log, the errors include the resource types for which the metadata could not be retrieved.

To fix this re-install the collector with the Helm chart and make sure you have the required permissions to create the cluster role and cluster role binding. Alternatively, ask your cluster administrator to do the collector installation with the required permissions.
