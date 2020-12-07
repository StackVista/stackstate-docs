# Install StackState

{% hint style="info" %}
StackState prefers Kubernetes!  
In the future we will move away from Linux support. Read about [installing StackState on Kubernetes](/setup/installation/kubernetes_install/README.md).
{% endhint %}

## Before you start

Before starting the installation, you need to make a choice which make sure you make a choice whether to make a [development](/setup/installation/linux_install/development-installation.md) or [production](/setup/installation/linux_install/production-installation.md) setup, and make sure you have machines available that match our [requirements](/setup/requirements.md).

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
  * `DEVELOPMENT`: Create a development setup. Single-node installation with limitations, see [development installation](/setup/installation/linux_install/development-installation.md).
  * `PRODUCTION-STACKGRAPH`: Create a StackGraph node for the production setup, see [production installation](/setup/installation/linux_install/production-installation.md).
  * `PRODUCTION-STACKSTATE`: Create a StackState node for the production setup, see [production installation](/setup/installation/linux_install/production-installation.md).
  * `CUSTOM`: Create a fully customizable StackState installation. For advanced users only.
* `LICENSE_KEY`: Your license key provided by StackState.
* `RECEIVER_BASE_URL`: Configures the endpoint to which agents and external sources can push data to StackState. Typically it is of the form `"http://<<<HOST>>>:7077/"`, where `<<<HOST>>>` is the public DNS resolvable hostname external services can use to connect to the installed StackState instance.
* `STACKGRAPH_HOST`: This option is only available for the `PRODUCTION-STACKSTATE` setup type. Please fill in the DNS name here of the StackGraph machine.
* `API_KEY`: Secret key StackState agents must use to authenticate. If it is not provided, one will be generated automatically under `/opt/stackstate/etc/APIKEY`.
* `STACKSTATE_BASE_URL`: The public URL of StackState.


Each of these options can also be passed to the installation as an environment variable, to create an unattended install used in automatic deployment scenarios.
