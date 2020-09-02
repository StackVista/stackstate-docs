---
title: Requirements
kind: Documentation
---

# Installation requirements

## Server requirements

### Operating system

One of the following operating systems running Java. Check also the specific requirements for the [StackState Agent StackPack](../../stackpacks/integrations/agent.md):

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

### Java
OpenJDK 8 **patch level 121** or later

{% hint style="info" %}
StackState **does not work** with JDK versions 9 or higher at this time.
{% endhint %}

## Size requirements

### Production setup

The StackState production setup requires two machines to run on.

|  | MINIMUM | RECOMMENDED |
|:---|:---|:---|
| **StackState node** | <ul> <li>&gt;= 20GB of RAM</li><li>&gt;= 100GB disk space</li><li>&gt;= 4 cores CPU</li></ul> | <ul><li>32GB of RAM</li><li>500GB disk space</li><li>8 cores CPU</li></ul> |
| **StackGraph node** |<ul><li>&gt;= 16GB of RAM</li><li>&gt;= 100GB disk space</li><li>&gt;= 4 cores CPU</li></ul> | <ul><li>24GB of RAM</li><li>500GB disk space</li><li>8 cores CPU</li></ul> |

### POC setup

The POC setup runs on a single node and requires:

* 32GB of RAM
* 500GB disk space
* 8 cores CPU

### Development setup

The development setup runs on a single node and requires:

* 16GB of RAM
* 500GB disk space
* 4 cores CPU

## AWS requirements

To meet StackState minimal requirements, the AWS instance type needs to have at least:

* 4 CPU cores
* 16GB of memory, e.g., m5.xlarge.

The AWS CLI has to be installed on the EC2 instance that is running StackState.

## Networking requirements

Listed ports are TCP ports.

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

| PROCESS | PORT LIST |
|:---|:---|
| **ElasticSearch** | <ul><li>9200: HTTP api</li><li>9300: Native api</li></ul> |
| **HBase Master** | <ul><li>16000: Master client API (needs to be open for clients)</li><li>16010: Master Web UI (optional)</li></ul> |
| **HBase Region Server** | <ul><li>16020: Region client API (needs to be open for clients)</li><li>16030: Region Web UI (optional)</li></ul> |
| **HDFS DataNode** | <ul><li>50010: Datanode API (needs to be open for clients)</li><li>50020: IPC api (communication within HDFS cluster)</li><li>50075: HTTP api (optional)</li></ul> |
| **HDFS NameNode** | <ul><li>8020: File system (needs to be open for clients)</li><li>50070: Web UI (optional)</li></ul> |
| **Kafka** | <ul><li>9092: Client port</li></ul> |
| **Receiver** | <ul><li>7077: HTTP agent API (aka receiver API). When using an agent, data is sent to this endpoint.</li></ul> |
| **StackGraph ProcessManager** | <ul><li>5152: StackGraph ProcessManager, at the moment only from localhost</li></ul> |
| **StackState** |<ul><li>7070: HTTP api & user interface</li><li>7071: Admin API for health checks and admin operations. Typically you want to use this only from `localhost`</li></ul> |
| **StackState ProcessManager** | <ul><li>5154: StackState ProcessManager, at the moment only from localhost</li></ul> |
| **Tephra Transaction service** | <ul><li>15165: Client API</li></ul> |
| **Zookeeper** | <ul><li>2181: Client API</li><li>2888: Zookeeper peers (general communication), only when running a cluster</li><li>3888: Zookeeper peers (leader election), only when running a cluster</li></ul> |


## Client (browser) requirements

To use the StackState GUI, you must use one of the following web browsers:

* Chrome
* Firefox
