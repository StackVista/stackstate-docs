---
description: StackState Self-hosted
---

# Expose StackState outside of the cluster

## Overview

StackState can be exposed with a Kubernetes Ingress resource. The example on this page shows how to configure an nginx-ingress controller using [Helm for StackState running on Kubernetes](ingress.md#configure-ingress-via-the-stackstate-helm-chart). This page also documents which service/port combination to expose when using a different method of configuring ingress traffic.

When observing the cluster that also hosts StackState, the agent traffic can be kept entirely within the cluster itself by [changing the agent configuration](./ingress.md#agents-in-the-same-cluster) during agent installation.

## Configure ingress via the StackState Helm chart

The StackState Helm chart exposes an `ingress` section in its values. This is disabled by default. The example below shows how to use the Helm chart to configure an nginx-ingress controller with TLS encryption enabled. Note that setting up the controller itself and the certificates is beyond the scope of this document.

To configure the ingress for StackState, create a file `ingress_values.yaml` with contents like below. Replace `MY_DOMAIN` with your own domain \(that's linked with your ingress controller\) and set the correct name for the `tls-secret`. Consult the documentation of your ingress controller for the correct annotations to set. All fields below are optional, for example, if no TLS will be used, omit that section but be aware that StackState also doesn't encrypt the traffic.

```text
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
  hosts:
    - host: stackstate.MY_DOMAIN
  tls:
    - hosts:
        - stackstate.MY_DOMAIN
      secretName: tls-secret
```

The thing that stands out in this file is the Nginx annotation to increase the allowed `proxy-body-size` to `50m` \(larger than any expected request\). By default, Nginx allows body sizes of maximum `1m`. StackState Agents and other data providers can sometimes send much larger requests. For this reason, you should make sure that the allowed body size is large enough, regardless of whether you are using Nginx or another ingress controller. Make sure to update the `baseUrl` in the values file generated during initial installation, it will be used by StackState to generate convenient installation instructions for the agent.

Include the `ingress_values.yaml` file when you run the `helm upgrade` command to deploy StackState:

```text
helm upgrade \
  --install \
  --namespace "stackstate" \
  --values "ingress_values.yaml" \
  --values "values.yaml" \
stackstate \
stackstate/stackstate-k8s
```

## Configure Ingress Rule for Open Telemetry Traces via the StackState Helm chart

The StackState Helm chart exposes an `opentelemetry-collector` service in its values where a dedicated `ingress` can be created. This is disabled by default. The ingress needed for `opentelemetry-collector` purposed needs to support GRPC protocol. The example below shows how to use the Helm chart to configure an nginx-ingress controller with GRPC and  TLS encryption enabled. Note that setting up the controller itself and the certificates is beyond the scope of this document.

To configure the `opentelemetry-collector` ingress for StackState, create a file `ingress_otel_values.yaml` with contents like below. Replace `MY_DOMAIN` with your own domain \(that's linked with your ingress controller\) and set the correct name for the `tls-secret`. Consult the documentation of your ingress controller for the correct annotations to set. All fields below are optional, for example, if no TLS will be used, omit that section but be aware that StackState also doesn't encrypt the traffic.

```text
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
    nginx.ingress.kubernetes.io/backend-protocol: GRPC
  hosts:
    - host: stackstate.MY_DOMAIN
  tls:
    - hosts:
        - stackstate.MY_DOMAIN
      secretName: tls-secret
```

The thing that stands out in this file is the Nginx annotation to increase the allowed `proxy-body-size` to `50m` \(larger than any expected request\). By default, Nginx allows body sizes of maximum `1m`. StackState Agents and other data providers can sometimes send much larger requests. For this reason, you should make sure that the allowed body size is large enough, regardless of whether you are using Nginx or another ingress controller. Make sure to update the `baseUrl` in the values file generated during initial installation, it will be used by StackState to generate convenient installation instructions for the agent.

Include the `ingress_otel_values.yaml` file when you run the `helm upgrade` command to deploy StackState:

```text
helm upgrade \
  --install \
  --namespace "stackstate" \
  --values "ingress_otel_values.yaml" \
  --values "values.yaml" \
stackstate \
stackstate/stackstate-k8s
```

## Configure via external tools

To make StackState accessible outside of the Kubernetes cluster it's installed in, it's enough to route traffic to port `8080` of the `<namespace>-stackstate-k8s-router` service. The UI of StackState can be accessed directly under the root path of that service (i.e. `http://<namespace>-stackstate-k8s-router:8080`) while agents will use the `/receiver` path (`http://<namespace>-stackstate-k8s-router:8080/receiver`).

Make sure to update the `baseUrl` in the values file generated during initial installation, it will be used by StackState to generate convenient installation instructions for the agent.

{% hint style="info" %}
When manually configuring an Nginx or similar HTTP server as reverse proxy make sure that it can proxy websockets as well. For Nginx this can be configured by including the following directives in the `location` directive:

```text
proxy_set_header Upgrade                 $http_upgrade;
proxy_set_header Connection              "Upgrade";
```
{% endhint %}

{% hint style="warning" %}
StackState itself doesn't use TLS encrypted traffic, TLS encryption is expected to be handled by the ingress controller or external load balancers.
{% endhint %}

## Agents in the same cluster

Agents that are deployed to the same cluster as StackState can of course use the external URL on which StackState is exposed, but it's also possible to configure the agent to directly connect to the StackState instance via the Kubernetes internal network only. To do that replace the value of the `'stackstate.url'` in the `helm install` command from the [Agent Kubernetes installation](../../../k8s-quick-start-guide.md) with the internal cluster URL for the router service (see also above): `http://<namespace>-stackstate-k8s-router.<namespace>.svc.cluster.local:8080/receiver/stsAgent` (the `<namespace>` sections need to be replaced with the namespace of StackState). 

## See also

* [AKS \(learn.microsoft.com\)](https://learn.microsoft.com/en-us/azure/aks/ingress-tls?tabs=azure-cli)
* [EKS Official docs](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) \(not using nginx\)
* [EKS blog post](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) \(using nginx\)

