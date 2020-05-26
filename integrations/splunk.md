---
title: Splunk StackPack
kind: documentation
---

## What is the Splunk StackPack?

The Splunk StackPack synchronizes topology, events and metrics from Splunk to StackState.

## Prerequisites

The Splunk StackPack depends on the [API Integration](/integrations/api-integration) StackPack.

## Synchronizing data from Splunk

The Splunk StackPack synchronizes different types of data from Splunk to StackState. The Splunk StackPack requires the API Integration StackPack and agent to be installed. Using specific checks, the Splunk StackPack periodically retrieves selected data from Splunk and stores it in StackState.

The Splunk StackPack supports three different types of information:

* build **topology** out of Splunk data
* retrieve **events** from Splunk
* retrieve **metrics** from Splunk

### Synchronizing Splunk topology

See [Splunk Topology integration](/integrations/splunk_topology) for more information.

### Synchronizing Splunk events

See [Splunk Events integration](/integrations/splunk_event) for more information.

### Synchronizing Splunk metrics

See [Splunk Metrics integration](/integrations/splunk_metric) for more information.
