---
description: StackState core integration
---

# Upgrade Splunk topology V1 to V2

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

In previous releases of StackState, it was only possible to run the Splunk topology check using StackState Agent V1. It is now also possible to run the Splunk topology check on [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md).

* If you are currently running the Splunk topology V1 check on the [StackState Agent V1](../../../setup/agent/agent-v1.md), this guide will help you migrate to the new StackState Agent V2 check.
* If you are starting from scratch, you can directly configure the [Splunk topology V2 check](splunk_topology_v2.md) on StackState Agent V2.

{% hint style="info" %}
It is not advised to run the Splunk topology integration through both StackState Agent V1 and StackState Agent V2 at the same time. Run either the Splunk topology V1 check \(for StackState Agent V1\) or the Splunk topology V2 check \(for StackState Agent V2\).
{% endhint %}

## Upgrade steps

To upgrade an existing Splunk topology check to run on StackState Agent V2, follow the steps below:

1. Install [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) in a location that can connect to both StackState and Splunk.
   * **Note** StackState Agent V2 cannot run side-by-side with the API Integration Agent. If you intend to continue running other checks on StackState Agent V1, install StackState Agent V2 in a different location.
2. Stop StackState Agent V1.
3. Disable the Splunk topology check on StackState Agent V1:

   ```text
   mv /etc/sts-agent/conf.d/splunk_topology.yaml /etc/sts-agent/conf.d/splunk_topology.yaml.bak
   ```

4. Copy the old Splunk topology check configuration file to the newly installed StackState Agent V2:

   ```text
   # Agent installed on the same machine as StackState Agent V1 was running 
   cp /etc/sts-agent/conf.d/splunk_topology.yaml.bak /etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml

   # Agent installed in a different location
   scp <user>@<old_host>:/etc/sts-agent/conf.d/splunk_topology.yaml.bak <user>@<new_host>:/etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml
   ```

5. Edit the check configuration file `/etc/stackstate-agent/conf.d/splunk_topology.d/conf.yaml` and replace all occurrences of the following items:
   * `default_polling_interval_seconds` replace with `min_collection_interval`.
   * `polling_interval_seconds` replace with `min_collection_interval`.
6. Restart StackState Agent V2 to apply the configuration changes.
   * The Splunk topology V2 check is now enabled on StackState Agent V2.
   * Wait for the Agent to collect data and send it to StackState.

## See also

* [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md)
* [StackState Splunk integration details](splunk_stackpack.md)
* [Splunk topology V2 integration](splunk_topology_v2.md)

