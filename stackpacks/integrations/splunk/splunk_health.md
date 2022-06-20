---
description: StackState Self-hosted v5.0.x
---

# Splunk Health

## Overview

When the [Splunk StackPack](splunk_stackpack.md) has been installed in StackState, you can configure the Splunk Health check on StackState Agent V2 to begin collecting Splunk health data.

Health is collected from Splunk by executing Splunk saved searches from StackState Agent V2. In order to receive Splunk health data in StackState, configuration needs to be added to both Splunk and StackState Agent V2:

* [In Splunk](splunk_health.md#splunk-saved-search) - there should be at least one saved search that generates the health data you want to retrieve.
* [In StackState Agent V2](splunk_health.md#agent-check) - a Splunk Health check should be configured to connect to your Splunk instance and execute the relevant Splunk saved searches.

The Splunk Health check on StackState Agent V2 will execute all configured Splunk saved searches periodically to retrieve a snapshot of the health at the current time.

## Splunk saved search

### Fields used

StackState Agent V2 executes the Splunk saved searches configured in the [Splunk Health Agent check](splunk_health.md#agent-check) and pushes retrieved data to StackState. The following fields from the results of a saved search are sent to StackState:

| Field | Type | Required? | Description                                                                     |
| :--- | :--- | :--- |:--------------------------------------------------------------------------------|
| **check\_state\_id** | ✅ | string | The unique identifier for the check state.                                      |
| **name** | string | ✅ | Display name for the check state.                                               |
| **health** | string | ✅ | The health value of the check state. Can be `CLEAR`, `DEVIATING` or `CRITICAL`. |
| **topology\_element\_identifier** | string | ✅ | The identifier of the component/relation this check state belongs to.           |
| **message** | string | - | Extended message associated with the check state, supports markdown.            |

### Example Splunk query

{% tabs %}
{% tab title="Splunk query for components" %}
```text
| loadjob savedsearch=:disks
| search OrganizationPart="*" OrgGrp="*" company="*"
| table host disk available_pct
| eval check_state_id = strcat host "_" disk
| eval name = disk
| eval health = case(available_pct == 0, "critical", true, "clear") 
| eval topology_element_identifier = host
| table check_state_id name health topology_element_identifier
```
{% endtab %}
{% endtabs %}

## Agent check

### Configure the Splunk Health check

To enable the Splunk Health integration and begin collecting health data from your Splunk instance, the Splunk Health check must be configured on StackState Agent V2. The check configuration provides all details required for the Agent to connect to your Splunk instance and execute a Splunk saved search.

{% hint style="info" %}
Example Splunk Health Agent check configuration file:  
[splunk\_health/conf.yaml.example \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/splunk_health/stackstate_checks/splunk_health/data/conf.yaml.example)
{% endhint %}

To configure the Splunk Health Agent check:

1. Edit the StackState Agent V2 configuration file `/etc/stackstate-agent/conf.d/splunk_health.d/conf.yaml`.
2. Under **instances**, add details of your Splunk instance:
   * **url** - The URL of your Splunk instance.
   * **authentication** - How the Agent should authenticate with your Splunk instance. Choose either token-based \(recommended\) or basic authentication. For details, see [authentication configuration details](splunk_stackpack.md#authentication).
   * **ignore\_saved\_search\_errors** - Set to `false` to return an error if one of the configured saved searches does not exist. Default `true`.
   * **collection_interval** - The interval at which the check is scheduled to run.
3. Under **saved\_searches**, add details of each Splunk saved search that the check should execute to retrieve health information: 
   * **name** - The name of the [Splunk saved search](splunk_health.md#splunk-saved-search) to execute.
     * **match** - Regex used for selecting Splunk saved search queries. Default `"health.*"`.
     * **app** - The Splunk app in which the saved searches are located. Default `"search"`.
     * **request\_timeout\_seconds** - Default `10`.
     * **search\_max\_retry\_count** - Default `5`.
     * **search\_seconds\_between\_retries** - Default `1`.
     * **batch\_size** - Default `1000`.
     * **parameters** - Used in the Splunk API request. The default parameters provided make sure the Splunk saved search query refreshes. Default `force_dispatch: true` and `dispatch.now: true`.
4. More advanced options can be found in the [example configuration \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/splunk_health/stackstate_checks/splunk_health/data/conf.yaml.example). 
5. Save the configuration file.
6. Restart StackState Agent V2 to apply the configuration changes.
7. Incoming health data will be mapped to associated components and relations in the StackState UI as check states.
8. To more closely inspect what the synchronization is doing, [use the StackState CLI](../../../configure/health/debug-health-sync.md)

{% hint style="info" %}
The configured `collection_interval` will be used as the [`repeat_interval` for the health synchronization](../../../configure/health/health-synchronization.md#repeat-interval). Make sure that the value set for the the `collection_interval` matches the time that the check will take to run.
{% endhint %}

### Disable the Agent check

To disable the Splunk Health Agent check:

1. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv /etc/stackstate-agent/conf.d/splunk_health.d/conf.yaml /etc/stackstate-agent/conf.d/splunk_health.d/conf.yaml.bak
   ```

2. Restart StackState Agent V2 to apply the configuration changes.

## See also

* [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md)
* [StackState Splunk integration details](splunk_stackpack.md)
* [Health synchronization](../../../configure/health/health-synchronization.md)
* [Debug health synchronization](../../../configure/health/debug-health-sync.md)
* [Example Splunk Health configuration file - splunk\_health/conf.yaml.example \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/splunk_health/stackstate_checks/splunk_health/data/conf.yaml.example)
* [Splunk default fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields)

