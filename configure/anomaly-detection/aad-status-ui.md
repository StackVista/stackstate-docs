---
description: StackState Self-hosted v5.1.x 
---

# The AAD status UI

## Overview

The AAD status UI provides details on the technical state of the AAD. It can be used to retrieve information about scheduling progress, possible errors, the ML models selected and job statistics.

## When to use the AAD status UI

Common questions that can be answered in the AAD status UI:

**Is the AAD Kubernetes service running?**  
If the status UI is accessible: The service is running.  
If the status UI is not available: Either the service is not running, or the Ingress has not been configured \(See the install section\).

**Can the AAD Kubernetes service reach StackState?**  
Check the status UI sections **Top errors** and **Last stream polling results**. Errors here usually indicate connection problems.

**Has the AAD Kubernetes service selected metric streams for anomaly detection?**  
The status UI section **Anomaly Detection Summary** shows the total time of all registered streams, if no streams are selected it will be zero.

**Is the AAD Kubernetes service detecting anomalies?**  
The status UI section **Top Anomalous Streams** shows the streams with the highest number of anomalies. No streams in this section means that no anomalies have been detected. The status UI section **Anomaly Detection Summary** shows other relevant metrics, such as total time of all registered streams, total checked time and total time of all anomalies detected.

**Is the AAD Kubernetes service scheduling streams?**  
The status UI tab **Job Progress** shows a ranked list of streams with scheduling progress, including the last time each stream was scheduled.

## Access the status UI 

### Proxy

To access the status UI by proxy, run kubectl proxy:

```text
kubectl proxy
```

The UI will be accessible at the URL:

```text
http://localhost:8001/api/v1/namespaces/<namespace>/services/http:<release-name>-anomaly-detection:8090/proxy/
```

### Ingress

For more permanent accessibility, the status UI can also be exposed using ingress configuration. The example below shows how to configure an nginx-ingress controller.

{% tabs %}
{% tab title="values.yaml" %}
```text
# status UI ingress (the configuration below is example for nginx ingress controller)
ingress:
    enabled: true
    hostname: <domain name> # e.g. spotlight.domain.com
    port: 8090              # status page will be available on spotlight.domain.com:8090
    annotations:        
        external-dns.alpha.kubernetes.io/hostname: <domain name> # e.g. spotlight.domain.com
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/ingress.class: nginx
    hosts:
        - host: <domain name>  # e.g. spotlight.domain.com
```
{% endtab %}
{% endtabs %}

Setting up the controller itself is beyond the scope of this document. More information about how to set up Ingress can be found at:

* [AKS \(docs.microsoft.com\)](https://docs.microsoft.com/en-us/azure/aks/ingress-tls)
* Not using nginx - [EKS Official docs \(docs.aws.amazon.com\)](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html)
* Using nginx - [EKS blog post \(aws.amazon.com\)](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/)

