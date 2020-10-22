---
description: StackPack description
---

# StackPack name

## Overview

The Dynatrace StackPack is used to create a synchronization with Dynatrace instance collecting your smartscape topology. 
Currently supported Component Types are : 
* _Hosts_
* _Applications_
* _Processes_
* _Process-Groups_
* _Services_

This StackPack gives you the possibility to filter the view with below key parameters which will have a default prefix value `dynatrace-`.
* _ManagementZones_
* _EntityID_
* _Tags_
* _MonitoringState_

As an example, If you want to filter the view with `ManagementZones` then you will see the key as `dynatrace-managementZones:<value>` in the `label` filter 
box. Same path can be followed with other parameters. 

**Note** : Currently, we gather the Dynatrace Smartscape topology from the last 72 hours as per default to Dynatrace.

## Setup

### Pre-requisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to Dynatrace and StackState. (See the [StackState Agent V2 StackPack](/#/stackpacks/stackstate-agent-v2/) for more details)
* A Dynatrace instance must be running.
* An API Token from Dynatrace with access to read the Smartscape Topology.

### Install

The Dynatrace StackPack requires the following parameters to collect the topology information :

* **Dynatrace URL** -- the dynatrace url from which topology need to be collected. 
* **Dynatrace Instance Name** -- the user-defined name of Dynatrace account shown in configurations such as views. 

### Configure

To enable the dynatrace check which collects the data from Dynatrace system:

Edit the `conf.yaml` file in your agent `/etc/stackstate-agent/conf.d/dynatrace.d` directory, replacing `<url>` and `<token>` with the information from your Dynatrace instance. You can provide `domain` and `environment` in the instance config which will take precedence in the StackState view.

```
# Section used for global dynatrace check config
init_config:

instances:
  # mandatory
  - url: <url> # URL of the Dynatrace instance
    token: <token> # API-Token to connect to dynatrace
    # verify: True  # By default it's True
    # cert: /path/to/cert.pem
    # keyfile: /path/to/key.pem
    # domain: "axa"
    # environment: "axa"
    # tags:
    #   - foo:bar

```

To publish the configuration changes, restart the StackState Agent(s) using below command.

```
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

### Status

To check the status of the DynaTrace integration, run the status subcommand and look for DynaTrace under `Running Checks`:

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

The API Token configured in StackState Agent V2 must have the permission **Access problems and event feed, metrics, and topology**. See [DynaTrace API token permsissions (dynatrace.com)](https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication/#token-permissions) for details. The API endpoints used in the StackState integration are listed below:

* `/api/v1/entity/applications`
* `/api/v1/entity/infrastructure/hosts`
* `/api/v1/entity/infrastructure/processes`
* `/api/v1/entity/infrastructure/process-groups`
* `/api/v1/entity/services`

**NOTE** 
Refer to the Dynatrace documentation for details on [how to create an API Token](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token)

### Open source

The code for the DynaTrace check is open source and available on GitHub at:
[https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology](https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=DynaTrace).

## Uninstall

To uninstall the DynaTrace StackPack and disable the DynaTrace check:

1. Go to the StackState UI StackPacks > Integrations > DynaTrace screen and click UNINSTALL.
    - All DynaTrace specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:
    ```
    mv dynatrace.d/conf.yaml dynatrace.d/conf.yaml.bak
    ```
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## See also

- [StackState Agent V2](/stackpacks/integrations/agent.md)
- [How to generate a DynaTrace API token (dynatrace.com)](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token)
- [Permissions for DynaTrace API tokens (dynatrace.com)](https://www.dynatrace.com/support/help/shortlink/api-authentication#token-permissions)