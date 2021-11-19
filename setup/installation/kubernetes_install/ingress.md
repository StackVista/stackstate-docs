# Configure Ingress

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The StackState Helm chart exposes an `ingress` section in its values. By default ingress is disabled.

We give an example here for how to configure an nginx-ingress controller with TLS encryption enabled. Setting up the controller itself and the certificates is beyond the scope of this document.

To configure the ingress for StackState create a file `ingress_values.yaml` with contents like below, however replace MY\_DOMAIN with your own domain \(that is linked with your ingress controller\) and set the correct name for the `tls-secret`. Please consult the documentation of your ingress controller carefully and ensure the correct annotations are set. All of the fields below are optional, for example if no TLS is going to be used that section can be omitted.

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

The one thing standing out in this file is the nginx annotation to increase the allowed `proxy-body-size` to `50m` \(larger than any expected request\). By default Nginx allows only body sizes of maximum `1m`. StackState agents and other data providers can sometimes send much larger requests. Therefore regardless if you're using Nginx or another ingress controller you want make sure that the allowed body size is large enough.

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

* [AKS](https://docs.microsoft.com/en-us/azure/aks/ingress-tls)
* [EKS Official docs](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) \(not using nginx\)
* [EKS blog post](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/) \(using nginx\)

