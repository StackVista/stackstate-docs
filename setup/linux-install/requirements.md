---
title: Requirements
kind: Documentation
---

# Installation requirements

## Server requirements

* **Operating system:** one of the following operating systems running Java:

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

* **Java:**
  * OpenJDK 8 **patch level 121** or later

**NOTE**: StackState **does not work** with JDK versions 9 or higher at this time.

**NOTE**: The StackState Agent StackPack has [more specific requirements](/stackpacks/integrations/agent.md).

## Size requirements

### Production setup

The StackState production setup requires two machines to run on.

#### Minimal requirements

**StackState node**

* &gt;= 20GB of RAM
* &gt;= 100GB disk space
* &gt;= 4 cores cpu

**StackGraph node**

* &gt;= 16gb of RAM
* &gt;= 100GB disk space
* &gt;= 4 cores cpu

#### Recommended

**StackState node**

* 32GB of RAM
* 500GB disk space
* 8 cores cpu

#### StackGraph node

* 24GB of RAM
* 500GB disk space
* 8 cores cpu

### POC setup

The POC setup runs on a single node

#### Requirements

* 32GB of RAM
* 500GB disk space
* 8 cores cpu

### Development setup

The development setup runs on a single node

#### Requirements

* 16GB of RAM
* 500GB disk space
* 4 cores cpu

## AWS requirements

To meet StackState minimal requirements the AWS instance type needs to have at least 4 CPU cores and 16GB of memory, e.g., m5.xlarge.

The AWS CLI has to be installed on the EC2 instance that is running StackState.

## Networking requirements

Listed ports are TCP ports.

### Development/POC deployment

StackState has to be reachable on port 7070 by any supported browser. StackState port 7077 must be reachable from any system that is pushing data to StackState

The following ports can be opened for monitoring, but are also useful when troubleshooting: 9001, 9002, 9003, 9004, 9005, 9006, 9010, 9011, 9020, 9021, 9022, 9023, 9024, 9025, 9026, 16010, 16030, 50070, 50075

### Production deployment

A production deployment separates StackState and StackState's database processes; StackGraph.

StackState has to be reachable on port 7070 by any supported browser. StackState port 7077 must be reachable from any system that is pushing data to StackState

StackGraph should be reachable by StackState on ports 2181, 8020, 15165, 16000, 16020, 50010.

The following ports can be opened for monitoring, but are also useful when troubleshooting:

* StackSate: 9010, 9011, 9020, 9021, 9022, 9023, 9024, 9025, 9026
* StackGraph: 9001, 9002, 9003, 9004, 9005, 9006, 16010, 16030, 50070, 50075

### Port list per process

Detailed information about ports per process.

#### StackState

* 7070: HTTP api & user interface
* 7071: Admin API for health checks and admin operations. Typically you want to use this only from `localhost`

#### Receiver

* 7077: HTTP agent API \(aka receiver API\). When using an agent, data is sent to this endpoint.

#### Kafka

* 9092: Client port

#### Elasticsearch

* 9200: HTTP api
* 9300: Native api

#### Zookeeper

* 2181: Client API
* 2888: Zookeeper peers \(general communication\), only when running a cluster
* 3888: Zookeeper peers \(leader election\), only when running a cluster

#### HBase Master

* 16000: Master client api \(needs to be open for clients\)
* 16010: Master Web UI \(optional\)

#### HBase Region server

* 16020: Region client API \(needs to be open for clients\)
* 16030: Region Web UI \(optional\)

#### HDFS NameNode

* 8020: File system \(needs to be open for clients\)
* 50070: Web UI \(optional\)

#### HDFS DataNode

* 50010: Datanode API \(needs to be open for clients\)
* 50020: IPC api \(communication within HDFS cluster\)
* 50075: HTTP api \(optional\)

#### Tephra Transaction service

* 15165: Client API

#### StackState ProcessManager

* 5154: StackState ProcessManager, at the moment only from localhost

#### StackGraph ProcessManager

* 5152: StackGraph ProcessManager, at the moment only from localhost

## Client requirements

To use the StackState GUI, you must use one of the following web browsers:

* Chrome
* Firefox
