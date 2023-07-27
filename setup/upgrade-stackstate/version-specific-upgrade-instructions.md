---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Version specific upgrade instructions

## Overview

{% hint style="warning" %}
**Review the instructions provided on this page before you upgrade!**

This page provides specific instructions and details of any required manual steps to upgrade to each supported version of StackState. Any significant change that may impact how StackState runs after upgrade will be described here, such as a change in memory requirements or configuration.

**Read and apply all instructions from the version that you are currently running up to the version that you will upgrade to.**
{% endhint %}

## Upgrade instructions

### Next version

The StackState Helm chart has had improvements that simplify custom configuration:
* Persistent Volume Claim storage classes can now be configured with a [single global key for most volumes](/setup/install-stackstate/kubernetes_openshift/storage.md)

When upgrading and also when running a non-HA installation add this section to one of the values.yaml files used:

```yaml
victoria-metrics-1:
  enabled: false
```

Not including this can lead to strange results in metric charts, where metrics sometimes are available and some times not.

## See also

* [Steps to upgrade StackState](steps-to-upgrade.md)

