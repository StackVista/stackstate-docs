---
title: Configuring StackState
kind: Documentation
---

# Configuring StackState for first time use

## Registering your license key

The first time you start StackState, you have to register your license key. The command to do this is:

`sudo -u stackstate /opt/stackstate/bin/sts.sh register --key <license-key>`

**NOTE:** this command must be executed as the user that will be running StackState, typically user `stackstate`.

## Configuration files

The main configuration file for StackState server is `application_stackstate.conf` located in the `STACKSTATE_HOME/etc` directory. This file can be manipulated directly to alter the StackState configuration. Secondly, to manipulate the running of stackstate processes, a `STACKSTATE_HOME/etc/processmanager/processmanager-properties-overrides.conf` file can be created, to override the properties exposed by `STACKSTATE_HOME/etc/processmanager/processmanager-properties.conf`.

## Configuring the receiver base URL

Before starting StackState, it must be configured with it's base URL for the receiver service. This setting is located in `application_stackstate.conf` inside the 'receiver' section. For example:

```text
baseUrl = "http://stackstate.acme.com:7077"
```

This baseUrl is used to setup the 'one line install command' for agents which will send metrics/events to this endpoint.

**NOTE:** StackState port 7077 must be reachable from any system that is pushing data to StackState

It's also possible the change here the port where the server \(API and GUI\) is listening on.

## Configuring the server API key

StackState server must be configured to accept information from a StackState agent by specifying the agent's API key. This is done in the `APIKEY` configuration file located in `STACKSTATE_HOME/etc` directory. For example:

```text
AAAAA-AAAAA-AAAAA
```

## Preparing StackState for first use

The above configuration is enough to get StackState started. Once you can access the StackState GUI, you will want to install one or more [standard StackPacks](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/integrations/README.md#standard-stackpacks).

