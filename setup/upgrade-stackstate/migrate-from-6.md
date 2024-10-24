---
description: SUSE Observability Self-hosted
---
TODO: Split docs for simple case (uninstall StackState) and run side-by-side

# Migrating from StackState 6.x to SUSE Observability

Due to the rename of the product and also due to breaking changes in the topology data format it is not possible to simply upgrade from StackState to SUSE Observability. This migration guide will help you set up SUSE Observability exactly the same as StackState.

SUSE Observability will be a new installation, without the already existing historical data. **Optionally** the historical data can be kept accessible until SUSE Observability has built up sufficient history. This guide describes how that can be done using the StackState installation in a slimmed down form, i.e. it uses less resourcves. Note that SUSE Observability will ingest new data and it is responsible to run monitors and send out notifications. StackState will only offer access to the historical data.

The steps to migrate are, see the next sections for a step-by-step guide:
1. Make sure the latest version of StackState 6.x is installed
2. Create and download a configuration backup
3. Install SUSE Observability
4. Upload and restore the configuration backup
5. Re-route the traffic
6. Migrate the agent and Open Telemetry collectors
7. Scale down or uninstall StackState

{% hint style="info" %}
Throughout this guide all examples assume the following setup, customize the commands to match your exact setup:
* Kubernetes cluster is accesses using a context named `observability`
* StackState is installed in the `stackstate` namespace
* SUSE Observability will be installed in the `suse-observability` namespace
{% endhint %}

At some point traffic will need to be switched over from StackState to SUSE Observability. The solution that limits the impact on your users and the installed agents is to configure SUSE Observability with the URL originally used by StackState. This is easy when you uninstall StackState before installing SUSE Observability, but it requires some extra steps when you want to keep StackState active. This guide will describe the case where the same URL is used with StackState optionally still accessible under a new `stackstate-old` URL.

It is also possible to install SUSE Observability under a new URL, in that case you'll need to update the agent and Open Telemetry collectors to use the new URL or use another method of re-routing the traffic. Be aware that, when using a new URL, this may also impact some other settings, for example when using an ODIC provider for authentication URLs need to be updated both in the provider and in the SUSE Observability configuration values.

Below we summarize the before and after situation in one picture.

TODO: Image

## Install latest version of StackState 6.x

Only the latest version of StackState 6.x has a backup format that contains all configuration in a format that is compatible with SUSE Observability. Please make sure you have the latest version installed by running `helm list --namespace stackstate` (use the namespace where StackState is installed):

* Helm chart version should be `1.12.0`
* Application version should be `6.0.0-snapshot.20241023094532-stackstate-6.x-7be52ad`

If you don't have that version please upgrade first following the standard [upgrade steps](./steps-to-upgrade.md#minor-or-maintenance-suse-observability-release).

## Create a backup and download the backup

First we create a configuration backup of the StackState configuration, after this you shouldn't make any configuration changes anymore in StackState (they will not be transfered to SUSE Observability). To do this first familiarize yourself with the configuration backup and get the required scripts using the [configuration backup docs for StackState 6.x](https://docs.stackstate.com/6.0/self-hosted-setup/data-management/backup_restore/configuration_backup#working-with-configuration-backups).

From the `restore` directory that contains the scripts run these commands:

1. Set the active context and namespace:
  ```bash
  kubectl config use-context observability
  kubectl config set-context --current --namespace=stackstate
  ```
2. Create a backup (this will require 1Gi of memory and 1 core in the cluster), this may take a while to create a Kubernetes job and start the pod:
  ```bash
    ./backup-configuration-now.sh
  ```
3. In the output of the command you'll see the filename for the backup, something like `sts-backup-20241024-1423.sty`. Copy the filename and use it to download the backup:
   ```bash
   ./download-configuration-backup.sh sts-backup-20241023-1423.sty
   ```

You should now have the configuration backup file on your computer.

## Install SUSE Observability

Before installing SUSE Observability it is possible to already uninstall StackState to free up cluster resources. However, this will mean neither StackState nor SUSE Observability is monitoring your clusters and applications until you finish the guide. Uninstalling StackState will also remove your historical data (topology and all other telemetry data too). To uninstall StackState follow the [uninstallation docs](https://docs.stackstate.com/6.0/self-hosted-setup/uninstall).

Install SUSE Observability in a different namespace from StackState to avoid any conflicts. Recommended is to use the same namespace as in the documentation, `suse-observability`. 

The biggest change for installation is that there is now support for profiles, please select the profile that matches your observed cluster using the [requirements](../install-stackstate/requirements.md#resource-requirements) and use it to generate the values as documented in the installation guide. Customized Helm values for StackState are compatible with SUSE Observability. However, the values to customize resources must be removed in favor of the new profiles. If you did not uninstall StackState also exclude the ingress setup from the SUSE Observability installation for now.

To install SUSE Observability follow the [installation guide](../install-stackstate/kubernetes_openshift/kubernetes_install.md), use the selected profile and your (updated) custom values. In case you decided to install SUSE Observability with a new URL also follow the instructions to configure the [ingress](../install-stackstate/kubernetes_openshift/ingress.md).

## Restore the configuration backup

Now that SUSE Observability is installed the configuration backup can be restored. The SUSE Observability Helm chart comes with a similar set of backup tools [documented here](../data-management/backup_restore/configuration_backup.md). **These are not the same as for StackState 6.x**, so make sure to get the scripts from the `restore` directory of the **SUSE Observability Helm chart** for restoring the backup.

From the `restore` directory of the SUSE Observability Helm chart run these commands to restore the backup:
1. Set the active context and namespace:
  ```bash
  kubectl config use-context observability
  kubectl config set-context --current --namespace=suse-observability
  ```
2. Upload the backup file previously created, in this case `sts-backup-20241024-1423.sty` (make sure to use the full path if needed):
   ```bash
   ./upload-configuration-backup.sh sts-backup-20241024-1423.sty
   ```
3. Create a backup (this will require 1Gi of memory and 1 core in the cluster), this may take a while to create a Kubernetes job and start the pod:
  ```bash
    ./restore-configuration-backup.sh sts-backup-20241024-1423.sty
  ```
4. Scale all deployments back up:
   ```bash
   ./scale-up.sh
   ```

Now SUSE Observability has the exact same setup as StackState and we're ready to start using it.

## Re-route traffic

Re-routing the traffic will switch both agent traffic and users of StackState to SUSE Observability. To do this 2 steps are needed, first switch StackState to a new URL, then configure the SUSE Observability ingress to use the original StackState URL. In between these steps SUSE Observability/StackState will temporarily be inaccessible, but the agents will cache the data and send it when they can connect again.

1. Take the ingress configuration from StackState and copy it into the values you have for SUSE Observability, or make a copy into a separate `ingress.yaml` values file, next to the generated `baseConfig_values.yaml` and `sizing_values.yaml`. 
2. Update the ingress values for StackState to use a different URL, here we changed it from `stackstate` to `stackstate-old`: 
   ```yaml
    ingress:
      annotations:
        nginx.ingress.kubernetes.io/proxy-body-size: 100m
      enabled: true
      hosts:
        - host: "stackstate-old.demo.stackstate.io"
      tls:
        - hosts:
            - "stackstate-old.demo.stackstate.io"
          secretName: tls-secret-stackstate-old

    opentelemetry-collector:
      ingress:
        enabled: true
        annotations:
          nginx.ingress.kubernetes.io/proxy-body-size: "50m"
          nginx.ingress.kubernetes.io/backend-protocol: GRPC
        hosts:
          - host: otlp-stackstate-old.demo.stackstate.io
            paths:
              - path: /
                pathType: Prefix
                port: 4317
        tls:
          - hosts:
              - otlp-stackstate-old.demo.stackstate.io
            secretName: tls-secret-stackstate-old-otlp
    ```
3. Run the helm upgrade for StackState, so it starts using the `stackstate-old.demo.stackstate.io` ingress (make sure to include all values files used during installation of StackState with the updated ingress):
  ```
  helm upgrade \
      --install \
      --namespace stackstate \
      --values stackstate-values/values.yaml \
      --values stackstate-values/updated-ingress.yaml \
    stackstate \
    stackstate/stackstate-k8s
  ```
4. Run the [helm upgrade](../install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-suse-observability-with-helm) for SUSE Observability, to start using the original `stackstate.demo.stackstate.io` URL (make sure to include all values files used during installation of SUSE Observability + the `ingress.yaml`):
   ```
    export VALUES_DIR=.
    helm upgrade \
      --install \
      --namespace suse-observability \
      --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
      --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml \  
      --values ingress.yaml \
    suse-observability \
    suse-observability/suse-observability
   ```

Now users can go to `https://stackstate.demo.stackstate.io` to get SUSE Observability with all the familiar StackState features and live data. They can go to `https://stackstate-old.demo.stackstate.io` to review historical data.

## Migrate agents and OpenTelemetry Collector

TODO

## Uninstall StackState

When the StackState installation is not needed anymore for historical data it can be uninstalled using the [uninstall procedure](https://docs.stackstate.com/6.0/self-hosted-setup/uninstall).
