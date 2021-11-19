---
title: Kubernetes StackPack
kind: documentation
---

# Kubernetes

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Kubernetes StackPack?

This StackPack is used to create a near real-time synchronization of topology and their internal services from a Kubernetes cluster to StackState.

## Functionality

The StackState Kubernetes Cluster Agent StackPack provides the following functionality:

* Reporting the different type of workloads.
* Reporting nodes, pods, containers and services.

## Installation

To install the Kubernetes Stackpack, please go through the below steps.

### Prerequisites

The following prerequisites are required for manual installation:

* A Kubernetes Cluster must be up and running.
* `Kubectl(1.14+)` binary
* Cluster KubeConfig must be properly set in the path.

### Enable Kubernetes state

To gather your kube-state metrics:

1. Download **Kube-State v.1.8.0 manifests zip file** from the Kubernetes StackPack configuration page in your StackState instance
2. Apply:

   ```text
   kubectl apply -f <NAME_OF_THE_KUBE_STATE_MANIFESTS_FOLDER>
   ```

### Kubernetes compatibility matrix

| kube-state-metrics | **1.13** | **1.14** | **1.15** | **1.16** | **1.17** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **v1.6.0** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **v1.7.2** | ✅ | ✅ | ❌ | ❌ | ❌ |
| **v1.8.0** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **v1.9.5** | ❌ | ❌ | ❌ | ✅ | ❌ |
| **master** | ❌ | ❌ | ❌ | ✅ | ✅ |

* ✅ Fully supported version range.
* ❌ The Kubernetes cluster has features the client-go library can't use \(additional API objects, etc\).

### Manually installing the StackState Kubernetes Cluster Agent

To execute the manual installation follow these steps:

1. Download the **manual installation zip file** from the Kubernetes StackPack configuration page in your StackState instance and extract it \(if not done already\).
2. Make sure the `kubectl` binary version 1.14+ is installed.
3. From the command line run

   ```text
   ./install.sh {{config.baseUrl}}/stsAgent {{config.apiKey}}
   ```

4. Enter same `cluster-name` value as used in the input box previously when asked after running this script.

