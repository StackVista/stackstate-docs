# Install with POC configuration

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read how to [migrate from the Linux install of StackState to the Kubernetes install](../kubernetes_install/migrate_from_linux.md).
{% endhint %}

Proof-of-concept \(POC\) mode is StackState's installation mode best suited for POCs. It requires only one machine, and can handle \(almost\) the same load as a regular production setup. The only limitations are that the system cannnot handle lots of perpetual data \(like &gt;10 agents or a big perpetually running AWS landscape\).

## Requirements

Before starting the installation, ensure your system meet StackState's POC setup [installation requirements](/setup/install-stackstate/requirements.md).

## Installing StackState in a POC configuration

For a POC setup of StackState, simply follow the instructions for [Installing StackState](install_stackstate.md), using `POC` as the SETUP configuration parameter.

## Starting and Stopping

### SystemD service

The RPM and DEB packages install SystemD services for StackState and StackGraph. StackState can be started with `sudo systemctl start stackstate.service` this will also start service StackGraph. Starting StackState can take some time.

After starting processes are complete, the service is available at `http://<stackstate_hostname>:7070`.

### Stopping StackState

StackState can be stopped by `sudo systemctl stop stackstate.service`. StackGraph is not automatically stopped when stopping StackState, StackGraph can be stopped by `sudo systemctl stop stackgraph.service`.

### StackState Status

Checking the service status can be done with `sudo systemctl status stackstate.service` and `sudo systemctl status stackgraph.service`.

