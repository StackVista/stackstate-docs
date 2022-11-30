---
description: StackState Self-hosted v5.1.x
---

# Tune topology synchronization performance

## Overview

This guide lays out steps to tune topology synchronization for best performance on a Kubernetes deployment of StackState.

To tune the topology synchronization performance, follow these steps:

1. [Observe topology synchronization performance](#observe-topology-synchronization-performance)
2. [Investigate StackState platform as the bottleneck](#investigate-stackstate-platform-as-the-bottleneck)
3. [Change the topology synchronization CPU budget](#change-the-topology-synchronization-cpu-budget)

This process can be repeated until the desired performance is achieved.

## Observe topology synchronization performance

To understand how a topology synchronization is performing, use the [`stac` CLI](/setup/cli/README.md) to take a look at the synchronization's status page. The status page shows the latency of a topology synchronization. This is the amount of time that it took from data being collected at the source, to the moment that the data is stored by the topology synchronization framework. Typically, a lower latency is preferred, however, a higher latency might be acceptable when synchronizing topology from bigger data lakes.

{% tabs %}
{% tab title="CLI: stac (deprecated)" %}

1. Get the urn of a synchronization using the `stac topology list` command.
    ```javascript
    # List streams
    stac topology list

            Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
    ---------------  ---------------------------------------------------------------------------------------  --------  --------------------  --------------------  -------------------  -------------------  --------
    245676427469735                                                                                           Running                      0                     0                    0                    0         0
    154190823099122  urn:stackpack:stackstate-agent-v2:shared:sync:agent                                      Running                 761818                763870              1517959              1519490         0
    144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329
    ```

2. Get the status page for the synchronization using the `urn`.
    ```javascript
    > stac topology show urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate

            Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
    ---------------  ---------------------------------------------------------------------------------------  --------  --------------------  -------------------- -------------------  -------------------  --------
    144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329

    metric               value between now and 500 seconds ago  value between 500 and 1000 seconds ago    value between 1000 and 1500 seconds ago
    -----------------  ---------------------------------------  ----------------------------------------  -----------------------------------------
    latency (Seconds)                                   35.754                                    38.120                                    31.274
    ```

⚠️ **With the release of StackState v5.0, the old `sts` CLI was renamed to `stac`. The old CLI is now deprecated.**

The new `sts` CLI replaces the `stac` CLI. It's advised to install the new `sts` CLI and upgrade any installed instance of the old `sts` CLI to `stac`. For details see:

* [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running "StackState Self-Hosted only")
* [Install the new `sts` CLI and upgrade the old `sts` CLI to `stac`](/setup/cli/cli-sts.md#install-the-new-sts-cli "StackState Self-Hosted only")
* [Comparison between the CLIs](/setup/cli/cli-comparison.md "StackState Self-Hosted only")

{% endtab %}
{% tab title="CLI: sts" %}

Command not currently available in the new `sts` CLI. Use the `stac` CLI.
{% endtab %}
{% endtabs %}

## Investigate StackState platform as the bottleneck

To understand whether the StackState platform is a bottleneck when processing topology, we want to know whether the pod that does synchronization has exhausted its CPU resources. We do this using the following steps:

1. Get the configured request for the StackState topology synchroinzation pod
    ```javascript
    > kubectl get pod -l app.kubernetes.io/component=sync -o=jsonpath='{.items[*]..resources.requests.cpu}'
    2
    ```

2. Get the consumed resources
    ```
    > kubectl top pod -l app.kubernetes.io/component=sync
    NAME                               CPU(cores)   MEMORY(bytes)
    stackstate-sync-665f988dc4-sh4fp   1970m         3234Mi
    ```

In the above example, we observe that 1.970 cores are used by the synchronization pod, where 2 are requested. This means that the pod is close to its CPU budget and is likely throttled. To remedy this, follow the procedure below to change the topology synchronization CPU budget.

## Change the topology synchronization CPU budget

To modify the CPU budget for the topology synchronization, add/change the following configuration items in the [values.yaml](/setup/install-stackstate/kubernetes_openshift/customize_config.md) of your Kubernetes StackState deployment and deploy the change.

{% code lineNumbers="true" %}
```javascript
stackstate:
    components:
        sync:
            resources:
                requests:
                    cpu: 4
                limits:
                    cpu: 4
```
{% endcode %}

To guarantee performance, `requests` should ideally be set equal to `limits`. `Limits` can never be lower than `requests`.

After making this modification, [observe the synchronization performance](#observe-topology-synchronization-performance) again to be sure that the changes have had the desired effect. If not, do another iteration to further tune the synchronization.

## See also

* [Debug topology synchronization](/configure/topology/debug-topology-synchronization.md)
* [Customize values.yaml](/setup/install-stackstate/kubernetes_openshift/customize_config.md)
