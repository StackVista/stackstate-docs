---
description: StackState curated integration
---

# SolarWinds

## Overview

 The SolarWinds StackPack allows near real time synchronization between SolarWinds Orion (SolarWinds) and StackState. When the integration is enabled, SolarWinds nodes, interfaces and connections will be added to the StackState topology as components and relations. *In addition, health status is applied to the components in StackState.*

![Data flow](../../.gitbook/assets/stackpack-solarwinds-new.svg)

* Agent V2 connects to the configured [SolarWinds API](#rest-api-endpoints) (default via TCP port 17778).
* Nodes, interfaces and connections are retrieved from the SolarWinds instance.
* *Node and interface Health status is retrieved from the SolarWinds instance and translated to StackState values*.
* Agent V2 pushes [retrieved data](#data-retrieved) to StackState.
* StackState translates incoming nodes, interfaces and connections into topology components and relations.
* *Links to SolarWinds detail dashboards are created as component actions to easily access more information from SolarWinds when needed.* 

## Setup

### Prerequisites

To set up the SolarWinds integration you will need to have:

* [StackState Agent V2](/setup/agent/about-stackstate-agent.md) installed on a machine that can connect to both SolarWinds (default via TCP port 17778) and StackState.
* *To support component actions from StackState, the SolarWinds server needs to be accessible from the user's browser.* 
* A running SolarWinds instance with a Network Performance Monitor (NPM) module.  
* A SolarWinds user with access to the required [API endpoints](#rest-api-endpoints).
    - The lowest access level is sufficient.
    - The user must not have any account limitations set that block access to nodes intended to be retrieved.

### Install

Install the SolarWinds StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **SolarWinds Instance URL**: The SolarWinds instance URL from which topology data will be collected.
* **SolarWinds Instance Name**: The user-defined name of the SolarWinds account shown in configurations such as views.

### Configure

To enable the SolarWinds check and begin collecting data from SolarWinds, add the following configuration to StackState Agent V2:

1.  Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/solarwinds.d/conf.yaml` to include details of your SolarWinds instance:
    * **url** - the REST API URL, uses HTTPS protocol for communication.
    * **user** - a SolarWinds user with access to the required [SolarWinds API endpoints](#rest-api-endpoints).
    * **password** - use [secrets management](../../configure/security/secrets_management.md) to store passwords outside the configuration file.

    ```text
    init_config:
    
    instances:
      - url: <instance_name.solarwinds.localdomain>
        instance_type: solarwinds
        source_identifier: 'urn:solarwinds:'
        min_collection_interval: 30
        username: <instance_username>
        password: <instance_password>
        solarwinds_domain: <instance_domain>
        solarwinds_domain_values:
          - <instance_domain_value_1>
          - <instance_domain_value_2>
          - <instance_domain_value_n>
    ```
2. Set the following filters:
   - **solarwinds_domain** - The name of a SolarWinds custom property that will be used to select nodes from SolarWinds to include in the StackState dataset.
   - **solarwinds_domain_values** - A list of values used by the specified `solarwinds_domain` to select the correct nodes for inclusion. Any node in SolarWinds that has one of these values set will be included in the data collection. Each value in this list will be represented as a separate domain in StackState.
3. [Restart the StackState Agent\(s\)](/setup/agent/about-stackstate-agent.md#run-stackstate-agent-v2) to apply the configuration changes.
4. Once the Agent has restarted, wait for data to be collected from SolarWinds and sent to StackState.

### Status

To check the status of the SolarWinds integration, run the status subcommand and look for SolarWinds under `Running Checks`:

```text
sudo stackstate-agent status
```

### Upgrade

When a new version of the SolarWinds StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **SolarWinds**. For an overview of recent StackPack updates, check the [StackPack versions](../../setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

For considerations and instructions on upgrading a StackPack, see [how to upgrade a StackPack](../about-stackpacks.md#upgrade-a-stackpack).

## Integration details

### REST API endpoints

The SolarWinds user configured in the StackState Agent V2 must have read access to the SolarWinds API (default for all user accounts). No additional authorization needs to be set for this account in the SolarWinds system.

Refer to the SolarWinds product documentation for details on how to [Manage Orion Web Console user accounts in the Orion Platform \(documentation.solarwinds.com\)](https://documentation.solarwinds.com/en/success_center/orionplatform/content/core-managing-web-accounts-sw1724.htm).

### Data retrieved

#### Events

The SolarWinds check does not retrieve any event data.

#### Metrics

The SolarWinds check does not retrieve any metrics data.

#### Topology

The SolarWinds server can contain different modules suitable for data retrieval by the StackState SolarWinds integration. 

* **Network Performance Monitor (NPM) module** - provides information about nodes, interfaces and layer-2 topology information for network devices. Layer-2 topology information for non-network devices is only available when the User Device Tracker (UDT) SolarWinds module is installed.

* **User Device Tracker (UDT) module** - provides layer-2 topology information for non-network devices in the form of MAC-address tables from routers, switches and firewalls. This is added to the data retrieved from NPM, resulting in a complete topology for all SolarWinds nodes.

The SolarWinds check retrieves the following topology data from SolarWinds:

| Data | Description |
| :--- | :--- |
| Components | Nodes and interfaces. In some cases, a SolarWinds node will not show any interfaces in the SolarWinds system. If UDT detects that such a node is connected to a device, a 'ghost' interface will be created in StackState to show the full topology.  |
| Relations | **NPM**: Layer-2 topology information from network devices. **UDT**: Layer-2 topology information connecting generic nodes to network devices |

#### *Health*

*The SolarWinds check retrieves the health status from nodes and interfaces and translates these statuses to StackState statuses:*

| Health status SolarWinds | Health status StackState |
| :----------------------- | :----------------------- |
| Up                       | Clear                    |
| External                 | Clear                    |
| Unmanaged                | Clear                    |
| Unreachable              | Clear                    |
| Shutdown                 | Clear                    |
| Warning                  | Deviating                |
| Unknown                  | Deviating                |
| Down                     | Critical                 |
| Critical                 | Critical                 |

#### Traces

The SolarWinds check does not retrieve any trace data.

### SolarWinds views in StackState

When the SolarWinds integration is enabled, the following SolarWinds specific views are available in StackState:

* Node Details
* Interface Details

### Open source

The code for the StackState SolarWinds check is open source and available on GitHub at: [https://github.com/StackVista/stackstate-agent-integrations/tree/master/SolarWinds](https://github.com/StackVista/stackstate-agent-integrations/tree/master/SolarWinds)


## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=SolarWinds).

## Uninstall

To uninstall the SolarWinds StackPack and disable the Dynatrace check:

1. Go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **SolarWinds** screen and click **UNINSTALL**.
   * All SolarWinds specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv solarwinds.d/conf.yaml solarwinds.d/conf.yaml.bak
   ```

3. [Restart the StackState Agent\(s\)](/setup/agent/about-stackstate-agent.md#run-stackstate-agent-v2) to apply the configuration changes.

## Release notes

**SolarWinds StackPack v1.0.0 (*2021-07-22)***

- Initial release.

## See also

* [StackState Agent V2](/setup/agent/about-stackstate-agent.md)
* [Secrets management](https://docs.stackstate.com/configure/security/secrets_management)
* [StackState Agent integrations - SolarWinds (github.com)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/SolarWinds)  
* [Manage Orion Web Console user accounts in the Orion Platform \(documentation.solarwinds.com\)](https://documentation.solarwinds.com/en/success_center/orionplatform/content/core-managing-web-accounts-sw1724.htm)