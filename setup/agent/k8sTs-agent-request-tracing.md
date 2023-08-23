---
description: StackState Kubernetes Troubleshooting
---

# Request tracing

## Observability through load balancers, service meshes and between clusters

StackState can observe connections between services and pods in different Clusters, or when the connections go through a Service Mesh or Load Balancer. Observing these connections is done through `request tracing`. Traced requests will result in connections in the [topology perspective](/use/views/k8s-topology-perspective.md), to give insight in the dependencies across an application and help with finding the root cause of an incident.

## How does it work

Request tracing is done by injecting a unique header (the `X-Request-ID` header) into all HTTP traffic. This unique header is observed at both client and server through an eBPF probe installed with the StackState Agent. These observations are sent to StackState, which uses the observations to understand which clients and server are connected.

The `X-Request-Id` headers are [injected](#enabling-the-trace-header-injection-sidecar) by a sidecar proxy that can be automatically injected by the StackState Agent. The sidecar gets injected by a [mutating webhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#mutatingadmissionwebhook), which injects the sidecar into every pod for which the `http-header-injector.stackstate.io/inject: enabled` annotation is defined. Sidecar injection is not supported on OpenShift. 

It's also possible to add the `X-Request-Id` header if you application [already has a proxy or LoadBalancer](#add-the-trace-header-id-to-an-existing-proxy), or through [instrumenting your own code](#instrument-your-application). Advantage of this is that the extra sidecar proxy isn't needed.

## Enabling the trace header injection sidecar

Enabling trace header injection is a two-step process:

 1. Install the mutating webhook into the cluster by adding `--set httpHeaderInjectorWebhook.enabled=true` to the helm upgrade invocation when installing the StackState agent
 2. For every pod that has a endpoint which processes http(s) requests, place the annotation `http-header-injector.stackstate.io/inject: enabled` to have the sidecar injected.

{% hint style="warning" %}
**Enabling the mutating webhook will only take effect upon pod restart**

If the annotation is placed before the webhook is installed. Installing the webhook has no effect until the pods get restarted.
{% endhint %}

### Disabling trace header injection

Disabling the trace header injection can be done with the reverse process:

1. Remove the `http-header-injector.stackstate.io/inject: enabled` annotation from all pods.
2. Redeploy the StackState Agent without the `--set httpHeaderInjectorWebhook.enabled=true` setting. 

{% hint style="warning" %}
**Disabling the mutating webhook will only take effect upon pod restart**

If step 1 is skipped and only the mutating webhook is disabled, all pods need a restart for the sidecar to be removed. 
{% endhint %}

### Overhead

Request tracing adds a small, fixed amount of CPU overhead for each HTTP request header that gets injected and observed. The exact amount is dependent on the system that it's ran on, so it's advised to enable this feature first in an acceptance environment to observe the impact before moving to production. The sidecar proxy takes a minimum of 25Mb of memory per pod it's deployed with, up to a maximum of 40Mb.   

## Add the trace header id to an existing proxy

To add the `X-Request-Id` header from an existing proxy, two properties are important:

1. Each request/response pair has to get a unique ID.
2. The `X-Request-Id` header should be added to both request and response, to be observed on both client and server.

### Add the trace header id in envoy

In envoy, the `X-Request-Id` header can be enabled by setting `generate_request_id: true` and `always_set_request_id_in_response: true` for [http connections](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto)

### Add the trace header id in Istio

An [Envoy Filter](https://istio.io/latest/docs/reference/config/networking/envoy-filter/) can be used to set the trace header for Envoy.

Use `kubectl` to apply the following definition to the Kubernetes cluster,

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: responsed-x-request-id-always
  namespace: istio-system
spec:
  configPatches:
    - applyTo: NETWORK_FILTER
      match:
        context: ANY
        listener:
          filterChain:
            filter:
              name: envoy.filters.network.http_connection_manager
      patch:
        operation: MERGE
        value:
          typed_config:
            '@type': >-
              type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
            always_set_request_id_in_response: true
            generate_request_id: true
            preserve_external_request_id: true
  priority: 0
```

## Instrument your application

It's also possible to add the `X-Request-Id` header form either the client side to each request, or on the server side to each response. It's important to ensure each request/response gets a unique `X-Request-Id` value. Also, the `X-Request-Id` requires that if an ID is already present in a request, the response should contain that same ID.

## Supported systems/technologies

- HTTP/1.0 and HTTP/1.1 with keepAlive
- Trace header injection and trace observation on unencrypted traffic 
- Trace observation for OpenSSL Encrypted traffic
- Trace header injection alongside LinkerD
- Any LoadBalancer that forwards the `X-Request-Id` header in requests and responses
- Any cross-cluster networking solution that forwards the `X-Request-Id` header in requests and responses

## Known Issues

### No sidecar is injected for my pods

To make sure you setup is ok, first validate the following steps were taken:
- The `--set httpHeaderInjectorWebhook.enabled=true` flag was set during installation of the agent
- The pod has `http-header-injector.stackstate.io/inject: enabled` set
- The pod was restarted

If this does not resolve the issue, the following could be the issue:

#### Cluster networking policies

The cluster can have networking policies setup, preventing the kubernetes control-plane apiserver from contacting the mutatingvalidationwebhook which injects the sidecar. To validate this, look at the logs of the kube-apiserver, which is either in the kube-system namespace or could be managed by your cloud provider. An error like the following should be found in those logs: 

```
Failed calling webhook, failing open stackstate-agent-http-header-injector-webhook.stackstate.io: failed calling webhook "stackstate-agent-http-header-injector-webhook.stackstate.io": failed to call webhook: Post "https://stackstate-agent-http-header-injector.monitoring.svc:8443/mutate?timeout=10s": context deadline exceeded
```

If this happens, be sure to adapt your cluster network policies such that the apiserver can reach the mutatingvalidationwebhook.