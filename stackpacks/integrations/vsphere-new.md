---
description: Near real-time synchronization with VMware vSphere
---

# VMware vSphere StackPack

## Overview

The VMware vSphere StackPack is used to create a near real-time synchronization with VMware vSphere. This StackPack provides functionality that allows monitoring of the following resources:

* Hosts
* Virtual machines
* Compute resources
* Cluster compute resources
* Data stores
* Data centers

![Data flow](/.gitbook/assets/stackpack-NAME.png)

THe VMware StackPack collects all topology data for the components and relations between them as well as telemetry and events.


## Setup

### Prerequisites

To set up the StackState VMware vSphere integration, you need to have:

* [StackState Agent V2](agent.md) must be installed on a single machine that can connect to both VSphere VCenter and StackState.
* A running VSphere VCenter instance.

### Network communication

* StackState Agent V2 connects to: 
    - the vSphere instance on TCP port 443.
    - the StackState API on TCP port 7077.
* If the Agent is installed on the StackState host, then port 7077 is localhost communication.
* If the Agent is installed on a different host, you will need a network path between the Agent and StackState on port 7077/tcp, and between the Agent and vSphere on 443/tcp port.

### Install

Install the VMware vSphere StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

- **VSphere Host Name** - the vSphere host name from which topology need to be collected.

### Configure

To enable the vSphere check and begin collecting data from your VSphere VCenter instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/vsphere.d/conf.yaml` to include details of your VSphere VCenter instance:
   * **name**
   * **host** - the same as the `vSphere Host Name` used in the StackPack provisioning process.
   * **username**
   * **password** - use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global vsphere check config
     init_config:

     instances:
     # name must be a unique key representing your vCenter instance
     # mandatory
     - name: <name> # main-vcenter

       # the host used to resolve the vCenter IP
       # mandatory
       host: <host_name> # vcenter.domain.com

       # Read-only credentials to connect to vCenter
       # mandatory
       username: <username> # stackstate-readonly@vsphere.local
       password: <password> # mypassword

       # Set to false to disable SSL verification, when connecting to vCenter
       # optional
       ssl_verify: false
     ```
2. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

### Status

To check the status of the VMware vSphere integration, run the status subcommand and look for vSphere under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events



#### Metrics



#### Topology



| Data | Description |
|:---|:---|
|  |  |
|  |  | 

#### Traces



### REST API endpoints


### Open source


## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=vSphere).

## Uninstall


## Release notes


## See also

- 
