---
title: SAP StackPack
kind: documentation
---

# SAP


{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life (EOL) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the SAP StackPack?

The SAP StackPack is used to create a near real time synchronization with your SAP system and also pulls the metrics from it. The components supported are:

* SAP Host
* SAP Host instance
* SAP Process
* SAP Database
* SAP Database Component

## Prerequisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to SAP Instance and StackState. \(See the [StackState Agent V2 StackPack](agent.md) for more details\)
* A SAP instance must be running.

## Enabling the SAP check

To enable the SAP check which collects the data from SAP host instance:

Edit the `conf.yaml` file in your agent `/etc/stackstate-agent/conf.d/sap.d` directory, replacing `<sap_host_name>` and `<sap_host_url>` with the unique name of SAP host to identify and URL to connect from your SAP instance.

To Connect to your SAP System, there are 2 ways to do so as explained below:

### 1. HTTP Basic Authentication Mechanism

This mechanism allows you to connect just using the `username` and `password` inside the `conf.yaml`.

_As an example, see the below config :_

```text
# Section used for global SAP check config
init_config: {}

instances:
    - host: TEST-01         # <sap_host_name>
      url: http://test-01   # <sap_host_url>   
      user: test            # <username>
      pass: test            # <password>
```

**NOTE** - Make sure while using this mechanism, you have put `http` in the `url` of the config.

### 2. Client Certificate Authentication Mechanism

This mechanism allows you to connect using the client certificate and the private key. The following new parameters are available :

* `verify` - `True` or `False` depending on verifying the client certificate or not. By default, it's `True`.
* `cert` - path containing the client side certificate
* `keyfile` - path containing the private key for certificate

_As an example, see the below config :_

```text
# Section used for global SAP check config
init_config: {}

instances:
    - host: TEST-01             # <sap_host_name>
      url: https://test-01      # <sap_host_url>   
      user: test                # <username>
      pass: test                # <password>
      verify: False
      cert: /path/to/cert.pem   # <certificate_path>
      keyfile: /path/to/key.pem # <keyfile_path>
```

**NOTE** - Make sure while using this mechanism, you have put `https` in the `url` of the config.

Once the configuration changes are done as explained above, restart the StackState Agent\(s\) using the following command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Open-source

The SAP StackPack is open-source and can be found [on StackState's github page](https://github.com/StackVista/stackpack-sap).

