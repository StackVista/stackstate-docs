---
description: StackState Kubernetes Troubleshooting
---

# Override monitor threshold arguments via kubernetes annotations

## Overview

StackState provides [monitors out of the box](/use/alerting/k8s-monitors.md), which provide monitoring on common issues that can occur in a Kubernetes cluster. Those monitors work with certain default arguments that suit most of the use cases but sometimes we need to adapt its behaviour by overriding some of such default arguments  like `threshold` or `failureState`.
The mechanism to declare the overrides is via kubernetes resource annotations that denote to which monitor and component they should apply. For example we could override the `failureState` for the `Available service endpoints` monitor for a specific service where we want to signal a `CRITICAL` state when it fails rather than the default `DEVIATING`.

## How to

* [How to build an override annotation](#how-to-build-an-override-annotation)
* [What monitors allow overriding arguments?](#what-monitor-allows-overriding)

As an example the steps will override the arguments for the `Available service endpoints` monitor of Kubernetes HTTP services.

## How to build my annotation

The override annotations keys for StackState monitors follow the following convention:
```
monitor.${owner}.stackstate.io/${monitorShorName}
```
The `owner` property represents who created such a monitor, for the out of the box monitors is `kubernetes-v2`, and the `monitorShorName` property represents the id of the monitor and can be extracted from the `identifier` property of a monitor which can be read from the cli when listing or inspecting monitors
```
sts monitor list

ID              | STATUS  | IDENTIFIER                                                                          | NAME                                        | FUNCTION ID     | TAGS                                                                                  
8051105457030   | ENABLED | urn:stackpack:kubernetes-v2:shared:monitor:kubernetes-v2:service-available-endpoint | Available service endpoints                 | 233276809885571 | [services]         
```

In our example the identifier is `urn:stackpack:kubernetes-v2:shared:monitor:kubernetes-v2:service-available-endpoint` and the `monitorShorName` corresponds to the very last segment as in `service-available-endpoint` therefore the annotation key is:
```bash
monitor.kubernetes-v2.stackstate.io/service-available-endpoint
```

the annotation payload is a JSON object where the following optional arguments can be defined:
* `threshold`: optional.A numeric threshold to compare against.
* `failureState`: optional. Either "CRITICAL" or "DEVIATING". "CRITICAL" will show as read in StackState and "DEVIATING" as orange, to denote different severity.
* `enabled`: optional. Boolean that determines if the monitor would produce a health state for that component.

The full annotation then would look like
```bash
    monitor.kubernetes-v2.stackstate.io/service-available-endpoint: |-
      {
        "threshold": 0.0,
        "failureState": "CRITICAL"
        "enabled": true
      }
```

## What monitors allow overriding arguments?
* [Available service endpoints](/use/alerting/kubernetes-monitors.md#available-service-endpoints)
* [Node Disk Pressure](/use/alerting/kubernetes-monitors.md#node-disk-pressure)
* [Node Memory Pressure](/use/alerting/kubernetes-monitors.md#node-memory-pressure)
* [Node PID Pressure](/use/alerting/kubernetes-monitors.md#node-pid-pressure)
* [Node Readiness](/use/alerting/kubernetes-monitors.md#node-readiness)
* [Out of memory for containers](/use/alerting/kubernetes-monitors.md#out-of-memory-for-containers)
