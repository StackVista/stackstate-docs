# SAP

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

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

To set up the StackState SAP integration you need to have:

* [StackState Agent V2](agent.md) installed on a single machine that can connect to both your SAP Instance and StackState.
* A running SAP instance.

### Networking requirements

The StackState SAP integration requires the following TCP ports:

* 1128 for HTTP 
* 1129 for HTTPS

## Enable SAP integration

To enable the SAP check and begin collecting data from your SAP host instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/sap.d/conf.yaml`:
   * Include details of your SAP instance:
     * **host**
     * **url** - Use `http` for basic authentication \(user/pass\) and `https` for client certificate authentication.
     * **user**
     * **pass** - Use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.
   * To authenticate with a client certificate and private key, add:

     * **verify** - Set to `False` to skip verification of the client certificate \(default `True`\).
     * **cert** - Path to the client side certificate.
     * **keyfile** - Path to the private key for certificate.

     ```text
     # Section used for global SAP check config
     init_config: {}

     instances:
       - host: TEST-01             # <sap_host_name>
         url: https://test-01      # <sap_host_url>   
         user: test                # <username>
         pass: test                # <password>
     # Extra parameters for client certificate authentication:
         verify: False             
         cert: /path/to/cert.pem   # <certificate_path>
         keyfile: /path/to/key.pem # <keyfile_path>
     ```
2. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect data and send it to StackState.

## Open-source

The SAP StackPack is open-source and can be found [on StackState's github page](https://github.com/StackVista/stackpack-sap).

