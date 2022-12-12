---
description: StackState Self-hosted v5.1.x 
---

# Configure Ingress

## Overview

StackState can be exposed with Ingress resources. The example on this page shows how to configure an nginx-ingress controller using Helm for StackState running on Kubernetes.

## Kubernetes: Configure ingress with Helm

The StackState Helm chart exposes an `ingress` section in its values. This is disabled by default. The example below shows how to use the Helm chart to configure an nginx-ingress controller with TLS encryption enabled. Note that setting up the controller itself and the certificates is beyond the scope of this document.

To configure the ingress for StackState, create a file `ingress_values.yaml` with contents like below. Replace `MY_DOMAIN` with your own domain \(that's linked with your ingress controller\) and set the correct name for the `tls-secret`. Consult the documentation of your ingress controller for the correct annotations to set. All fields below are optional, for example, if no TLS will be used, omit that section.

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

The thing that stands out in this file is the nginx annotation to increase the allowed `proxy-body-size` to `50m` \(larger than any expected request\). By default, nginx allows body sizes of maximum `1m`. StackState Agents and other data providers can sometimes send much larger requests. For this reason, you should make sure that the allowed body size is large enough, regardless of whether you are using nginx or another ingress controller.

Include the `ingress_values.yaml` file when you run the `helm upgrade` command to deploy StackState:

```text
helm upgrade \
  --install \
  --namespace "stackstate" \
  --values "ingress_values.yaml" \
  --values "values.yaml" \
stackstate \
stackstate/stackstate
```

## See also

* [AKS \(learn.microsoft.com\)](https://learn.microsoft.com/en-us/azure/aks/ingress-tls?tabs=azure-cli)
* [EKS Official docs](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) \(not using nginx\)
* [EKS blog post](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) \(using nginx\)

