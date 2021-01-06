---
description: install StackState on OpenShift
---

# Install StackState

## Before you start

Before you start the installation of StackState:

* Check that your OpenShift environment meets the [requirements](../../requirements.md)
* Request access credentials to pull the StackState Docker images from [StackState support](https://support.stackstate.com/).
* Ensure you have the OpenShift command line tools installed (`oc`)
* Add the StackState helm repository to the local helm client:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

## Install StackState

1. [Create the project where StackState will be installed](openshift_install.md#create-project)
2. [Generate the `values.yaml` file](openshift_install.md#generate-values-yaml)
3. [Additional OpenShift values file](openshift_install.md#additional-openshift-values-file)
4. [Deploy StackState with Helm](openshift_install.md#deploy-stackstate-with-helm)
5. [Access the StackState UI](openshift_install.md#access-the-stackstate-ui)

### Create project

Start by creating the project where you want to install StackState. In our walkthrough we will use the namespace `stackstate`:

```text
oc new-project stackstate
```

### Generate `values.yaml`

The `values.yaml` is required to deploy StackState with Helm. It contains your StackState license key, API key and other important information. The `generate_values.sh` script in the [installation directory](https://github.com/StackVista/helm-charts/tree/master/stable/stackstate/installation) of the Helm chart will guide you through generating the file.

{% hint style="info" %}
**Before you continue:** If you didn't already, make sure you have the latest version of the Helm chart with `helm repo update`.
{% endhint %}

You can run the `generate_values.sh` script in two ways:

* **Interactive mode:** When the script is run without any arguments, it will guide you through the required configuration items.

  ```text
  ./generate_values.sh
  ```

* **Non-interactive mode:** Run the script with the flag `-n` to pass configuration on the command line, this is useful for scripting.

  ```text
  ./generate_values.sh -n <configuration options>
  ```

The script requires the following configuration options:

| Configuration | Flag | Description |
| :--- | :--- | :--- |
| Base URL | `-b` | The external URL for StackState that users and agents will use to connect. For example `https://stackstate.internal`.  If you haven't decided on an Ingress configuration yet, use `http://localhost:8080`. This can be updated later in the generated file. |
| Username and password\*\* | `-u` `-p` | The username and password used by StackState to pull images from quay.io/stackstate repositories. |
| License key | `-l` | The StackState license key. |
| Admin API password | `-a` | The password for the admin API. Note that this API contains system maintenance functionality and should only be accessible by the maintainers of the StackState installation. This can be omitted from the command line, the script will prompt for it. |
| Default password | `-d` | The password for the default user \(`admin`\) to access StackState's UI. This can be omitted from the command line, the script will prompt for it. |
| Kubernetes cluster name | `-k` | *NOTE: For OpenShift do not enable this* |

The generated file is suitable for a production setup \(i.e. redundant storage services\). It is also possible to create smaller deployments for test setups, see [development setup](development_setup.md).

{% hint style="info" %}
Store the `values.yaml` file somewhere safe. You can reuse this file for upgrades, which will save time and \(more importantly\) will ensure that StackState continues to use the same API key. This is desirable as it means agents and other data providers for StackState will not need to be updated.
{% endhint %}

### Additional OpenShift values file

Because OpenShift has a more strict security model than plain Kubernetes, all of the standard security contexts in the deployment need to be disabled.
Furthermore, the StackState installation needs to add two specific OpenShift `SecurityContextConfiguration` objects to the OpenShift installation. If you're installing using an administrator account it is possible to automatically create this.

| Pod(s) | Config key | Description |
| :--- | :--- | :--- |
| The Agent that runs the Kubernetes checks | `cluster-agent.agent.scc.enabled` | This process needs to run a privileged container with direct access to the host(network) and volumes. |
| The HBase HDFS namenodes | `hbase.hdfs.scc.enabled` | These processes need to be able to run a `chmod` on their volumes and run with a specific (pre-known) UID, in order for the clients to write to the store. |

If you're _not_ using an administrator account, Please follow the [instructions below](openshift_install.md#manually-create-securitycontextconfiguration-objects) to first install the `SecurityContextConfiguration` objects in OpenShift. After that install the StackState Helm chart with the above flags set to `false`.

The values that are needed for an OpenShift deployment are:

```yaml
stackstate:
  components:
    all:
      securityContext:
        enabled: false
    kafkaTopicCreate:
      securityContext:
        enabled: false
    ui:
      securityContext:
        enabled: false
  stackpacks:
    installed:
      - name: openshift
        configuration:
          openshift_cluster_name: <CLUSTER_NAME>
elasticsearch:
  securityContext:
    enabled: false
  sysctlInitContainer:
    enabled: false
kafka:
  podSecurityContext:
    enabled: false
  volumePermissions:
    enabled: false
hbase:
  hdfs:
    scc:
      enabled: true
    securityContext:
      enabled: true
    volumePermissions:
      enabled: true
      securityContext:
        enabled: true
        privileged: false
  hbase:
    securityContext:
      enabled: false
  console:
    securityContext:
      enabled: false
  tephra:
    securityContext:
      enabled: false
zookeeper:
  securityContext:
    enabled: false
cluster-agent:
  agent:
    scc:
      enabled: true
  enabled: true
  stackstate:
    cluster:
      name: <CLUSTER_NAME>
      authToken: <RANDOM_TOKEN>
  kube-state-metrics:
    podAnnotations:
      ad.stackstate.com/kube-state-metrics.check_names: '["kubernetes_state"]'
      ad.stackstate.com/kube-state-metrics.init_configs: '[{}]'
      ad.stackstate.com/kube-state-metrics.instances: '[{"kube_state_url":"http://%%host%%:%%port%%/metrics","labels_mapper":{"namespace":"kube_namespace","label_deploymentconfig":"oshift_deployment_config","label_deployment":"oshift_deployment"},"label_joins":{"kube_pod_labels":{"label_to_match":"pod","labels_to_get":["label_deployment","label_deploymentconfig"]}}}]'
    securityContext:
      enabled: false
```

Two placeholders in this file need to be given a value before this can be applied to the Helm installation:

- `<CLUSTER_NAME>`: A name that StackState will use to identify the cluster
- `<RANDOM_TOKEN>`: A 32 character random token. This can be generated by executing `head -c32 < /dev/urandom | md5sum  | cut -c-32`

Store this file next to the generated `values.yaml` file and name it `openshift-values.yaml`


## Manually create SecurityContextConfiguration objects

If you cannot use an administrative account to install StackState on OpenShift, ask your administrator to apply the below `SecurityContextConfiguration` objects.

{% tabs %}
{% tab title="hdfs-scc.yaml" %}
```yaml
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: true
allowPrivilegedContainer: false
allowedCapabilities: null
apiVersion: security.openshift.io/v1
defaultAddCapabilities: null
fsGroup:
  type: RunAsAny
groups: []
kind: SecurityContextConstraints
metadata:
  name: stackstate-hdfs-scc
priority: 10
readOnlyRootFilesystem: false
requiredDropCapabilities:
- MKNOD
runAsUser:
  type: RunAsAny
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: RunAsAny
users: []
volumes:
- configMap
- downwardAPI
- emptyDir
- persistentVolumeClaim
- projected
- secret
```
{% endtab %}

{% tab title="agent-scc.yaml" %}
```yaml
allowHostDirVolumePlugin: true
allowHostIPC: true
allowHostNetwork: true
allowHostPID: true
allowHostPorts: true
allowPrivilegeEscalation: true
allowPrivilegedContainer: true
allowedCapabilities: []
allowedUnsafeSysctls:
- '*'
apiVersion: security.openshift.io/v1
defaultAddCapabilities: null
fsGroup:
  type: MustRunAs
groups: []
kind: SecurityContextConstraints
metadata:
  name: stackstate-agent-scc
priority: null
readOnlyRootFilesystem: false
requiredDropCapabilities: null
runAsUser:
  type: MustRunAsRange
seLinuxContext:
  type: RunAsAny
  seLinuxOptions:
    user: "system_u"
    role: "system_r"
    type: "spc_t"
    level: "s0"
seccompProfiles: []
supplementalGroups:
  type: RunAsAny
users:
volumes:
  - configMap
  - downwardAPI
  - emptyDir
  - hostPath
  - secret
```
{% endtab %}
{% endtabs %}

After these are applied, as administrator, execute the following commands to grant the service accounts access to these `SecurityContextConfiguration`s:

```text
> oc adm policy add-scc-to-user stackstate-agent-scc system:serviceaccount:stackstate:stackstate-cluster-agent-agent
> oc adm policy add-scc-to-user stackstate-hdfs-scc system:serviceaccount:stackstate:stackstate-hbase-hdfs
```

Once this is done, you can continue with the installation of the StackState Helm chart on OpenShift.

## See also

- [Manage a StackState Kubernetes installation](/setup/installation/kubernetes_install/README.md)
