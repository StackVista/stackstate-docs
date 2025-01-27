---
description: SUSE Observability Self-hosted
---

# Migrating from StackState 6.x to SUSE Observability

Due to the rename of the product and also due to breaking changes in the topology data format it is not possible to upgrade from StackState to SUSE Observability via a standard Helm upgrade command. This migration guide will help you set up SUSE Observability exactly the same as StackState.

SUSE Observability will be a new installation, without the already existing historical data. **Optionally** the historical data can be kept accessible until SUSE Observability has built up sufficient history. This guide covers both scenarios. 

Depending on the chosen scenario the steps to migrate are different. Running side-by-side is slightly more complicated and will require more resources. The overall steps, applicable to both scenarios are:
1. Install the latest version of StackState 6.x
2. Create and download a configuration backup
3. Install and configure SUSE Observability, scenario specific steps
4. Update Open Telemetry collectors configuration
5. Migrate the agent

{% hint style="info" %}
Throughout this guide all examples assume the following setup, customize the commands to match your exact setup:
* Kubernetes cluster is accesses using a context named `observability`
* StackState is installed in the `stackstate` namespace
* SUSE Observability will be installed in the `suse-observability` namespace
{% endhint %}

## Install latest version of StackState 6.x

Only the latest version of StackState 6.x has a configuration backup that contains all configuration in a format that is compatible with SUSE Observability. Please make sure you have the latest version installed by running `helm list --namespace stackstate` (use the namespace where StackState is installed):

* Helm chart version should be `1.12.1`
* Application version should be `6.0.0-snapshot.20241023094532-stackstate-6.x-7be52ad`

If you don't have that version please upgrade first following the standard [upgrade steps](https://docs.stackstate.com/6.0/self-hosted-setup/upgrade-stackstate/steps-to-upgrade#minor-or-maintenance-stackstate-release).

## Create a configuration backup and download the backup

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

## Install and configure SUSE Observability

This is where the 2 options are different. Follow the instructions for your preferred scenario.

{% tabs %}
{% tab title="Replace StackState" %}

### Uninstall StackState

Uninstalling StackState before installing SUSE Observability has 2 advantages, first of all it frees up resources in the cluster, so no temporary extra nodes are needed. Second, it removes the ingress configuration for StackState freeing up the StackState URL to be re-used by SUSE Observability. The only disadvantage is there will be a period from this point until setting up the configuration of SUSE Observability where you won't have monitoring available with StackState nor SUSE Observability. 

Uninstalling StackState will also remove your historical data (topology and all other telemetry data too). To uninstall StackState follow the [uninstallation docs](https://docs.stackstate.com/6.0/self-hosted-setup/uninstall).

### Install SUSE Observability

Install SUSE Observability in a different namespace from StackState to avoid any conflicts. Recommended is to use the same namespace as in the documentation, `suse-observability`. 

The biggest change for installation is that there is now support for profiles, please select the profile that matches your observed cluster using the [requirements](../install-stackstate/requirements.md#resource-requirements) and use it to generate the values as documented in the installation guide. Customized Helm values for StackState are compatible with SUSE Observability. However, the values to customize resources must be removed in favor of the new profiles, we'll keep those in a file called `custom-values-no-resources.yaml`. You can use the same ingress settings, such that SUSE Observability effectively will replace StackState from a user and agent perspective.

To install SUSE Observability follow the [installation guide](../install-stackstate/kubernetes_openshift/kubernetes_install.md) with a few small modifications to the value generation to do the migration:
* use the selected profile that matches your environment and your (updated) custom values. 
* get the `global.receiverApiKey` from the StackState values and provide it as extra argument to the value generation
* for the base URL that must be provided we use the same URL as the current StackState installation: `https://stackstate.demo.stackstate.io`

So the value generation step looks like this (using our example again, with the smallest profile):
```bash
export VALUES_DIR=.
helm template \
  --set license='<your license>' \
  --set receiverApiKey='our-old-api-key' \
  --set baseUrl='https://stackstate.demo.stackstate.io' \
  --set sizing.profile='10-nonha' \
  suse-observability-values \
  suse-observability/suse-observability-values --output-dir $VALUES_DIR
```

The Helm install command is the same as in the installation docs with the option to include the `custom-values-no-resources.yaml` values file if you have any. Also make sure to include the ingress configuration values, this can be the same one as was used for StackState. In the example we'll use:

```bash
helm upgrade \
  --install \
  --namespace suse-observability \
  --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/ingress.yaml \
suse-observability \
suse-observability/suse-observability
```

{% hint style="info" %}
The installation will by default generate a new admin password. If you are running with the standard authentication and want to keep the same admin password as before you will need to specify it in the value generation step (or edit it after generating the values).
{% endhint %}

### Restore the configuration backup

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
3. Restore the backup (this will require 1Gi of memory and 1 core in the cluster), this may take a while to create a Kubernetes job and start the pod:
  ```bash
    ./restore-configuration-backup.sh sts-backup-20241024-1423.sty
  ```
  Make sure to answer `yes` to confirm removing all data is ok.
4. Scale all deployments back up:
   ```bash
   ./scale-up.sh
   ```

Now SUSE Observability has the exact same setup as StackState and we're ready to start using it. Note that, because the same URL is used, a browser refresh may be required the first time.

{% endtab %}
{% tab title="Run side-by-side" %}
In this scenario SUSE Observability will ingest new data and it is responsible to run monitors and send out notifications. StackState will only offer access to the historical data.

At some point traffic will need to be switched over from StackState to SUSE Observability. The solution that limits the impact on your users and the installed agents is to configure SUSE Observability with the URL originally used by StackState. This guide will re-use the StackState URL (`stackstate.demo.stackstate.io`) while the "old" StackState will be accessible under a new `stackstate-old.demo.stackstate.io` URL. When using an OIDC provider for authentication the `stackstate-old` URL will need to be add/updated in the OIDC provider configuration and in the StackState configuration.

It is also possible to install SUSE Observability under a new URL, in that case you'll need to update the agent and Open Telemetry collectors to use the new URL or use another method of re-routing the traffic.

To summarize, before the migration the setup is StackState running in namespace `stackstate` with URL `https://stackstate.demo.stackstate.io`. This will get migrated to:
* SUSE Observability in namespace `suse-observability` with URL `stackstate.demo.stackstate.io`, this will be the new active instance
* StackState in namespace `stackstate` with URL `https://stackstate-old.demo.stackstate.io`, this will only have historic data

### Install SUSE Observability

Install SUSE Observability in a different namespace from StackState to avoid any conflicts. Recommended is to use the same namespace as in the documentation, `suse-observability`. 

The biggest change for installation is that there is now support for profiles, please select the profile that matches your observed cluster using the [requirements](../install-stackstate/requirements.md#resource-requirements) and use it to generate the values as documented in the installation guide. Customized Helm values for StackState are compatible with SUSE Observability. However, the values to customize resources must be removed in favor of the new profiles, we'll keep those in a file called `custom-values-no-resources.yaml`. Also exclude the ingress setup from the SUSE Observability installation for now.

To install SUSE Observability follow the [installation guide](../install-stackstate/kubernetes_openshift/kubernetes_install.md) with a few small modifications to the value generation to do the migration:
* use the selected profile that matches your environment and your (updated) custom values. 
* get the `global.receiverApiKey` from the StackState values and provide it as extra argument to the value generation
* for the base URL that must be provided we use the same URL as the current StackState installation: `https://stackstate.demo.stackstate.io`

So the value generation step looks like this (using our example again, with the smallest profile):
```bash
export VALUES_DIR=.
helm template \
  --set license='<your license>' \
  --set receiverApiKey='our-old-api-key' \
  --set baseUrl='https://stackstate.demo.stackstate.io' \
  --set sizing.profile='10-nonha' \
  suse-observability-values \
  suse-observability/suse-observability-values --output-dir $VALUES_DIR
```

The Helm install command is the same as in the installation docs with the option to include the `custom-values-no-resources.yaml` values file if you have any.

{% hint style="info" %}
The installation will by default generate a new admin password. If you are running with the standard authentication and want to keep the same admin password as before you will need to specify it in the value generation step (or edit it after generating the values).
{% endhint %}

### Restore the configuration backup

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
3. Restore the backup (this will require 1Gi of memory and 1 core in the cluster), this may take a while to create a Kubernetes job and start the pod:
  ```bash
    ./restore-configuration-backup.sh sts-backup-20241024-1423.sty
  ```
  Double check that you are in the suse-observability namespace and not anymore in the StackState namespace, only then answer `yes` to confirm removing all data is ok.
4. Scale all deployments back up:
   ```bash
   ./scale-up.sh
   ```

Now SUSE Observability has the exact same setup as StackState and we're ready to start using it.


### Prepare to scale down StackState

To make sure nothing changes anymore in the old "StackState" setup and also to reduce its resource usage a number of StackState deployments must be scaled down to 0 replicas. The best way to do this is via the Helm values, in that way any other configuration change will not accidentally scale up some of the deployments again.

Create a new `scaled-down.yaml` file and store it next to your StackState `values.yaml` (or edit your existing `values.yaml` for StackState to include or update these keys):

```yaml
common:
  deployment:
    replicaCount: 0
  statefulset:
    replicaCount: 0
anomaly-detection:
  enabled: false
backup:
  enabled: false
stackstate:
  components:
    correlate:
      replicaCount: 0
    checks:
      replicaCount: 0
    healthSync:
      replicaCount: 0
    e2es:
      replicaCount: 0
    notification:
      replicaCount: 0
    receiver:
      replicaCount: 0
    state:
      replicaCount: 0
    sync:
      replicaCount: 0
    slicing:
      replicaCount: 0
    vmagent:
      replicaCount: 0
  experimental:
    server:
      split: true
opentelemetry:
  enabled: false
```

This file will be used when changing the ingress for StackState. When no agent or open telemetry data is received anymore these StackState services are not needed.

### Re-route traffic

Re-routing the traffic will switch both agent traffic and users of StackState to SUSE Observability. To do this 2 steps are needed, first switch StackState to a new URL, then configure the SUSE Observability ingress to use the original StackState URL. In between these steps SUSE Observability/StackState will temporarily be inaccessible, but the agents will cache the data and send it when they can connect again.

1. Take the ingress configuration from StackState and copy it into the values you have for SUSE Observability, or make a copy into a separate `ingress.yaml` values file, next to the generated `baseConfig_values.yaml` and `sizing_values.yaml`. 
2. Update the ingress values for StackState to use a different URL, here we change it from `stackstate` to `stackstate-old`: 
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
3. Edit the original `values.yaml` of StackState and update the `stackstate.baseUrl` value to also use the new URL (in this case `https://stackstate-old.demo.stackstate.io`).
4. Run the helm upgrade for StackState, and include the updated ingress configuration so it starts using the `stackstate-old.demo.stackstate.io` ingress. Also include the `scaled-down.yaml` values from the previous step and make sure to include all values files used during installation of StackState:
  ```
  helm upgrade \
      --install \
      --namespace stackstate \
      --values stackstate-values/values.yaml \
      --values stackstate-values/stackstate-ingress.yaml \
      --values stackstate-values/scaled-down.yaml \
    stackstate \
    stackstate/stackstate-k8s
  ```
5. Run the [helm upgrade](../install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-suse-observability-with-helm) for SUSE Observability, to start using the original `stackstate.demo.stackstate.io` URL (make sure to include all values files used during installation of SUSE Observability but now also include the `ingress.yaml`):
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

Now users can go to `https://stackstate.demo.stackstate.io` to get SUSE Observability with all the familiar StackState features and live data. The first time users may need to hit refresh to force loading of the new application.

They can go to `https://stackstate-old.demo.stackstate.io` to review historical data.

### Uninstall StackState

When the StackState installation is not needed anymore it can be uninstalled using the [uninstall procedure](https://docs.stackstate.com/6.0/self-hosted-setup/uninstall).

{% endtab %}
{% endtabs %}

## Update Open Telemetry collectors configuration

SUSE Observability has a change in its authentication. StackState used a bearer token with the scheme `StackState`, but SUSE Observability uses the scheme `SUSEObservability`. Update the values for your installed Open Telemetry Collectors to switch from:

```yaml
config:
  extensions:
    bearertokenauth:
      scheme: StackState
      token: "${env:API_KEY}"
```

to 
```yaml
config:
  extensions:
    bearertokenauth:
      scheme: SUSEObservability
      token: "${env:API_KEY}"
```

Use the updated values to upgrade the installed collectors with the `helm upgrade` command, see also [deploying the Open Telemetry Collector](../otel/collector.md#deploy-the-collector) for more details.

## Upgrade stackpacks

Navigate to `https://your-stackstate-instance/#/stackpacks/` or open the StackPacks overview via the main menu. From there go through all installed stackpacks and hit the "Upgrade" button to get the new SUSE Observability version of the stackpack.

## Migrate agents

The final step in migrating to SUSE Observability is to update all your installed agents. This does not have to be done immediately but can be done at a convenient time for each specific cluster, because SUSE Observability is backward compatible with the StackState agent.

Migrating is an easy 2 step process:
1. Uninstall the StackState agent
2. Install the SUSE Observability agent

It is important the old agent is uninstalled first, because it is not possible to run both agents at the same time. Uninstalling the agent on a cluster is done like this:

```bash
helm uninstall -n stackstate stackstate-k8s-agent
```

In case you used a different namespace or release name update the command accordingly.

Navigate to `https://your-stackstate-instance/#/stackpacks/kubernetes-v2`. Find the cluster you're upgrading the agent on in the list of StackPack instances and copy and run the helm install command for your Kubernetes distribution. If you have custom values you can include them without modification with a `--values` argument, the SUSE Observability agent values use the same naming as the StackState agent.
