---
description: StackState Self-hosted v4.6.x
---

# 💠 VMWare vSphere

{% hint style="warning" %}
**This page describes StackState version 4.6.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/vsphere).
{% endhint %}

## Overview

The VMWare vSphere StackPack is used to create a near real-time synchronization with VMWare vSphere. This StackPack provides functionality that allows monitoring of the following resources:

* Hosts
* VirtualMachines
* ComputeResources
* ClusterComputeResources
* DataStores
* DataCenters

VMWare vSphere is a [StackState core integration](/stackpacks/integrations/about_integrations.md#stackstate-core-integrations "StackState Self-Hosted only").

![Data flow](../../.gitbook/assets/stackpack-vsphere.svg)

The VMware StackPack collects all topology data for the components and relations between them as well as telemetry and events.

* StackState Agent V2 connects to the configured VMWare vSphere instance:
  * Topology data and tags are retrieved for the configured resources.
  * Metrics data is retrieved for the configured resources.
  * The Agent watches the vCenter Event Manager for events related to the configured resources.
* StackState Agent V2 pushes retrieved data and events to StackState:
  * [Topology data](vsphere.md#topology) is translated into components and relations.
  * [Tags](vsphere.md#tags) defined in VMWare vSphere are added to components and relations in StackState. Any defined StackState tags are used by StackState when the topology is retrieved.
  * [Metrics data](vsphere.md#metrics) is automatically mapped to associated components and relations in StackState.
  * [Events](vsphere.md#events) are available as a telemetry stream in StackState.

## Setup

### Prerequisites

To set up the StackState VMWare vSphere integration, you need to have:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) installed on a single machine with HTTPS connection to both vSphere vCenter and StackState. 
* A running vSphere vCenter instance.

### Install

The VMWare vSphere StackPack can be installed from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **VSphere Host Name** - The VMWare vSphere host name from which data will be collected.

### Configure

To enable the VMWare vSphere check and begin collecting data from your vSphere vCenter instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/vsphere.d/conf.yaml` to include details of your vSphere vCenter instance:
   * **name** - aA unique key representing your vCenter instance.
   * **host** - The same as the `VSphere Host Name` used when the StackPack was installed.
   * **username** - The username to use when connecting to VMWare vSphere.
   * **password** - Use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global vsphere check config
     init_config:

     instances:
     - name: <name> # for example main-vcenter

       host: <host_name> # for example vcenter.domain.com

       username: <username>
       password: <password>
     ```
2. If required, you can customise the integration using the [advanced configuration options](vsphere.md#advanced-configuration).
3. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to publish the configuration changes.
4. Once the Agent has restarted, wait for the Agent to collect the data and send it to StackState.

#### Advanced configuration

The advanced configuration items described below can optionally be added to the VMWare vSphere check configuration file. Further details can be found in the [example configuration file \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/vsphere/conf.yaml.example).

| Options | Required? | Description |
| :--- | :--- | :--- |
| `all_metrics` | No | Default `false`. Set to `true` to collect _every_ metric. This will collect a LOT of metrics that you probably do not need. When set to `false` \(default\), a selected set of metrics that are interesting to monitor will be collected. Note that when using both `all_metrics` and `collection_level` setting `all_metrics` will be ignored. |
| `collection_level` | No | Specify the metrics to retrieve using a [data collection level \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html) (a number between 1 and 4). Note that when using both `all_metrics` and `collection_level` setting `all_metrics` will be ignored.  |
| `ssl_verify` | No | Set to `false` to disable SSL verification when connecting to vCenter. |
| `ssl_capath` | No | The absolute file path of a directory containing CA certificates in PEM format. |
| `host_include_only_regex` | No | Use a regex pattern to only fetch metrics for these ESXi hosts and the VMs running on them. |
| `vm_include_only_regex` | No | Use a regex to include only VMs that match the specified pattern. |
| `include_only_marked` | No | Set to `true`, if you would like to only collect metrics on vSphere VMs that are marked by a custom field with the value `StackStateMonitored`. To set this custom field with PowerCLI, use the command: `Get-VM | Set-CustomField -Name "StackStateMonitored" -Value "StackStateMonitored"` |
| `collect_vcenter_alarms` | No | set to `true` to send vCenter alarms as events. | 

### Status

To check the status of the VMWare vSphere integration, run the status subcommand and look for vSphere under `Running Checks`:

```text
sudo stackstate-agent status
```

## Integration details

### Data retrieved

The VMWare vSphere integration retrieves the following data:

* [Events](vsphere.md#events)
* [Metrics](vsphere.md#metrics)
* [Tags](vsphere.md#tags)
* [Topology](vsphere.md#topology)

#### Events

VMWare vSphere events are sent to StackState in a telemetry stream. These can be mapped to components and relations in the StackState topology, however, they will not be visible in the StackState Events Perspective.

The VMWare vSphere check watches the vCenter Event Manager for the events listed below and makes these available in StackState in the generic events topic telemetry stream:

* AlarmStatusChangedEvent:Gray
* VmBeingHotMigratedEvent
* VmReconfiguredEvent
* VmPoweredOnEvent
* VmMigratedEvent
* TaskEvent:Initialize powering On
* TaskEvent:Power Off virtual machine
* TaskEvent:Power On virtual machine
* TaskEvent:Reconfigure virtual machine
* TaskEvent:Relocate virtual machine
* TaskEvent:Suspend virtual machine
* TaskEvent:Migrate virtual machine
* VmMessageEvent
* VmSuspendedEvent
* VmPoweredOffEvent

#### Metrics

The metrics retrieved from VMWare vSphere can be configured in the Agent check configuration file using the configuration items **collection_level** and **all_metrics**. For details see the section [advanced configuration of the VMWare vSphere check](#advanced-configuration) (above) and the vmware docs on  [Data Collection Levels \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html).

#### Tags

All tags defined in VMWare vSphere will be retrieved and added to the associated components and relations in StackState. 

The VMWare vSphere integration also understands StackState [common tags](../../configure/topology/tagging.md#common-tags). These StackState tags can be assigned to elements in VMWare vSphere to influence the way that the resulting topology is built in StackState. For example, by placing a component in a specific layer or domain.

#### Topology

The VMWare vSphere integration retrieves the following topology data:

* Components
* Relations

{% hint style="info" %}
The VMWare vSphere integration understands StackState [common tags](../../configure/topology/tagging.md#common-tags). These StackState tags can be assigned to elements in VMWare vSphere to influence the way that the resulting topology is built in StackState. For example, by placing a component in a specific layer or domain.
{% endhint %}

#### Traces

The VMWare vSphere integration does not retrieve any traces data.

### REST API endpoints

The VMWare vSphere integration connects to VMWare vSphere using the VMWare vSphere client library and Python modules `pyvim` and `pyVmomi`. No API endpoints are used.

### Open source

The code for the StackState VMware vSphere check is open source and available on GitHub at:

[https://github.com/StackVista/stackstate-agent-integrations/tree/master/vsphere](https://github.com/StackVista/stackstate-agent-integrations/tree/master/vsphere)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=vSphere).

## Uninstall

To uninstall the VMWare vSphere StackPack and disable the VMWare vSphere check:

1. Go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **VMWare vSphere** screen and click UNINSTALL.
   * All VMWare vSphere specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv vsphere.d/conf.yaml vsphere.d/conf.yaml.bak
   ```

3. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to apply the configuration changes.

## Release notes

**VMWare vSphere StackPack v2.3.1 \(2021-04-12\)**

* Improvement: Common bumped from 2.5.0 to 2.5.1

## See also

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) 
* [Secrets management](../../configure/security/secrets_management.md)
* [StackState Agent integrations - VMWare vSphere \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/vsphere)
* [Example VMWare vSphere check configuration file \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/blob/master/vsphere/conf.yaml.example)
* [Data Collection Levels \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html)

