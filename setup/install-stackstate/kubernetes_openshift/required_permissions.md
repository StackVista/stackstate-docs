---
description: Rancher Observability Self-hosted
---

# Required Permissions

## Overview

All of Rancher Observability's own components can run without any extra permissions. However, to install Rancher Observability successfully, you need some additional privileges, or ensure that the requirements described in this page are met.

## Service-to-service authentication and authorization

To allow communication between Rancher Observability services Rancher Observability uses Kubernetes service accounts. To be able to verify their validity and roles the helm chart creates a `ClusterRole` and a `ClusterRoleBinding` resources. Creating these cluster-wide resources is often prohibited for users that aren't a Kubernetes/OpenShift administrator. For that case the creation can be disabled and instead the roles and role bindings need to be [created manually](required_permissions.md#manually-create-cluster-wide-resources) by your cluster admin.

### Disable automatic creation of cluster-wide resources

The automatic creation of cluster-wide resources during installation of Rancher Observability can be disabled by adding the following section to the `values.yaml` file used to install Rancher Observability:

{% tabs %}
{% tab title="values.yaml" %}
```yaml
cluster-role:
  enabled: false
```
{% endtab %}
{% endtabs %}

{% hint style="info" %}
If the creation of the cluster role and cluster role binding has been disabled please make sure to follow the instructions below to manually create them using the [instructions below](required_permissions.md#manually-create-cluster-wide-resources).
{% endhint %}

### Manually create cluster-wide resources

If you need to manually create the cluster-wide resources, ask your Kubernetes/OpenShift administrator to create the 3 resources below in the clsuter.

{% hint style="info" %}
Verify that you specify the correct service account and namespace for the bound `ServiceAccount` for both of the `ClusterRoleBinding` resources. The example assumes the `stackstate` namespace is used, if some other namespace is used changed the namespace in the examples. Also the service accounts referenced need to be changed to `<namespace>-stackstate-k8s-api`.
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
  name: stackstate-stackstate-k8s-api
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
  name: stackstate-stackstate-k8s-api
  namespace: stackstate
```
{% endtab %}
{% endtabs %}

## Elasticsearch

Rancher Observability uses Elasticsearch to store its indices. There are some additional requirements for the nodes that Elasticsearch runs on.

As the `vm.max_map_count` Linux system setting is usually lower than required for Elasticsearch to start, an init container is used that runs in privileged mode and as the root user. The init container is enabled by default to allow the `vm.max_map_count` system setting to be changed.

### Disable the privileged Elasticsearch init container

In case you or your Kubernetes/OpenShift administrators don't want the privileged Elasticsearch init container to be enabled by default, you can disable this behavior in the file `values.yaml` used to install Rancher Observability:

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
If this is disabled, you will need to ensure that the `vm.max_map_count` setting is changed from its common default value of `65530` to `262144`. If this isn't done, Elasticsearch will fail to start up and its pods will be in a restart loop.
{% endhint %}

To inspect the current `vm.max_map_count` setting, run the following command. Note that it runs a privileged pod:

```text
kubectl run -i --tty sysctl-check-max-map-count --privileged=true  --image=busybox --restart=Never --rm=true -- sysctl vm.max_map_count
```

If the current `vm.max_map_count` setting isn't at least `262144`, it will need to be increased in a different way or Elasticsearch will fail to start up and its pods will be in a restart loop. The logs will contain an error message like this:

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

* [Install Rancher Observability on Kubernetes](kubernetes_install.md)
* [Install Rancher Observability on OpenShift](openshift_install.md)

