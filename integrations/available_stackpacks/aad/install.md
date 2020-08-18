---
title: Install and Configure
kind: documentation
---

The manual step is required to install Autonomous Anomaly Detector.

### Install Helm and Get the latest anomaly detection chart

1. Install Helm:

  Please see helm docs `https://helm.sh/docs/intro/install`

2. Add stackstate helm repo:

```
helm repo add stackstate https://helm.stackstate.io`
```

3. Fetch the latest chart:

```
helm fetch stackstate/anomaly-detection
```

### Configure Anomaly Detection Service

1. Configure values.yaml file:

  - configure image version tag, e.g 4.1.0-latest
  - stackstate instance url, e.g http://stackstate-server-headless:7070/ or http://\<releasename\>-stackstate-server-headless:7070/   
  - configure status page ingress (optional, useful for troubleshooting)

```
image:
    # Image tag "4.1.0-latest"
    tag: <image tag>
stackstate:
    # Stackstate instance URL
    instance: <stackstate url>

# Optionally one can configure status page ingress (the configuration below is relevant for nginx ingress controller)   
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

More information on possible configuration options are in the chart documentation.

```
helm show all stackstate/anomaly-detection
```

2. Install the anomaly detection chart in the same namespace as stackstate:

```
helm upgrade <release name> stackstate/anomaly-detection \
    --install \
    --namespace <stackstate-namespace> \
    --values ./values.yaml
```

## Uninstalling Anomaly Detection Stackpack:

1. Uninstall anomaly detection service:

```
helm delete <release name>
```

2. Uninstall the AAD stackpack.
