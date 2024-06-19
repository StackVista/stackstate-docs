---
description: StackState
---

# Log Shipping

## Agent Installation

### Openshift

Third-party log shippers are not readily supported on Openshift, the platform has options for log forwarding, which is used instead of the promtail configuration included in the StackState helm chart.  For detailed instructions on how to configure this, refer to the Kubernetes stackpack documentation on your running StackState instance. 

### Kubernetes

The StackState k8s Agent helm chart default configuration sets log shipping as enabled via the helm values supplied with the chart:

```yaml
logsAgent:
  # logsAgent.enabled -- Enable / disable k8s pod log collection
  enabled: true
```

The above will ensure that a promtail container is deployed to each node to collect logs and send it to StackState.  For deployments where it is not desirable to ship logs to StackState, set the above value to `false`.

### Running Additional Promtail Pods

StackState uses a tuned configuration for log ingestion, and this is usually not in line with auxiliary requirements.  It is therefore not possible to run a separate configuration for log ingestion to other destination endpoints, it is instead recommended to run a second promtail pod that deals with these requirements as a separate concern to the promtail that is deployed by the agent helm chart.
