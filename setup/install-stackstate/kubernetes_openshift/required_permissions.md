---
description: StackState Self-hosted v5.1.x 
---

# Required Permissions

## Overview

All of StackState's own components can run without any extra permissions. However, in order to install StackState successfully, you need some additional privileges, or ensure that the requirements described in this page are met.

## Autonomous Anomaly Detector \(AAD\)

In order to run the [Autonomous Anomaly Detector](../../../stackpacks/add-ons/aad.md), or prepare your clsuter to run it, StackState needs to create a `ClusterRole` and two `ClusterRoleBinding` resources. Creating these cluster-wide resources is often prohibited for users that are not a Kubernetes/OpenShift administrator.

### Disable automatic creation of cluster-wide resources

The automatic creation of cluster-wide resources during installation of StackState can be disabled by adding the following section to the `values.yaml` file used to install StackState:

{% tabs %}
{% tab title="values.yaml" %}
```yaml
cluster-role:
  enabled: false
anomaly-detection:
  cluster-role:
    enabled: false
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Note that if automatic creation of cluster-wide resources is disabled the Autonomous Anomaly Detector will NOT be able to authenticate against the running StackState installation unless you [manually create the cluster-wide resources](required_permissions.md#manually-create-cluster-wide-resources).
{% endhint %}

### Manually create cluster-wide resources

If you need to manually create the cluster-wide resources, ask your Kubernetes/OpenShift administrator to create the 3 resources below in the clsuter.

{% hint style="info" %}
Ensure that you specify the correct namespace for the bound `ServiceAccount` for both of the `ClusterRoleBinding` resources.
{% endhint %}

{% tabs %}
{% tab title="clusterrole-authorization.yaml" %}
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: stackstate-authorization
rules:
- apiGroups:
  - rbac.authorization.k8s.io
  resources:
  - rolebindings
  verbs:
  - list
```
{% endtab %}
{% endtabs %}

{% tabs %}
{% tab title="clusterrolebinding-authentication.yaml" %}
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: stackstate-authentication
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: stackstate-api
  namespace: stackstate
- kind: ServiceAccount
  name: anomaly-detection-sa
  namespace: stackstate
```
{% endtab %}
{% endtabs %}

{% tabs %}
{% tab title="clusterrolebinding-authorization.yaml" %}
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: stackstate-authorization
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: stackstate-authorization
subjects:
- kind: ServiceAccount
  name: stackstate-api
  namespace: stackstate
```
{% endtab %}
{% endtabs %}

## Elasticsearch

StackState uses Elasticsearch to store its indices. There are some additional requirements for the nodes that Elasticsearch runs on.

As the `vm.max_map_count` Linux system setting is usually lower than required for Elasticsearch to start, an init container is used that runs in privileged mode and as the root user. The init container is enabled by default to allow the `vm.max_map_count` system setting to be changed.

### Disable the privileged Elasticsearch init container

In case you and/or your Kubernetes/OpenShift administrators do not want the privileged Elasticsearch init container to be enabled by default, you can disable this behavior in the file `values.yaml` used to install StackState:

{% tabs %}
{% tab title="values.yaml" %}
```yaml
elasticsearch:
  sysctlInitContainer:
    enabled: false
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
If this is disabled, you will need to ensure that the `vm.max_map_count` setting is changed from its common default value of `65530` to `262144`. If this is not done, Elasticsearch will fail to start up and its pods will be in a restart loop.
{% endhint %}

To inspect the current `vm.max_map_count` setting, run the following command. Note that it runs a privileged pod:

```text
kubectl run -i --tty sysctl-check-max-map-count --privileged=true  --image=busybox --restart=Never --rm=true -- sysctl vm.max_map_count
```

If the current `vm.max_map_count` setting is not at least `262144`, it will need to be increased in a different way or Elasticsearch will fail to start up and its pods will be in a restart loop. The logs will contain an error message like this:

```text
bootstrap checks failed
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

### Increase Linux system settings for Elasticsearch

Depending on what your Kubernetes/OpenShift administrators prefer, the `vm.max_map_count` can be set to a higher default on all nodes by either changing the default node configuration \(for example via init scripts\) or by having a DaemonSet do this right after node startup. The former is very dependent on your clsuter setup, so there are no general solutions there.

Below is an example that can be used as a starting point for a DaemonSet to change the `vm.max_map_count` setting:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: set-vm-max-map-count
  labels:
    k8s-app: set-vm-max-map-count
spec:
  selector:
    matchLabels:
      name: set-vm-max-map-count
  template:
    metadata:
      labels:
        name: set-vm-max-map-count
    spec:
      # Make sure the setting always gets changed as soon as possible:
      tolerations:
      - effect: NoSchedule
        operator: Exists
      - effect: NoExecute
        key: node.kubernetes.io/not-ready
        operator: Exists
      # Optional node selector (assumes nodes for Elasticsearch are labeled `elasticsearch:yes`
      # nodeSelector:
      #  elasticsearch: yes
      initContainers:
        - name: set-vm-max-map-count
          image: busybox
          securityContext:
            runAsUser: 0
            privileged: true
          command: ["sysctl", "-w", "vm.max_map_count=262144"]
          resources:
            limits:
              cpu: 100m
              memory: 100Mi
            requests:
              cpu: 100m
              memory: 100Mi
      # A pause container is needed to prevent a restart loop of the pods in the daemonset
      # See also this Kubernetes issue https://github.com/kubernetes/kubernetes/issues/36601
      containers:
        - name: pause
          image: google/pause
          resources:
            limits:
              cpu: 50m
              memory: 50Mi
            requests:
              cpu: 50m
              memory: 50Mi
```

To limit the number of nodes that this is applied to, nodes can be labeled. NodeSelectors on both this DaemonSet, as shown in the example, and the Elasticsearch deployment can then be set to run only on nodes with the specific label. For Elasticsearch, the node selector can be specified via the values:

```yaml
elasticsearch:
  nodeSelector:
    elasticsearch: yes
  sysctlInitContainer:
    enabled: false
```

## See also

* [Autonomous Anomaly Detector](../../../stackpacks/add-ons/aad.md)
* [Install StackState on Kubernetes](kubernetes_install.md)
* [Install StackState on OpenShift](openshift_install.md)

