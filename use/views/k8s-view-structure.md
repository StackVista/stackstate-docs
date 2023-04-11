---
description: StackState for Kubernetes troubleshooting
---

# View structure

## Overview

A view in StackState allows you to monitor and inspect a subset of your IT environment. The structure of a view is tailored towards filtering and visualizing the data in that subset (view) in an efficient way.

### Filters

The **Filters** menu on the top right corner of the view UI allows you to filter the components (topology), events and traces displayed in a view. Once applied, the filters will affect the content of all the perspectives in a view.

* [Filters](k8s-filters.md) - Filter the components (topology), events and traces in your view

### Perspectives

The **Perspectives** of a view are displayed as tabs on the top left corner of the view UI and allow you to visualize all the data in a view through different lenses:

* [Overview or Highlights perspective](k8s-landing-perspective.md) - depending on the type of view
* [Topology perspective](k8s-topology-perspective.md) - the dependency map of the view components
* [Events perspective](k8s-events-perspective.md) - all the events happening on the topology
* [Metrics perspective](k8s-metrics-perspective.md) - key metrics for the most relevant components
* [Traces perspective](k8s-traces-perspective.md) - the tracing information running on the topology

{% hint style="info" %}
**All the perspectives** will update their content based on the view _filters_ and _timeline_ configuration.
{% endhint %}