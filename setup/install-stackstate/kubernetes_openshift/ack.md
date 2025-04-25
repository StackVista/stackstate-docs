---
description: SUSE Observability Self-hosted
---

# Alibaba Cloud Container Service for Kubernetes (ACK) installation notes

## Minimum volume size

Alibaba Cloud's Container Service for Kubernetes (ACK) enforces a minimum volume size of **20 GiB** for disk-based PersistentVolumeClaims (PVCs). When deploying on ACK, Persistent Volume Claims (pvc) have to request **at least 20Gi** of storage. Failure to meet the 20Gi minimum may result in volume provisioning and failures during Helm deployment.

We provide a dedicated set of Helm values that adjusts all volume sizes to meet this requirement. If you're installing on ACK, use this file during installation:

```yaml
# ack-values.yaml
zookeeper:
  persistence:
    size: 20Gi
stackstate:
  components:
    checks:
      tmpToPVC:
        volumeSize: 20Gi
    healthSync:
      tmpToPVC:
        volumeSize: 20Gi
      localpvc:
        size: 20Gi
    state:
      tmpToPVC:
        volumeSize: 20Gi
    sync:
      tmpToPVC:
        volumeSize: 20Gi
    vmagent:
      persistence:
        size: 20Gi
  experimental:
    storeTransactionLogsToPVC:
      volumeSize: 20Gi
  stackpacks:
    localpvc:
      size: 20Gi
    pvc:
      size: 20Gi
backup:
  configuration:
    scheduled:
      pvc:
        size: 20Gi
```  

Please create a separate file for the ACK-specific values and use it during installation. For example, if you follow [Kubernetes install documentation](https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/kubernetes_install#deploy-suse-observability-with-helm) and save the above values in a file called `ack-values.yaml`, you can install Suse Observability with:

```bash
helm upgrade \
  --install \
  --namespace suse-observability \
  --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml \
  --values ack-values.yaml \
suse-observability \
suse-observability/suse-observability
```
