---
description: 
---

# SCOM

## Overview

The SCOM StackPack is used to create a near real time synchronisation with your SCOM instance. The SCOM integration can be configured to run as either an API integration or PowerShell integration \(BETA\), these are described in the tabs below the diagram.

![Data flow](/.gitbook/assets/stackpack-scom_2.png)

{% tabs %}
{% tab title="API integration" %}
### API integration

The StackState SCOM API integration sends requests to the SCOM API to retrieve topology data and events.

- Agent V2 connects to the configured [SCOM API](#rest-api-endpoints).
- Topology data and events for the configured classes are retrieved from SCOM.
- Agent V2 pushes [retrieved data](#data-retrieved) to StackState.
- StackState translates incoming SCOM topology data into components and relations. Incoming events are used to determine component health state and publish SCOM alerts in StackState.

#### Pros and cons of API integration

The SCOM API integration produces a clean topology in StackState by allowing you to configure specific classes to collect from SCOM. You can run the SCOM check from any StackState Agent V2 as long as it can connect to both the SCOM API and StackState.

Retrieving a large topology can require a large number of API requests, this can take time and may place some stress on your SCOM system. The size of topology you can retrieve may also be limited by the number of requests possible. To avoid this, use the SCOM PowerShell integration (BETA).

{% endtab %}
{% tab title="PowerShell integration (BETA)" %}
### PowerShell integration (BETA)

The StackState SCOM PowerShell integration runs PowerShell scripts on the SCOM box to retrieve topology data and events.

- PowerShell scripts in Agent V2 collect topology data and events from SCOM..
- Agent V2 pushes [retrieved data](#data-retrieved) to StackState.
- StackState translates incoming SCOM topology data into components and relations. Incoming events are used to determine component health state and publish SCOM alerts in StackState.

#### Pros and cons of PowerShell integration

The PowerShell integration retrieves all SCOM topology data quickly without placing strain on your SCOM system. This means that there is no limit on the size of topology that can be retrieved.

The PowerShell integration scripts must be run by an instance of StackState Agent V2 installed on the same box as SCOM and will always retrieve all topology data. This might be undesirable or confusing when viewed in StackState. If you would like to specify the SCOM classes retrieved or need to run the integration from a StackState Agent installed in another location, you should use the SCOM API integration.

{% endtab %}
{% endtabs %}

## Setup

### Prerequisites

{% tabs %}
{% tab title="API integration" %}
To set up the StackState SCOM API integration, you need to have:
* [StackState Agent V2](/stackpacks/integrations/agent.md) must be installed on any machine that can connect to both SCOM and StackState.
* A running SCOM instance (version 1806 or 2019).
* A SCOM user with the role **Operations Manager Read-Only Operators**.
{% endtab %}
{% tab title="PowerShell integration (BETA)" %}
To set up the StackState SCOM PowerShell integration, you need to have:
* [StackState Agent V2](/stackpacks/integrations/agent.md) must be on the same machine running SCOM.
* A running SCOM instance (version 1806 or 2019).
{% endtab %}
{% endtabs %}


### Install



### Configure



### Status

To check the status of the SCOM integration, run the status subcommand and look for SCOM under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### REST API endpoints

Retrieving topology data from SCOM requires 3 API requests per component. 

| API endpoint | Description | 
|:---|:---|
| `OperationsManager/data/scomObjectsByClass` | Get components for the configured class(es). |
| `OperationsManager/data/scomObjects` | Get type of component. |
| `OperationsManager/data/objectInformation` | Get component information and relations. |
| `OperationsManager/data/alert` | Alerts. |


### Data retrieved

#### Events

The SCOM check retrieves component Alerts and Health State as events from SCOM.

##### Alerts

Alerts are retrieved every ??? from SCOM...

##### Health state

Health state is retrieved per component 

#### Metrics

The SCOM check does not retrieve any metrics data.

#### Topology

| Data | Description |
|:---|:---|
| Components |  |
| Relations |  | 

#### Traces

The SCOM check does not retrieve any traces data.

### Open source

The code for the StackState SCOM check is open source and available on GitHub at:
[https://github.com/StackVista/stackstate-agent-integrations/tree/master/scom](https://github.com/StackVista/stackstate-agent-integrations/tree/master/scom)


## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=SCOM).

## Uninstall

To uninstall the SCOM StackPack and disable the SCOM check:

1. Go to the StackState UI StackPacks > Integrations > SCOM screen and click UNINSTALL.
    - All SCOM specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:
    ```
    mv scom.d/conf.yaml scom.d/conf.yaml.bak
    ```
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## See also

- [StackState Agent V2](/stackpacks/integrations/agent.md)
- [StackState Agent integrations - SCOM (github.com)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/scom)
- [SCOM API reference \(microsoft.com\)](https://docs.microsoft.com/en-us/rest/api/operationsmanager/)


===========

## What is the SCOM StackPack?

The SCOM StackPack is used to create a near real time synchronisation with your SCOM instance.

## Prerequisites

The following prerequisites need to be met:

* [StackState Agent V2](/stackpacks/integrations/agent.md)  must be installed on a single machine which can connect to SCOM and StackState.
* A SCOM instance must be running.

**NOTE**:- We support SCOM version 1806 and 2019.

## Enable SCOM integration

To enable the SCOM check and begin collecting data from your SCOM instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/scom.d/conf.yaml`  to include details of your SCOM instance:
    - **hostip** - SCOM IP.
    - **domain** - active directory domain where the SCOM is located.
    - **auth_mode** - Network or Windows (Default is Network).
    - **username** 
    - **password** - use [secrets management](/configure/security/secrets_management.md) to store passwords outside of the configuration file.

    ```text
    # Section used for global SCOM check config
    init_config:
        # run every minute
        min_collection_interval: 60
    
    instances:
      - hostip: #SCOM IP
        domain: # active directory domain where the SCOM is located
        username: # username
        password: # password
        auth_mode: Network # Network or Windows (Default is Network)
        streams:
          #- name: SCOM
          #  class: Microsoft.SystemCenter.ManagementGroup  --> Management Pack root class
          #- name: Exchange
          #  class: Microsoft.Exchange.15.Organization
          #- name: Skype
          #  class: Microsoft.LS.2015.Site
    ```

2. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

