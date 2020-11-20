---
description: Near real-time synchronization with VMware vSphere
---

# VMware vSphere

## What is the VMware vSphere StackPack?

The VMware vSphere StackPack is used to create a near real-time synchronization with VMware vSphere.

This StackPack provides functionality that allows for monitoring of the following resources:

* hosts
* virtual machines
* compute resources
* cluster compute resources
* data stores
* data centers

VMware StackPack collects all topology data for the components and relations between them as well as telemetry and events.

## Prerequisites

* [StackState Agent V2](/stackpacks/integrations/agent.md) must be installed on a single machine that can connect to VSphere VCenter and StackState.
* A VSphere VCenter instance must be running.

### Network communication

* The [StackState Agent V2](/stackpacks/integrations/agent.md) connects to the vSphere instance on TCP port 443.
* The [StackState Agent V2](/stackpacks/integrations/agent.md) connects to StackState API on TCP port 7077
* If the Agent is installed on the StackState host then port 7077 is localhost communication.
* If the Agent is installed on a different host, you need a network path between the Agent and StackState on port 7077/tcp, and to vSphere on 443/tcp port.

## Enable vSphere integration

To enable the vSphere check and begin collecting data from your VSphere VCenter instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/vsphere.d/conf.yaml` to include details of your VSphere VCenter instance:
    - **name**
    - **host** - the same as the `vSphere Host Name` used in the StackPack provisioning process.
    - **username**
    - **password** - use [secrets management](/configure/security/secrets_management.md) to store passwords outside of the configuration file.
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
    
2. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Configuration options

The following configuration options can be added to the vSphere configuration file. Find details in the [`conf.yaml.example` file](https://github.com/StackVista/sts-agent-integrations-core/blob/master/vsphere/conf.yaml.example)

| Options | Required? | Description |
| :--- | :--- | :--- |
| `ssl_verify` | No | Set to false to disable SSL verification, when connecting to vCenter. |
| `ssl_classpath` | No | Set to the absolute file path of a directory that contains CA certificates in PEM format, e.g. `/path/to/file.pem` |
| `host_include_only_regex` | No | Use a regex [like this - conf.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/vsphere/conf.yaml.example), if you want the check to only fetch metrics for these ESXi hosts and the VMs running on it. |
| `vm_include_only_regex` | No | Use a regex to include only the VMs that are matching this pattern. More details in [conf.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/vsphere/conf.yaml.example) |
| `include_only_marked` | No | Set to true, if you would like to only collect metrics on vSphere VMs that are marked by a custom field with the value  `DatadogMonitored`. |
| `collection_level` | No | A number between 1 and 4 to specify how many metrics are sent, 1 meaning only important monitoring metrics, and 4 meaning every metric available. |

## Special tags

The vSphere StackPack understands the following special tags:

|  |  |
| :--- | :--- |
| `stackstate-identifier` | Adds the specified value as an identifier to the StackState component |

## Data collected

### Metrics

|  |  |  |  |
| :--- | :--- | :--- | :--- |
| vsphere.clusterServices.cpufairness.latest \(gauge\) | Fairness of distributed CPU resource allocation |  |  |
| vsphere.clusterServices.effectivecpu.avg \(gauge\) | Total available CPU resources of all hosts within a cluster. Shown as megahertz |  |  |
| vsphere.clusterServices.effectivemem.avg \(gauge\) | Total amount of machine memory of all hosts in the cluster that is available for use for virtual machine memory \(physical memory for use by the Guest OS\) and virtual machine overhead memory. Shown as mebibyte |  |  |
| vsphere.clusterServices.failover.latest \(gauge\) | vSphere HA number of failures that can be tolerated |  |  |
| vsphere.clusterServices.memfairness.latest \(gauge\) | Fairness of distributed memory resource allocation |  |  |
| vsphere.cpu.coreUtilization.avg \(gauge\) | CPU utilization of the corresponding core \(if hyper-threading is enabled\) as a percentage |  |  |
| vsphere.cpu.costop.sum \(gauge\) | Time the virtual machine is ready to run but is unable to run due to co-scheduling constraints. Shown as millisecond | vsphere.cpuentitlement.latest | Amount of CPU allocated to a virtual machine or a resource pool. Shown as megahertz |
| vsphere.cpu.demand.avg | The amount of CPU virtual machine would use if there was no CPU contention or CPU limits. Shown as megahertz |  |  |

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=vSphere).