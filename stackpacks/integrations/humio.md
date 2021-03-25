# Humio

{% hint style="warning" %}

**This page describes StackState version 4.2**<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Humio StackPack?

The Humio StackPack allows you to access your logs stored in Humio.

Using this StackPack, you can:

* Jump straight to your container logs in Humio using a Quick Action on docker container components running in Kubernetes

## Prerequisites

* A Humio cloud account
* The Humio Kubernetes agent, see the [Humio Kubernetes platform integration](https://docs.humio.com/integrations/ingest-logs-from-a-specific-system/kubernetes/).
* Logging from each Kubernetes cluster must be stored in a **repository with the same name as your cluster** in Humio.

## Using the Humio StackPack

Navigate to your Kubernetes cluster in StackState and use a Quick Action on one of the containers to jump into your logs.

