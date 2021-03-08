---
description: Near real-time synchronization with VMWare vSphere
stackpack-name: VMWare vSphere StackPack
---

# VMWare vSphere StackPack

## Overview

The VMWare vSphere StackPack is used to create a near real-time synchronization with VMWare vSphere. This StackPack provides functionality that allows monitoring of the following resources:

* Hosts
* VirtualMachines
* ComputeResources
* ClusterComputeResources
* DataStores
* DataCenters

![Data flow](/.gitbook/assets/stackpack-vmware_draft2.svg)

The VMware StackPack collects all topology data for the components and relations between them as well as telemetry and events.

* StackState Agent V2 connects to the configured VMWare vSphere instance at port 443 to:
    * retrieve topology data for the configured resources.
    * retrieve metrics data for the configured resources. The actual metrics retrieved can also be optionally configured in the StackState VMWare vSphere check configuration.
    * watch the vCenter Event Manager for events related to the configured resources.
* StackState Agent V2 pushes retrieved data and events to StackState at port 7077.
    * Topology data is translated into components and relations.
    * Tags defined in VMWare vSphere are added to components and relations in StackState
    * Metrics data is automatically mapped to associated components and relations in StackState.
    * Events data is available in StackState as a telemetry stream.

## Setup

### Prerequisites

To set up the StackState VMWare vSphere integration, you need to have:

* [StackState Agent V2](agent.md) installed on a single machine that can connect to both VSphere VCenter and StackState. StackState Agent V2 connects to the VMWare vSphere instance on TCP port 443 and the StackState API on TCP port 7077.
    - If the Agent is installed on the StackState host, then port 7077 is localhost communication.
    - If the Agent is installed on a different host, you will need a network path between the Agent and StackState on port 7077/tcp, and between the Agent and VMWare vSphere on 443/tcp port.
* A running VSphere VCenter instance.

### Install

The VMWare vSphere StackPack can be installed from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

- **VSphere Host Name | the VMWare vSphere host name from which data will be collected.

### Configure

To enable the VMWare vSphere check and begin collecting data from your VSphere VCenter instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/vsphere.d/conf.yaml` to include details of your VSphere VCenter instance:
   * **name | a unique key representing your vCenter instance.
   * **host | the same as the `VSphere Host Name` used when the StackPack was installed.
   * **username | the username to use when connecting to VMWare vSphere.
   * **password | use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global vsphere check config
     init_config:

     instances:
     - name: <name> # for example main-vcenter

       host: <host_name> # for example vcenter.domain.com

       username: <username>
       password: <password> 

     ```
2. You can also add other [optional configuration](#optional-configuration) to the file `/etc/stackstate-agent/conf.d/vsphere.d/conf.yaml`.
    
3. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.

4. Once the Agent has restarted, wait for the Agent to collect the data and send it to StackState.

#### Optional configuration

The configuration options described below can optionally be added to the VMWare vSphere check configuration file. Further details can be found in the file [`conf.yaml.example`](https://github.com/StackVista/sts-agent-integrations-core/blob/master/vsphere/conf.yaml.example)

| Options | Required? | Description |
| :--- | :--- | :--- |
| ssl_verify | No | Set to `false` to disable SSL verification when connecting to vCenter. |
| ssl_capath | No | The absolute file path of a directory containing CA certificates in PEM format. |
| host_include_only_regex | No | Use a regex pattern to only fetch metrics for these ESXi hosts and the VMs running on them. |
| vm_include_only_regex | No | Use a regex to include only VMs that match the specified pattern. |
| include_only_marked | No |  Set to `true`, if you would like to only collect metrics on vSphere VMs that are marked by a custom field with the value  `StackStateMonitored`. To set this custom field with PowerCLI, use the command: ```Get-VM <MyVMName> \| Set-CustomField -Name "StackStateMonitored" -Value "StackStateMonitored"```  |
| all_metrics | No | Set to `true` to collect _every_ metric. This will collect a LOT of metrics that you probably do not need. When set to `false` (default), a selected set of metrics that are interesting to monitor will be collected. |
| collection_level | No | Specify the metrics to retrieve using a [data collection level \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html) (a number between 1 and 4). |
| collect_vcenter_alarms | No | set to `true` to send vCenter alarms as events. |


### Status

To check the status of the VMWare vSphere integration, run the status subcommand and look for vSphere under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events

VMWare vSphere events are sent to StackState in a telemetry stream. These can be mapped to components and relations in the StackState topology, however, they will not be visible in the StackState events perspective.

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

The metrics retrieved from VMWare vSphere can be configured in the Agent check configuration file using the configuration items **collection_level** and **all_metrics**. For details see how to [configure the VMWare vSphere check](#configure), above and the vmware docs on  [Data Collection Levels \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html).

#### Topology

The VMWare vSphere integration retrieves the following topology data:

* Components
* Relations

#### Traces

The VMWare vSphere integration does not retrieve any traces data.


### REST API endpoints

The VMWare vSphere integration connects to VMWare vSphere using the VMWare vSphere client library and Python modules `pyvim` and `pyVmomi`. No API endpoints are used.


### Open source

The code for the StackState VMware vSPhere check is open source and available on GitHub at: 

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

3. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## Release notes

**VMWare vSphere StackPack v2.2.1 (2020-08-18)**

- Feature: Introduced the Release notes pop up for customer

**VMWare vSphere StackPack v2.2.0 (2020-08-04)**

- Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.
- Improvement: Replace resolveOrCreate with getOrCreate.

**VMWare vSphere StackPack v2.1.0 (2020-04-10)**

- Improvement: Updated StackPacks integration page, categories, and icons for the SaaS trial

**VMWare vSphere StackPack v2.0.1 (2020-04-03)**

- Improvement: Upgrade the requirement of VSphere to use AgentV2 now.

**VMWare vSphere StackPack v2.0.0 (2019-10-30)**

- Feature: Gathers Topology from your VSphere instance and allows visualization of your VSphere components and the relations between them.


## See also

* [StackState Agent V2](agent.md) 
* [Secrets management](../../configure/security/secrets_management.md)
* [StackState Agent integrations - VMWare vSphere \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/vsphere)
* [Data Collection Levels \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html).