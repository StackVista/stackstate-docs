---
description: StackState Self-hosted v5.0.x 
---

# Install StackState

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/setup/install-stackstate/linux_install/install_stackstate).
{% endhint %}

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read how to [migrate from the Linux install of StackState to the Kubernetes install](../kubernetes_install/migrate_from_linux.md).
{% endhint %}

## Before you start

Before starting the installation, you need to make a choice which make sure you make a choice whether to make a [development](development-installation.md) or [production](production-installation.md) setup, and make sure you have machines available that match our [requirements](/setup/install-stackstate/requirements.md).

## Installing

### Install using the RPM distribution

**NOTE**: StackState requires **JDK 8** to run. This version of Java must already be present on the installation machine and will not automatically be installed by the `rpm` command.

* `rpm -i <stackstate>.rpm`
* /opt/stackstate/bin/setup.sh
* During setup various configuration options will be requested, which are described below

### Install using the DEB distribution

**NOTE**: StackState requires **JDK 8** to run. This version of Java must already be present on the installation machine and will not automatically be installed by the `dpkg` command.

* `dpkg -i <stackstate>.deb`
* During setup various configuration options will be requested, which are described below

## Configuration options required during install

During the installation process StackState requests the user for information about the installation. These are the options that can be chosen:

* `SETUP`: Choose one of the four options:
  * `DEVELOPMENT`: Create a development setup. Single-node installation with limitations, see [development installation](development-installation.md).
  * `PRODUCTION-STACKGRAPH`: Create a StackGraph node for the production setup, see [production installation](production-installation.md).
  * `PRODUCTION-STACKSTATE`: Create a StackState node for the production setup, see [production installation](production-installation.md).
  * `CUSTOM`: Create a fully customizable StackState installation. For advanced users only.
* `LICENSE_KEY`: Your license key provided by StackState.
* `RECEIVER_BASE_URL`: Configures the endpoint to which agents and external sources can push data to StackState. Typically, it is of the form `"http://<<<HOST>>>:7077/"`, where `<<<HOST>>>` is the public DNS resolvable hostname external services can use to connect to the installed StackState instance. When running on a single machine, it is advised to specify the IP address and not use `localhost`. Also referred to as `<STACKSTATE_RECEIVER_BASE_URL>` for clarity in the docs.
* `STACKGRAPH_HOST`: This option is only available for the `PRODUCTION-STACKSTATE` setup type. The DNS name here of the StackGraph machine.
* `API_KEY`: The API key for the StackState Receiver API. This is the secret key StackState Agents must use to authenticate. If it is not provided, one will be generated automatically under `/opt/stackstate/etc/APIKEY`. Also referred to as `<STACKSTATE_RECEIVER_API_KEY>` for clarity in the docs.
* `STACKSTATE_BASE_URL`: The public URL of StackState.

Each of these options can also be passed to the installation as an environment variable, to create an unattended install used in automatic deployment scenarios.

