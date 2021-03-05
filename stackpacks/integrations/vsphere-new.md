---
description: Near real-time synchronization with VMware vSphere
stackpack-name: vSphere StackPack
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

* [StackState Agent V2](agent.md) installed on a single machine that can connect to both VSphere VCenter and StackState. StackState Agent V2 connects to the vSphere instance on TCP port 443 and the StackState API on TCP port 7077.
    - If the Agent is installed on the StackState host, then port 7077 is localhost communication.
    - If the Agent is installed on a different host, you will need a network path between the Agent and StackState on port 7077/tcp, and between the Agent and vSphere on 443/tcp port.
* A running VSphere VCenter instance.

### Install

The VMware vSphere StackPack can be installed from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

- **VSphere Host Name** - the vSphere host name from which data will be collected.

### Configure

To enable the vSphere check and begin collecting data from your VSphere VCenter instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/vsphere.d/conf.yaml` to include details of your VSphere VCenter instance:
   * **name** - a unique key representing your vCenter instance.
   * **host** - the same as the `vSphere Host Name` used when the StackPack was installed.
   * **username** - the username to use when connecting to vSphere.
   * **password** - use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.

     ```text
     # Section used for global vsphere check config
     init_config:

     instances:
     - name: <name> # for example main-vcenter

       host: <host_name> # for example vcenter.domain.com

       username: <username>
       password: <password> 

     ```
2. You can also add optional configuration:
    * **ssl_verify** - set to `false` to disable SSL verification, when connecting to vCenter.
    * **ssl_capath** - the absolute file path of a directory containing CA certificates in PEM format.
    * **host_include_only_regex** - specify a regex to only fetch metrics for these ESXi hosts and the VMs running on them.
    * **vm_include_only_regex** - specify a regex to include only VMs matching this pattern.
    * **include_only_marked** -  set to `true` to collect metrics only on vSphere VMs that are marked by a custom field with the value `StackStateMonitored`. To set this custom field with PowerCLI, use the command `Get-VM <MyVMName> | Set-CustomField -Name "StackStateMonitored" -Value "StackStateMonitored"`.
    * **all_metrics** - set to `true` to collect _every_ metric. This will collect a LOT of metrics that you probably do not care about. When set to false (default), a selected set of metrics that are interesting to monitor will be collected.
    * **collection_level** - specify the [data collection level \(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html) to retrieve. **all_metrics** must be set to `false`.
    * **collect_vcenter_alarms** - set to `true` to send vCenter alarms as events.
    
3. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.

4. Once the Agent has restarted, wait for the Agent to collect the data and send it to StackState.

### Status

To check the status of the VMware vSphere integration, run the status subcommand and look for vSphere under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events

vSphere events are sent to StackState in a telemetry stream. These are mapped to components and relations, they will not be visible in the StackState events perspective.

#### Telemetry

| Data | Description |
| :--- | :--- |
| Logs | The vSphere check watches the vCenter Event Manager for the events listed below. These events are sent to StackState in a telemetry stream and mapped to relevant components. You can manually add the vSphere events telemetry stream to a component using the **???** data source.<br />Events retrieved from vSphere:<br />
<ul>
<li>* AlarmStatusChangedEvent:Gray</li>
<li>* VmBeingHotMigratedEvent</li>
<li>* VmReconfiguredEvent</li>
<li>* VmPoweredOnEvent</li>
<li>* VmMigratedEvent</li>
<li>* TaskEvent:Initialize powering On</li>
<li>* TaskEvent:Power Off virtual machine</li>
<li>* TaskEvent:Power On virtual machine</li>
<li>* TaskEvent:Reconfigure virtual machine</li>
<li>* TaskEvent:Relocate virtual machine</li>
<li>* TaskEvent:Suspend virtual machine</li>
<li>* TaskEvent:Migrate virtual machine</li>
<li>* VmMessageEvent</li>
<li>* VmSuspendedEvent</li>
<li>* VmPoweredOffEvent</li>
</ul>Note that events sent to StackState in a telemetry stream will not be visible in the StackState events perspective.
| 
| Metrics | The metrics retrieved from vSphere can be configured in the Agent check configuration file using the configuration items **collection_level** and **all_metrics**. For details see [configure the vSphere check](#configure), above and [Data Collection Levels\(docs.vmware.com\)](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-25800DE4-68E5-41CC-82D9-8811E27924BC.html).

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
