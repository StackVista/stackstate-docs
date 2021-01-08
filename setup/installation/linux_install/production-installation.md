# Install with production configuration

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read about [installing StackState on Kubernetes](../kubernetes_install/).
{% endhint %}

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's production deployment [installation requirements](../../requirements.md).

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

* [Configuring authentication](../../authentication.md)
* [Reverse Proxy](reverse_proxy.md) \(recommended setup\) or [TLS without reverse proxy](how_to_setup_tls_without_reverse_proxy.md)
* [Data retention](/setup/data-management/data_retention.md)
* [Limits](/setup/data-management/limits.md)

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

