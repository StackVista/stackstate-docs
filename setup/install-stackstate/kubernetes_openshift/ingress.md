---
description: StackState Self-hosted v5.1.x 
---

# Configure Ingress

## Overview

You can expose Stackstate with Ingress resources. The example on this page shows how to configure an nginx-ingress controller using Helm for StackState running on Kubernetes.

## Kubernetes: Configure ingress with Helm

The StackState Helm chart exposes an `ingress` section in its values. This is disabled by default. The example below shows how to use the Helm chart to configure an nginx-ingress controller with TLS encryption enabled. Note that setting up the controller itself and the certificates is beyond the scope of this document.

To configure the ingress for StackState create a file `ingress_values.yaml` with contents like below, however replace MY\_DOMAIN with your own domain \(that is linked with your ingress controller\) and set the correct name for the `tls-secret`. Consult the documentation of your ingress controller and ensure the correct annotations are set. All of the fields below are optional, for example if no TLS is going to be used that section can be omitted.

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

The one thing standing out in this file is the nginx annotation to increase the allowed `proxy-body-size` to `50m` \(larger than any expected request\). By default, Nginx allows only body sizes of maximum `1m`. StackState agents and other data providers can sometimes send much larger requests. Therefore, regardless if you're using Nginx or another ingress controller, you want to make sure that the allowed body size is large enough.

Now include this `ingress_values.yaml` file when running the helm command to deploy StackState:

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

