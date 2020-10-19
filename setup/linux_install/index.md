{% hint style="info" %}
StackState prefers Kubernetes!<br />In the future we will move away from Linux support. Read about [installing StackState on Kubernetes](/setup/kubernetes_install/).
{% endhint %}

## Choosing your installation type

Before setting up StackState, you need to choose whether you want to run StackState in development, POC, or production mode. Development requires only one machine, but will be limited to 1000 components/relations per view, due to the limited setup. This is recommended for small trials. POC setup is used for bigger proofs-of-concepts, giving almost the same power as production, but is not suited for processing perpetual data streams. Production is used when bringing StackState to production or when the other environments are too limiting.

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's [installation requirements](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/requirements/README.md).

## Packages

There is an RPM package available that provides easy installation and upgrade of StackState on Fedora, Red Hat or CentOS. For Debian and Ubuntu there is a DEB package available. Packages can be obtained from our [distribution website](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/download/README.md).

## Installation

StackState supports three different installation configurations:

* a [production setup](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/production-installation/README.md) suitable for production use.
* a [proof-of-concept setup](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/poc-installation/README.md) suitable for proof of concepts.
* a [development setup](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/development-installation/README.md) suitable for a pilot or demo. This setup can deal with limited amounts of topology \(max 1000 components/relations per view\).

## Upgrading

To upgrade your StackState installation, see the instructions in our [upgrading guide](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/upgrading/README.md).

## Authentication

StackState provides Role Based Access Control functionality that works with LDAP authentication servers. See [RBAC](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/concepts/role_based_access_control/README.md) pages for more information on the topic. You can also find how to configure LDAP servers [here](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/authentication/README.md).

## Troubleshooting

If you have any issues installing StackState, refer to our [troubleshooting guide](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/troubleshooting/README.md) or contact our technical support.
