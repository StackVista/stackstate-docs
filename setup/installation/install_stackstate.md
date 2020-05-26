---
title: Install StackState
kind: Documentation
---

# install\_stackstate

## Before you start

Before starting the installation, make sure you make a choice whether to make a [development](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/development-installation/README.md) or [production](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/production-installation/README.md) setup, and make sure you have machines available that match our [requirements](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/requirements/README.md).

## Installing

**NOTE**: Installing StackState on versions older than 1.15.0 requires an alternative procedure, see \([Installing before 1.15.0](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/installing_pre1_15/README.md)\).

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

* `SETUP`: Choose either one of there four options:
  * `DEVELOPMENT`: Create a development setup. Single-node installation with limitations, see [development installation](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/development-installation/README.md).
  * `PRODUCTION-STACKGRAPH`: Create a StackGraph node for the production setup, see [production installation](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/production-installation/README.md).
  * `PRODUCTION-STACKSTATE`: Create a StackState node for the production setup, see [production installation](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/production-installation/README.md).
  * `CUSTOM`: Create a fully customizable StackState installation. For advanced users only.
* `LICENSE_KEY`: Your license key provided by StackState.
* `RECEIVER_BASE_URL`: Configures the endpoint to which agents and external sources can push data to StackState. Typically it is of the form `"http://<<<HOST>>>:7077/"`,

  where `<<<HOST>>>` is the public DNS resolvable hostname external services can use to connect to the installed StackState instance.

* `STACKGRAPH_HOST`: This option is only available for the `PRODUCTION-STACKSTATE` setup type. Please fill in the DNS name here of the StackGraph machine.
* `API_KEY`: Secret key StackState agents must use to authenticate. If it is not provided, one will be generated automatically under /opt/stackstate/etc/APIKEY

Each of these options can also be passed to the installation as an environment variable, to create an unattended install used in automatic deployment scenarios.

