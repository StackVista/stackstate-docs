---
title: Requirements
kind: Documentation
---

# Requirements

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

OpenJDK 8 **patch level 121** or later.

{% hint style="info" %}
StackState **does not work** with JDK versions 9 or higher at this time.
{% endhint %}

## Size requirements

### Production setup

The StackState production setup requires two machines to run on.

<table>
  <thead>
    <tr>
      <th style="text-align:left"></th>
      <th style="text-align:left">MINIMUM</th>
      <th style="text-align:left">RECOMMENDED</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><b>StackState node</b>
      </td>
      <td style="text-align:left">
        <p>&gt;= 20GB of RAM</p>
        <p>&gt;= 100GB disk space</p>
        <p>&gt;= 4 cores CPU</p>
      </td>
      <td style="text-align:left">
        <p>32GB of RAM</p>
        <p>500GB disk space</p>
        <p>8 cores CPU</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>StackGraph node</b>
      </td>
      <td style="text-align:left">
        <p>&gt;= 16GB of RAM</p>
        <p>&gt;= 100GB disk space</p>
        <p>&gt;= 4 cores CPU</p>
      </td>
      <td style="text-align:left">
        <p>24GB of RAM</p>
        <p>500GB disk space</p>
        <p>8 cores CPU</p>
      </td>
    </tr>
  </tbody>
</table>

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

<table>
  <thead>
    <tr>
      <th style="text-align:left">PROCESS</th>
      <th style="text-align:left">PORT LIST</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><b>ElasticSearch</b>
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
      <td style="text-align:left">7077: HTTP agent API (aka receiver API). When using an agent, data is
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

## Client \(browser\) requirements

To use the StackState GUI, you must use one of the following web browsers:

* Chrome
* Firefox

