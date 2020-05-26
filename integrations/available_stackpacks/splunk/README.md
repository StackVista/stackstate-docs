---
title: Splunk StackPack
kind: documentation
---

# Splunk

## What is the Splunk StackPack?

The Splunk StackPack synchronizes topology, events and metrics from Splunk to StackState.

## Prerequisites

The Splunk StackPack depends on the [API Integration](../api-integration.md) StackPack.

## Synchronizing data from Splunk

The Splunk StackPack synchronizes different types of data from Splunk to StackState. The Splunk StackPack requires the API Integration StackPack and agent to be installed. Using specific checks, the Splunk StackPack periodically retrieves selected data from Splunk and stores it in StackState.

The Splunk StackPack supports three different types of information:

* build **topology** out of Splunk data
* retrieve **events** from Splunk
* retrieve **metrics** from Splunk

### Synchronizing Splunk topology

See [Splunk Topology integration](splunk_topology.md) for more information.

### Synchronizing Splunk events

See [Splunk Events integration](splunk_event.md) for more information.

### Synchronizing Splunk metrics

See [Splunk Metrics integration](splunk_metric.md) for more information.

