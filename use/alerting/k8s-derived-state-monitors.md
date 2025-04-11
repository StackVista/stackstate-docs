---
description: SUSE Observability
---

# Derived State Monitors

## Overview

In Observability scenarios where logical (business) components lack direct monitors but are affected by issues in their technical dependencies, you can use the derived-state-monitor to propagate health states to them.
This monitor traverses component dependencies and selects the most critical health state based on direct observations (e.g., from metrics), ignoring any already-derived states. It starts from a group of components defined by `componentTypes` and propagates health upwards to the top-level logical components.
During traversal, only components with observed (non-derived) health states are considered for health propagation. Components with derived states are skipped in evaluation but still traversed to reach deeper dependencies—for example, logical components depending on other logical components.

## Derived Health State Monitor example

A Monitor implemented using the `derived-state-monitor` function looks like:

```
  - _type: "Monitor"
    name: "Aggregated health state of a Deployment, StatefulSet, ReplicaSet and DaemonSet"
    tags:
      - deployments
      - replicasets
      - statefulsets
      - daemonsets
      - derived
      - propagated
    identifier: "urn:custom:monitor:..."
    status: "DISABLED"
    description: "Description"
    function: {{ get "urn:stackpack:common:monitor-function:derived-state-monitor" }}
    arguments:
      componentTypes: "deployment, replicaset, statefulset, daemonset"
    intervalSeconds: 30
    remediationHint: "Investigate component [{{ causeName }}](/#/components/{{ causeComponentUrnForUrl }}) as is causing the workload to be unhealthy."
```
* The function has a single argument `componentTypes` where you can express the different component types as a single string of `,` separated values
* The function offers two values to use in the remediation guide, `causeName` being the component name where the state is propagated from and its `causeComponentUrnForUrl` to be able to create a link

The monitor can be implement using the guide at [Add a threshold monitor to components using the CLI](/use/alerting/k8s-add-monitors-cli.md)