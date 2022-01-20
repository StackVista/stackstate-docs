---
description: StackState Self-hosted v4.5.x
---

# Tuning topology synchronization performance

This guide lays out steps to tune topology synchronization for best performance. This guide only applies to the kubernetes deployment of StackState.

## Observing topology synchronization performance

To understand how topology synchronization is performing, take a look at the status page of the synchronization you are interested in, using the [StackState CLI](/setup/cli-install.md).

```javascript
> sts topology show urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate

        Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
---------------  ---------------------------------------------------------------------------------------  --------  --------------------  -------------------- -------------------  -------------------  --------
144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329

metric               value between now and 500 seconds ago  value between 500 and 1000 seconds ago    value between 1000 and 1500 seconds ago
-----------------  ---------------------------------------  ----------------------------------------  -----------------------------------------
latency (Seconds)                                   35.754                                    38.120                                    31.274 
```

The latency shows the time it took for data collected at the source, to the moment the data is stored by topology synchronization framework. Whether this latency is good or bad depends on your wishes. Typically, a lower latency is better, but when synchronizing topology from bigger data lakes, a higher latency might be acceptable.

## Investigating StackState platform as the bottleneck

To understand whether the StackState platform is a bottleneck when processing topology, we want to know whether the pod that does synchronization has exhausted its cpu resources. We do this using the following steps:

```javascript
// Get the configured request for the stackstate topology synchroinzation pod
> kubectl get pod -l app.kubernetes.io/component=sync -o=jsonpath='{.items[*]..resources.requests.cpu}'
2

// Get the consumed resources
> kubectl top pod -l app.kubernetes.io/component=sync
NAME                               CPU(cores)   MEMORY(bytes)
stackstate-sync-665f988dc4-sh4fp   1970m         3234Mi  
```

In this case, we observe that 1.970 cores are used by the synchronization pod, where 2 are requested. This means the pod is very close to its cpu budget and is likely throttled. To remedy this, follow the procedure below

## Change the topology synchronization cpu budget

To modify the cpu budget for the topology synchronization, add/change the following configuration items in the [values.yaml](/setup/install-stackstate/kubernetes_install/customize_config.md) of your k8s stackstate deployment. And deploy the change.

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

Ideally we set requests equal to limits, to be guaranteed performance. Limits can never be lower than requests.

After making this modification, it is best to god back to observing the latency of tour synchronization, so be sure the changes have the desired effect, and do another iteration if more tuning is needed.

## See also

* [Debug topology synchronization](/configure/topology/debug-topology-synchronization.md)
* [Customizing values.yaml](/setup/install-stackstate/kubernetes_install/customize_config.md)  