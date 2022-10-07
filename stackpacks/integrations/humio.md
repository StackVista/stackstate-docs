---
description: StackState Self-hosted v5.1.x 
---

# Humio

## What is the Humio StackPack?

The Humio StackPack allows you to access your logs stored in Humio.

Using this StackPack, you can:

* Jump straight to your container logs in Humio using a Quick Action on docker container components running in Kubernetes

Humio is a [community integration](/stackpacks/integrations/about_integrations.md#community-integrations).

## Prerequisites

* A Humio cloud account
* The Humio Kubernetes agent, see the [Humio Kubernetes platform integration \(library.humio.com\)](hhttps://library.humio.com/humio-server/log-formats-kubernetes.html).
* Logging from each Kubernetes cluster must be stored in a **repository with the same name as your cluster** in Humio.

## Using the Humio StackPack

Navigate to your Kubernetes cluster in StackState and use a Quick Action on one of the containers to jump into your logs.

