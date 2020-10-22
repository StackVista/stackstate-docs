---
description: Collect Smartscape topology data from Dynatrace
---

# StackPack name

## Overview

The Dynatrace StackPack creates a synchronization between a Dynatrace instance and StackState, collecting. When the integration is enabled, Dynatrace Smartscape topology from the last 72 hours will be added to the StackState topology. 

## Setup

### Pre-requisites

To set up the Dynatrace integration:

* [StackState Agent V2](/stackpacks/integrations/agent.md) installed on a machine that can connect to both Dynatrace and StackState.
* A running Dynatrace instance.
* A Dynatrace API Token with access to read the Smartscape Topology, see [REST API endpoints](#rest-api-endpoints).

### Install

The Dynatrace StackPack requires the following parameters to collect the topology information :

* **Dynatrace URL** - the Dynatrace URL from which topology need to be collected. 
* **Dynatrace Instance Name** - the user-defined name of the Dynatrace account shown in configurations such as views. 

### Configure

To enable the Dynatrace check and begin collecting data from Dynatrace, the following configuration should be added to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/dynatrace.d/conf.yaml` to include details of your Dynatrace instance:
    - **url** - the URL of the Dynatrace instance.
    - **token** - an API token with access to the required [Dynatrace API endopints](#rest-api-endpoints).

    ```
    # Section used for global dynatrace check config
    init_config:
    
    instances:
      # mandatory
      - url: <url> # URL of the Dynatrace instance
        token: <token> # API-Token to connect to Dynatrace
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
4. Once the Agent has restarted, wait for data to be collected from Dynatrace and sent to StackState.

### Status

To check the status of the Dynatrace integration, run the status subcommand and look for Dynatrace under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### Data retrieved

#### Events

The Dynatrace check does not retrieve any events data.

#### Metrics

The Dynatrace check does not retrieve any metrics data.

#### Topology

The Dynatrace check retrieves the following Smartscape topology data:

- Hosts
- Applications
- Processes
- Process-Groups
- Services

#### Traces

The Dynatrace check does not retrieve any traces data.

### REST API endpoints

The API Token configured in StackState Agent V2 must have the permission **Access problems and event feed, metrics, and topology**, see [Dynatrace API token permsissions (dynatrace.com)](https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication/#token-permissions). The API endpoints used in the StackState integration are listed below:

* `/api/v1/entity/applications`
* `/api/v1/entity/infrastructure/hosts`
* `/api/v1/entity/infrastructure/processes`
* `/api/v1/entity/infrastructure/process-groups`
* `/api/v1/entity/services`

{% hint style="info" %}
Refer to the Dynatrace documentation for details on [how to create an API Token](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token)
{% endhint %}

### Filters for StackState views

The Dynatrace integration enables additional keys to filter StackState views:

* dynatrace-ManagementZones
* dynatrace-EntityID
* dynatrace-Tags
* dynatrace-MonitoringState

For example, if you want to filter the view with `ManagementZones` then you will see the key as `dynatrace-managementZones:<value>` in the `label` filter box.

### Open source

The code for the Dynatrace check is open source and available on GitHub at:
[https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology](https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=Dynatrace).

## Uninstall

To uninstall the Dynatrace StackPack and disable the Dynatrace check:

1. Go to the StackState UI StackPacks > Integrations > Dynatrace screen and click UNINSTALL.
    - All Dynatrace specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:
    ```
    mv dynatrace.d/conf.yaml dynatrace.d/conf.yaml.bak
    ```
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## See also

- [StackState Agent V2](/stackpacks/integrations/agent.md)
- [How to generate a Dynatrace API token (dynatrace.com)](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token)
- [Permissions for Dynatrace API tokens (dynatrace.com)](https://www.dynatrace.com/support/help/shortlink/api-authentication#token-permissions)