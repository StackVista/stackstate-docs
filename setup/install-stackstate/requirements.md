---
description: StackState Self-hosted v5.0.x
---

# Requirements

## Overview

This page details the requirements for all supported installations of StackState:

* [Kubernetes and OpenShift](#kubernetes-and-openshift)
* [KOTS](#kots)
* [Linux](#linux)

Requirements for [networking](#networking) and the [StackState client \(browser\)](#client-browser) can be found at the bottom of the page.

## Kubernetes and OpenShift

### Supported versions

StackState can be installed on a Kubernetes or OpenShift cluster using the Helm charts provided by StackState. These Helm charts require Helm v3.x to install and are supported on:

* **Amazon Elastic Kubernetes Service (EKS):** 1.19 to 1.21
* **Azure Kubernetes Service (AKS):** 1.19 to 1.21
* **OpenShift:** 4.8 to 4.9

### Node sizing

For a standard deployment, the StackState Helm chart will deploy backend services in a redundant setup with 3 instances of each service. The number of nodes required for environments with out-of-the-box settings are listed below, note that these may change based on system tuning:

{% tabs %}
{% tab title="Recommended setup" %}
Requirements for the recommended high availability setup:

* **Amazon EKS:** 8 instances of type `m5.2xlarge` or `m4.2xlarge`
* **Azure AKS:** 8 instances of type `D8s v3` or `D8as V4` \(Intel or AMD CPUs\)
* **Virtual machines:** 8 nodes with `32GB memory`, `8 vCPUs`
{% endtab %}

{% tab title="Minimal setup" %}
Requirements for the minimal high availability setup: 

* **Amazon EKS:** 5 instances of type `m5.2xlarge` or `m4.2xlarge`
* **Azure AKS:** 5 instances of type `D8s v3` or `D8as V4` \(Intel or AMD CPUs\)
* **Virtual machines:** 5 nodes with `32GB memory`, `8 vCPUs`
{% endtab %}

{% tab title="Non-high availability setup" %}
Optionally, a [non-high availability setup](/setup/install-stackstate/kubernetes_install/non_high_availability_setup.md) can be configured which has the following requirements:

* **Amazon EKS:** 4 instances of type `m5.2xlarge` or `m4.2xlarge`
* **Azure AKS:** 4 instances of type `D8s v3` or `D8as V4` \(Intel or AMD CPUs\)
* **Virtual machines:** 4 nodes with `32GB memory`, `8 vCPUs`
{% endtab %}
{% endtabs %}

### Docker images

For a list of all Docker images used, see the [image overview](/setup/install-stackstate/kubernetes_install/image_configuration.md).

### Storage

StackState uses persistent volume claims for the services that need to store data. The default storage class for the cluster will be used for all services unless this is overridden by values specified on the command line or in a `values.yaml` file. All services come with a pre-configured volume size that should be good to get you started, but can be customized later using variables as required.

For more details on the defaults used, see the page [Configure storage](/setup/install-stackstate/kubernetes_install/storage.md).

### Ingress

By default, the StackState Helm chart will deploy a router pod and service. This service's port `8080` is the only entry point that needs to be exposed via Ingress. You can access StackState without configuring Ingress by forwarding this port:

```text
kubectl port-forward service/<helm-release-name>-distributed-router 8080:8080
```

When configuring Ingress, make sure to allow for large request body sizes \(50MB\) that may be sent occasionally by data sources like the StackState Agent or the AWS integration.

For more details on configuring Ingress, have a look at the page [Configure Ingress docs](/setup/install-stackstate/kubernetes_install/ingress.md).

### Namespace resource limits

It is not recommended to set a ResourceQuota as this can interfere with resource requests. The resources required by StackState will vary according to the features used, configured resource limits and dynamic usage patterns, such as Deployment or DaemonSet scaling.

If it is necessary to set a ResourceQuota for your implementation, the namespace resource limit should be set to match the node sizing requirements. For example, using the recommended node sizing for virtual machines \(6 nodes with `32GB memory`, `8 vCPUs`\), the namespace resource limit should be `6*32GB = 192GB` and `6*8 vCPUs = 48 vCPUs`.


## KOTS 

### Operating system

KOTS requires a VM running a [supported OS \(kurl.sh\)](https://kurl.sh/docs/install-with-kurl/system-requirements).

### Disk Partitioning 

For a KOTS deployment, the disks should be partitioned as follows:

* `/` - at least 80GB
* `/var/lib/longhorn` - at least 500GB 

### Latency

The `/var/lib/longhorn` disk should have a latency of less than 10ms. 

For example, the cloud VM instance/disk combinations below are known to provide sufficient performance for etcd and will pass the write latency preflight check.

* **Amazon:** `m4.x2large` with 80 GB standard EBS root device
* **Azure:** `D8as V4` with 80 GB ultra disk mounted at `/var/lib/etcd` provisioned with 2400 IOPS and 128 MB/s throughput
* **Google Cloud Platform:** `n1-standard-8` with 500 GB pd-standard boot disk

### Node sizing

For a standard deployment, KOTS deploys backend services in a redundant setup with 3 instances of each service. The nodes required for different environments are listed below:

{% tabs %} 
{% tab title="Recommended setup" %} 
Requirements for the recommended high availability setup:

* **Amazon EC2:** 8 instances of type `m5.2xlarge` or `m4.2xlarge`
* **Azure:** 8 instances of type `D8s v3` or `D8as V4` (Intel or AMD CPUs)
* **Virtual machines**: 8 nodes with 32GB memory, 8 vCPUs

{% endtab %}
{% tab title="Minimal setup" %} 
Requirements for the recommended high availability setup:

* **Amazon EC2:** 5 instances of type `m5.2xlarge` or `m4.2xlarge`
* **Azure:** 5 instances of type `D8s v3` or `D8as V4` (Intel or AMD CPUs)
* **Virtual machines:** 5 nodes with 32GB memory, 8 vCPUs

{% endtab %}
{% endtabs %}

## Linux

### Server requirements

#### Operating system

One of the following operating systems running Java. Check also the specific requirements for the [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md):

| OS | Release |
| :--- | :--- |
| Ubuntu | Bionic |
| Ubuntu | Xenial |
| Ubuntu | Trusty |
| Fedora | 28 |
| CentOS | 7 |
| Debian | Stretch |
| Red Hat | 7.5 |
| Amazon Linux | 2 |

#### Java

OpenJDK 8 **patch level 121** or later.

{% hint style="info" %}
StackState **does not work** with JDK versions 9 or higher at this time.
{% endhint %}

### Size requirements

* [Production setup](requirements.md#production-setup)
* [POC setup](requirements.md#poc-setup)
* [Development setup](requirements.md#development-setup)

#### Production setup

The StackState production setup runs on two machines and requires:

**StackState node**:

* 32GB of RAM
* 500GB disk space (available under `/opt/stackstate`)
* 8 cores CPU

**StackGraph node**:

* 24GB of RAM
* 500GB disk space (available under `/opt/stackstate`)
* 8 cores CPU

#### POC setup

The POC setup runs on a single node and requires:

* 32GB of RAM
* 500GB disk space (available under `/opt/stackstate`)
* 8 cores CPU

#### Development setup

The development setup runs on a single node and requires:

* 16GB of RAM
* 500GB disk space (available under `/opt/stackstate`)
* 4 cores CPU

### AWS requirements

To meet StackState minimal requirements, the AWS instance type needs to have at least:

* 4 CPU cores
* 16GB of memory, e.g., m5.xlarge.

The AWS CLI has to be installed on the EC2 instance that is running StackState.

## Networking

{% hint style="info" %}
All listed ports are TCP ports.
{% endhint %}

### Production deployment

A production deployment separates StackState and StackState's database processes; StackGraph.

StackState has to be reachable on port 7070 by any supported browser. StackState port 7077 must be reachable from any system that is pushing data to StackState

StackGraph should be reachable by StackState on ports 2181, 8020, 15165, 16000, 16020, 50010.

The following ports can be opened for monitoring, but are also useful when troubleshooting:

* **StackState:** 9010, 9011, 9020, 9021, 9022, 9023, 9024, 9025, 9026
* **StackGraph:** 9001, 9002, 9003, 9004, 9005, 9006, 16010, 16030, 50070, 50075

### Development/POC deployment

StackState has to be reachable on port 7070 by any supported browser. StackState port 7077 must be reachable from any system that is pushing data to StackState

The following ports can be opened for monitoring, but are also useful when troubleshooting: 9001, 9002, 9003, 9004, 9005, 9006, 9010, 9011, 9020, 9021, 9022, 9023, 9024, 9025, 9026, 16010, 16030, 50070, 50075

### Port list per process

Detailed information about ports per process.

<table>
  <thead>
    <tr>
      <th style="text-align:left">PROCESS</th>
      <th style="text-align:left">PORT LIST</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><b>Elasticsearch</b>
      </td>
      <td style="text-align:left">
        <p>9200: HTTP api</p>
        <p>9300: Native api</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>HBase Master</b>
      </td>
      <td style="text-align:left">
        <p>16000: Master client API (needs to be open for clients)</p>
        <p>16010: Master Web UI (optional)</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>HBase Region Server</b>
      </td>
      <td style="text-align:left">
        <p>16020: Region client API (needs to be open for clients)</p>
        <p>16030: Region Web UI (optional)</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>HDFS DataNode</b>
      </td>
      <td style="text-align:left">
        <p>50010: Datanode API (needs to be open for clients)</p>
        <p>50020: IPC api (communication within HDFS cluster)</p>
        <p>50075: HTTP api (optional)</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>HDFS NameNode</b>
      </td>
      <td style="text-align:left">
        <p>8020: File system (needs to be open for clients)</p>
        <p>50070: Web UI (optional)</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>Kafka</b>
      </td>
      <td style="text-align:left">9092: Client port</td>
    </tr>
    <tr>
      <td style="text-align:left"><b>Receiver</b>
      </td>
      <td style="text-align:left">7077: HTTP Agent API (aka receiver API). When using the StackState Agent, data is
        sent to this endpoint.</td>
    </tr>
    <tr>
      <td style="text-align:left"><b>StackGraph ProcessManager</b>
      </td>
      <td style="text-align:left">5152: StackGraph ProcessManager, at the moment only from localhost</td>
    </tr>
    <tr>
      <td style="text-align:left"><b>StackState</b>
      </td>
      <td style="text-align:left">
        <p>7070: HTTP api &amp; user interface</p>
        <p>7071: Admin API for health checks and admin operations. Typically you
          want to use this only from `localhost`</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>StackState ProcessManager</b>
      </td>
      <td style="text-align:left">5154: StackState ProcessManager, at the moment only from localhost</td>
    </tr>
    <tr>
      <td style="text-align:left"><b>Tephra Transaction service</b>
      </td>
      <td style="text-align:left">15165: Client API</td>
    </tr>
    <tr>
      <td style="text-align:left"><b>Zookeeper</b>
      </td>
      <td style="text-align:left">
        <p>2181: Client API</p>
        <p>2888: Zookeeper peers (general communication), only when running a cluster</p>
        <p>3888: Zookeeper peers (leader election), only when running a cluster</p>
      </td>
    </tr>
  </tbody>
</table>

## Client \(browser\)

To use the StackState GUI, you must use one of the following web browsers:

* Chrome
* Firefox
