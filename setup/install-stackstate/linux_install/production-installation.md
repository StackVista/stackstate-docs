---
description: StackState Self-hosted v4.6.x
---

# Install with production configuration

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/install-stackstate/linux_install/production-installation).
{% endhint %}

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read how to [migrate from the Linux install of StackState to the Kubernetes install](../kubernetes_install/migrate_from_linux.md).
{% endhint %}

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's production deployment [installation requirements](/setup/install-stackstate/requirements.md).

## Two-node deployment architecture

The StackState production environment requires two nodes a StackGraph and a StackState node.

Configure StackState to run in the two-node setup requires the following steps:

### Preparing the StackGraph node

1. Install the package using the instruction for [Installing StackState](install_stackstate.md), using `PRODUCTION-STACKGRAPH` as SETUP configuration parameter.
2. Start the StackGraph process as described in [Starting / Stopping](production-installation.md#starting-and-stopping).

### Preparing the StackState node

To prepare an additional node for running a StackState component, follow these steps:

1. Install the package using the instruction for [Installing StackState](install_stackstate.md), using `PRODUCTION-STACKSTATE` as SETUP configuration parameter.

### Further Configuring StackState

After you have installed StackState, refer to the following pages for configuration instructions:

* [Configuring authentication](../../../configure/security/authentication/authentication_options.md)
* [Reverse Proxy](reverse_proxy.md) \(recommended setup\) or [TLS without reverse proxy](how_to_setup_tls_without_reverse_proxy.md)

### Starting and Stopping

Note that the StackGraph node always needs to be running before starting StackState

### Starting and Stopping StackGraph

On the StackGraph node, the following commands will start/stop StackGraph:

`sudo systemctl start stackgraph.service`

`sudo systemctl stop stackgraph.service`

### Starting and Stopping StackState

On the StackState node, the following commands will start/stop StackState:

`sudo systemctl start stackstate.service`

`sudo systemctl stop stackstate.service`

