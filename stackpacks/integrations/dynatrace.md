---
description: Collect Smartscape topology data from DynaTrace
---

# StackPack name

## Overview

The DynaTrace StackPack creates a synchronization between a Dynatrace instance and StackState, collecting. When the integration is enabled, DynaTrace Smartscape topology from the last 72 hours will be added to the StackState topology. 

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

To enable the DynaTrace check and begin collecting data from DynaTrace, the following configuration should be added to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` to include details of your DynaTrace instance:
    - **url** - the URL of the DynaTrace instance.
    - **token** - an API token with access to the required [DynaTrace API endopints](#rest-api-endpoints)

    ```
    # Section used for global dynatrace check config
    init_config:
    
    instances:
      # mandatory
      - url: <url> # URL of the DynaTrace instance
        token: <token> # API-Token to connect to DynaTrace
        # verify: True  # By default its True
        # cert: /path/to/cert.pem
        # keyfile: /path/to/key.pem
        # domain: <domain>
        # environment: <environment>
        # tags:
        #   - foo:bar
    
    ```
2. Optional: Provide a `domain` and `environment` in the `conf.yaml` file, this will take precedence in the StackState view.
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.
4. Once the Agent has restarted, wait for data to be collected from DynaTrace and sent to StackState.

### Status

To check the status of the DynaTrace integration, run the status subcommand and look for DynaTrace under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events

The DynaTrace check does not retrieve any events data.

#### Metrics

The DynaTrace check does not retrieve any metrics data.

#### Topology

The DynaTrace check retrieves the following Smartscape topology data:

- Hosts
- Applications
- Processes
- Process-Groups
- Services

#### Traces

The DynaTrace check does not retrieve any traces data.

### REST API endpoints

The API Token configured in StackState Agent V2 must have the permission **Access problems and event feed, metrics, and topology**, see [DynaTrace API token permsissions (dynatrace.com)](https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication/#token-permissions). The API endpoints used in the StackState integration are listed below:

* `/api/v1/entity/applications`
* `/api/v1/entity/infrastructure/hosts`
* `/api/v1/entity/infrastructure/processes`
* `/api/v1/entity/infrastructure/process-groups`
* `/api/v1/entity/services`

{% hint style="info" %}
Refer to the Dynatrace documentation for details on [how to create an API Token](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token)
{% endhint %}

### Additional filters in StackState views

The DynaTrace integration enables additional keys to filter StackState views:

* dynatrace-ManagementZones
* dynatrace-EntityID
* dynatrace-Tags
* dynatrace-MonitoringState

For example, if you want to filter the view with `ManagementZones` then you will see the key as `dynatrace-managementZones:<value>` in the `label` filter box.

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