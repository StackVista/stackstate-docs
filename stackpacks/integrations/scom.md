---
description: 
---

# SCOM

## Overview



![Data flow](/.gitbook/assets/stackpack-scom1.png)

## Setup

### Pre-requisites


### Install



### Configure



### Status

To check the status of the Dynatrace integration, run the status subcommand and look for SCOM under `Running Checks`:

```
sudo stackstate-agent status
```

## Integration details

### REST API endpoints



### Data retrieved

#### Events



#### Metrics



#### Topology



#### Traces



### Open source


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

