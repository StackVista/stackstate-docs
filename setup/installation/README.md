---
description: Installing StackState.
---

# Installation

{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life \(EOL\) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Choosing your installation type

StackState can be installed either with linux packages on one or two linux machines or with Helm on a Kubernetes cluster \(in _beta_\). The former is discussed in the remainder of this document, for the latter see [Kubernetes installation](kubernetes/).

Before setting up StackState on one or two linux machine, you need to choose whether you want to run StackState in development, POC, or production mode.

* **Development** requires only one machine, but will be limited to 1000 components/relations per view, due to the limited setup. This is recommended for small trials.
* **POC** setup is used for bigger installations, giving almost the same power as production, but is not suited for processing perpetual data streams.
* **Production** is used when bringing StackState to production or when the other environments are too limiting.

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's [installation requirements](requirements.md).

## Packages

There is an RPM package available that provides easy installation and upgrade of StackState on Fedora, Red Hat or CentOS. For Debian and Ubuntu there is a DEB package available. Packages can be obtained from our [distribution website](../download.md).

## Installation

StackState supports three different installation configurations:

* a [production setup](production-installation.md) suitable for production use.
* a [proof-of-concept setup](poc-installation.md) suitable for proof of concepts.
* a [development setup](development-installation.md) suitable for a pilot or demo. This setup can deal with limited amounts of topology \(max 1000 components/relations per view\).

## Upgrading

To upgrade your StackState installation, see the instructions in our [upgrading guide](../upgrading.md).

## Authentication

StackState provides Role Based Access Control functionality that works with LDAP authentication servers. See [RBAC](../../concepts/role_based_access_control.md) pages for more information on the topic. You can also find how to configure LDAP servers [here](authentication.md).

StackState also supports authentication against a KeyCloak OIDC Authentication server. You can read how to configure this [here](authentication.md#configuring-the-keycloak-oidc-authentication-server).

## Troubleshooting

If you have any issues installing StackState, refer to our [troubleshooting guide](troubleshooting.md) or contact our technical support.

