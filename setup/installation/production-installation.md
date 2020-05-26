---
title: Production Installation
kind: Documentation
---

# production-installation

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's production deployment [installation requirements](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/requirements/README.md).

## Two-node deployment architecture

**NOTE**: Installing StackState on versions older than 1.15.0 requires an alternative procedure, see \([Installing before 1.15.0](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/production-installation_pre1_15/README.md)\).

The StackState production environment requires two nodes a StackGraph and a StackState node.

Configure StackState to run in the two-node setup requires the following steps:

### Preparing the StackGraph node

1. Install the package using the instruction for [Installing StackState](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/install_stackstate/README.md), using `PRODUCTION-STACKGRAPH` as SETUP configuration parameter.
2. Start the StackGraph process as described in [Starting / Stopping](production-installation.md#starting-and-stopping).

### Preparing the StackState node

To prepare an additional node for running a StackState component, follow these steps:

1. Install the package using the instruction for [Installing StackState](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/install_stackstate/README.md), using `PRODUCTION-STACKSTATE` as SETUP configuration paramater.

### Further Configuring StackState

After you have installed StackState, refer to the following pages for configuration instructions:

* [Configuring authentication](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/authentication/README.md)
* [Reverse Proxy](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/reverse_proxy/README.md) \(recommended setup\) or [TLS without reverse proxy](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/how_to_setup_tls_without_reverse_proxy/README.md)
* More in for on [configuring StackState](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/configuration/README.md)

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

