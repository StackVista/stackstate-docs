---
title: StackState installation before 1.14.5
kind: Documentation
---

# Installing StackState before 1.14.5

## Installing

### Install using the RPM distribution

**NOTE**: StackState requires **JDK 8** to run. This version of Java must already be present on the installation machine and will not automatically be installed by the `rpm` command.

Install StackState using the following command:

`rpm -i <stackstate>.rpm`

### Install using the DEB distribution

**NOTE**: StackState requires **JDK 8** to run. This version of Java must already be present on the installation machine and will **not** be automatically installed by the `dpkg` command.

Install StackState using the following command:

`dpkg -i <stackstate>.deb`

## Setting your license key

To set your license key, use the following command:

`sudo -u stackstate /opt/stackstate/bin/sts.sh register --key <license-key>`

**NOTE:** this command must be executed as the user that will be running StackState, typically user `stackstate`.

## Configuring the receiver base URL

To set the base URL where StackState can be found, add the following line to `application_stackstate.conf`:

```text
stackstate.receiver.baseUrl = "http://stackstate.acme.com:7077"
```

This baseUrl is used to setup the 'one line install command' for agents which will send metrics/events/topology to this endpoint.

**NOTE:** StackState port 7077 must be reachable from any system that is pushing data to StackState

It's also possible to change the port where the server \(API and GUI\) is listening on.

## Configuring the server API key

StackState server must be configured to accept information from a StackState agent by specifying the agent's API key. By default a random APIKEY is generated for you during installation. If you want to use this key, or change it, it can be found in the file located a `STACKSTATE_HOME/etc/APIKEY`.

For example:

```text
AAAA-AAAAA-AAAAA
```

