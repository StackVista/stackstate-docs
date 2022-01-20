---
description: StackState Self-hosted v4.5.x
---

# 💠 Dynatrace

## Overview

The Dynatrace StackPack creates a synchronization between a Dynatrace instance and StackState. When the integration is enabled, Dynatrace Smartscape topology and events for the configured `relative_time` \(default 1 hour\) will be available in StackState.

Dynatrace is a [StackState core integration](/stackpacks/integrations/about_integrations.md#stackstate-core-integrations).

![Data flow](../../.gitbook/assets/stackpack-dynatrace.svg)

* Agent V2 connects to the configured [Dynatrace API](dynatrace.md#rest-api-endpoints) to retrieve data:
  * If a Dynatrace topology check is configured, Topology and Smartscape data is retrieved
  * If a Dynatrace health check is configured, events data is retrieved.
* Agent V2 pushes [retrieved data](dynatrace.md#data-retrieved) to StackState.
    * [Topology data](dynatrace.md#topology) is translated into components and relations. 
    * [Tags](dynatrace.md#tags) defined in Dynatrace are added to components and relations in StackState. Any defined StackState tags are used by StackState when the topology is retrieved.
    * [Events](dynatrace.md#events) are available in the StackState Events Perspective and listed in the details pane of the StackState UI.

## Setup

### Pre-requisites

To set up the Dynatrace integration you will need to have:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) installed on a machine that can connect to both Dynatrace and StackState.
* A running Dynatrace instance.
* A [Dynatrace API Token](#dynatrace-api-token) with access to read the Smartscape Topology and Events.

### Install

Install the Dynatrace StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Dynatrace URL** - the Dynatrace URL from which topology will be collected. 
* **Dynatrace Instance Name** - the user-defined name of the Dynatrace account shown in configurations such as views. 

### Configure

To enable the Dynatrace integration, two Dynatrace checks need to be configured.: 
- [Dynatrace topology check](#dynatrace-topology-check) - collects topology data. 
- [Dynatrace health check](#dynatrace-health-check) - collects events data from Dynatrace.

#### Dynatrace Topology Check

{% hint style="info" %}
If only the Dynatrace topology check is enabled, no Dynatrace events data will be available in StackState and components will be reported with a green (CLEAR) health state. To enable retrieval of events data from Dynatrace, you should also enable the [Dynatrace health check](#dynatrace-health-check).
{% endhint %}

To enable the Dynatrace topology check and begin collecting topology data from Dynatrace, add the following configuration to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/dynatrace_topology.d/conf.yaml` to include details of your Dynatrace instance:
   * **url** - the base URL of the Dynatrace instance.
     - SaaS url example - https://{your-environment-id}.live.dynatrace.com
     - Managed url example - https://{your-domain}/e/{your-environment-id} 
   * **token** - a [Dynatrace API token](#dynatrace-api-token) with access to the required [Dynatrace API endpoints](dynatrace.md#rest-api-endpoints). Use [secrets management](../../configure/security/secrets_management.md) to store tokens outside of the configuration file.

    ```
    # Section used for global dynatrace check config
    init_config:
    
    instances:
      - # min_collection_interval: 300 # use in place of collection_interval for Agent v2.14.x or earlier 
        collection_interval: 300
        url: <url>  #the base URL of the Dynatrace instance.
        # SaaS url example - https://{your-environment-id}.live.dynatrace.com
        # Managed url example - https://{your-domain}/e/{your-environment-id} 
        token: <token>  # API-Token to connect to Dynatrace
        # verify: True  # By default its True
        # cert: /path/to/cert.pem
        # keyfile: /path/to/key.pem
        # timeout: 10
        # domain: <domain>  # default 'dynatrace'
        # environment: <environment>  # default 'production'
        # relative_time : <relative_time> # default 'hour'
        # custom_device_relative_time: 1h
        # custom_device_fields: +fromRelationships,+toRelationships,+tags,+managementZones,+properties.dnsNames,+properties.ipAddress
        # tags:
        #   - foo:bar
    
    ```
2. You can also add optional configuration to specify where imported Dynatrace topology will end up in StackState:
   - **domain** - The domain to use for imported topology (default dynatrace).
   - **environment** - The environment to use for imported topology (default production).
3. Other optional configuration options are:
   - **collection_interval** - The frequency with which topology data is retrieved from Dynatrace. If you have a large amount of topology data to collect from Dynatrace, the topology check will need to run for longer . Default `300` seconds.
   - **verify** - To verify the certificate for HTTPS.
   - **cert** - The path to the certificate file for HTTPS verification.
   - **keyfile** - The path to public key of certificate for https verification.
   - **timeout** - Timeout for requests.
   - **relative_time** - The relative timeframe for retrieving topology.
   - **custom_device_relative_time** - The relative timeframe for retrieving custom devices.
   - **custom_device_fields** - Which Custom Device property fields will be used.
   - **tags** - custom tags appended to all components, useful for filtering.
4. [Restart the StackState Agent\(s\)](https://l.stackstate.com/ui-stackpack-restart-agent) to apply the configuration changes.
5. Once the Agent has restarted, wait for data to be collected from Dynatrace and sent to StackState.

#### Dynatrace Health Check

{% hint style="info" %}
If only the Dynatrace health check is enabled, no Dynatrace topology data will be available in StackState. Events data will be retrieved from Dynatrace, but there will be no components or relations available in StackState to map this to. To enable retrieval of topology data from Dynatrace, you should also enable the [Dynatrace topology check](#dynatrace-topology-check).
{% endhint %}

To enable the Dynatrace health check and begin collecting events from Dynatrace, add the following configuration to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/dynatrace_health.d/conf.yaml` to include details of your Dynatrace instance:
   * **url** - the base URL of the Dynatrace instance.
     - SaaS url example - https://{your-environment-id}.live.dynatrace.com
     - Managed url example - https://{your-domain}/e/{your-environment-id} 
   * **token** - a [Dynatrace API token](#dynatrace-api-token) with access to the required [Dynatrace API endpoints](dynatrace.md#rest-api-endpoints). Use [secrets management](../../configure/security/secrets_management.md) to store tokens outside of the configuration file.

    ```
    # Section used for global dynatrace check config
    init_config:
    
    instances:
      - # min_collection_interval: 60 # use in place of collection_interval for Agent v2.14.x or earlier 
        collection_interval: 60
        url: <url>  #the base URL of the Dynatrace instance.
        # SaaS url example - https://{your-environment-id}.live.dynatrace.com
        # Managed url example - https://{your-domain}/e/{your-environment-id} 
        token: <token>  # API-Token to connect to Dynatrace
        # verify: True  # By default its True
        # cert: /path/to/cert.pem
        # keyfile: /path/to/key.pem
        # timeout: 10
        # events_bootstrap_days: 5  # by default it's 5 days
        # events_process_limit: 10000  # by default it's 10k events
   
    ```
2. You can also add optional configuration:
   - **collection_interval** - The frequency with which events data is retrieved from Dynatrace. Note that the health check should have a shorter collection interval than the topology check. Default `60` seconds.
   - **verify** - To verify the certificate for https.
   - **cert** - The path to certificate file for https verification.
   - **keyfile** - The path to public key of certificate for https verification.
   - **timeout** - Timeout for requests.
   - **relative_time** - The relative timeframe for retrieving topology.
   - **events_bootstrap_days** - How many days in the past to collect events on the first run.
   - **events_process_limit** - Maximum number of events to process each run.
3. [Restart the StackState Agent\(s\)](https://l.stackstate.com/ui-stackpack-restart-agent) to apply the configuration changes.
4.Once the Agent has restarted, wait for data to be collected from Dynatrace and sent to StackState.

#### Dynatrace API token

The API Token configured in StackState Agent V2 must have the permission **Access problems and event feed, metrics, and topology** \(API value `DataExport`\). Note that this token must be generated by an admin Dynatrace user in Settings > Integrations > Dynatrace API. For details, see [Dynatrace API token permissions \(dynatrace.com\)](https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication/#token-permissions).

You can check if the generated token is working using the curl command:

```yaml
curl --request GET \
  --url https://mySampleEnv.live.dynatrace.com/api/v1/config/clusterversion \
  --header 'Authorization: Api-Token abcdefjhij1234567890' 
                                                
curl --request GET \
  --url https://myonpremise.dynatrace.stacstate.com/e/2342AD33afadsf/api/v1/config/clusterversion \
  --header 'Authorization: Api-Token abcdefjhij1234567890' 
```

### Status

To check the status of the Dynatrace integration, run the status subcommand and look for Dynatrace under `Running Checks`:

```text
sudo stackstate-agent status
```

### Upgrade

When a new version of the Dynatrace StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **Dynatrace**. For a quick overview of recent StackPack updates, check the [StackPack versions](../../setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

For considerations and instructions on upgrading a StackPack, see [how to upgrade a StackPack](../about-stackpacks.md#upgrade-a-stackpack).

## Integration details

### REST API endpoints

The API endpoints used in the StackState integration are listed below:

* `/api/v1/entity/applications`
* `/api/v1/entity/infrastructure/hosts`
* `/api/v1/entity/infrastructure/processes`
* `/api/v1/entity/infrastructure/process-groups`
* `/api/v1/entity/services`
* `/api/v1/events`
* `/api/v2/entities`


{% hint style="info" %}
Refer to the Dynatrace documentation for details on [how to create an API Token](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token).
{% endhint %}

### Data retrieved

#### Events

The [Dynatrace health check](#dynatrace-health-check) retrieves all events and their parameters from Dynatrace for the configured `relative time` (default 1 hour).

| Dynatrace event severity | Available in StackState as |
| :--- | :--- |
| `INFO` | Events are mapped to the associated component. They are listed on the StackState events perspective and in the Component Details pane. |
| `PERFORMANCE`, `RESOURCE_CONTENTION`, `MONITORING_UNAVAILABLE`, `ERROR` | Events are added to a StackState health stream. These event severities will result in a DEVIATING state on the associated component. |
| `AVAILABILITY`, `CUSTOM_ALERT` | Events are added to a StackState health stream. These event severities will result in a CRITICAL state on the associated component. |


#### Metrics

The Dynatrace integration does not retrieve any metrics data.

#### Tags

All tags defined in Dynatrace will be retrieved and added to the associated components and relations in StackState. 

The Dynatrace integration also understands StackState [common tags](../../configure/topology/tagging.md#common-tags). These StackState tags can be assigned to elements in Dynatrace to influence the way that the resulting topology is built in StackState. For example, by placing a component in a specific layer or domain.

#### Topology

The [Dynatrace topology check](#dynatrace-topology-check) retrieves the following topology data from Dynatrace:

| Data | Description |
| :--- | :--- |
| Components | Smartscape Applications, Hosts, Processes, Process-Groups, Services and Custom Devices. |
| Relations | Relations between the imported components are included in the component data retrieved from Dynatrace. |

{% hint style="info" %}
The Dynatrace integration understands StackState [common tags](../../configure/topology/tagging.md#common-tags). These StackState tags can be assigned to elements in Dynatrace to influence the way that the resulting topology is built in StackState. For example, by placing a component in a specific layer or domain.
{% endhint %}

#### Traces

The Dynatrace integration does not retrieve any traces data.

### Dynatrace filters for StackState views

When the Dynatrace integration is enabled, the following additional keys can be used to filter views in the StackState UI:

* dynatrace-ManagementZones
* dynatrace-EntityID
* dynatrace-Tags
* dynatrace-MonitoringState

For example, to filter a view by Dynatrace Management Zone, add the key `dynatrace-managementZones:<value>` to the **Labels** filter box.

![Use a Dynatrace topology filter](../../.gitbook/assets/v45_dynatrace-filter.png)

### Open source

The code for the Dynatrace checks are open source and available on GitHub: 

- **Topology check:** [https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology](https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology)
- **Health check:** [https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_health](https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_health)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=Dynatrace).

## Uninstall

To uninstall the Dynatrace StackPack and disable the Dynatrace checks:

1. Go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **Dynatrace** screen and click **UNINSTALL**.
   * All Dynatrace specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv dynatrace_topology.d/conf.yaml dynatrace_topology.d/conf.yaml.bak
    mv dynatrace_health.d/conf.yaml dynatrace_health.d/conf.yaml.bak
   ```

3. [Restart the StackState Agent\(s\)](../../setup/agent/about-stackstate-agent.md#deploy-and-run-stackstate-agent-v2) to apply the configuration changes.

## Release notes

**Dynatrace StackPack v1.3.0 \(2021-10-12\)**

* Features: Support of Agent 2.15 release that sends Health State snapshots with new Dynatrace topology and health checks. 

**Dynatrace StackPack 1.2.0 (2021-09-02)**

* Features: Introduced a new component type named Custom-Device 

**Dynatrace StackPack v1.1.2 \(2021-06-24\)**

* Improvement: Changed which events send DEVIATING health state

**Dynatrace StackPack v1.1.1 \(2021-04-12\)**

* Improvement: Common bumped from 2.5.0 to 2.5.1

**Dynatrace StackPack v1.1.1 \(2021-04-02\)**

* Feature: Gather Events from your Dynatrace instance and provides Health info about Dynatrace components.
* Feature: Support for Dynatrace tags.
* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.2.3 to 2.5.1
* Improvement: StackState min version bumped to 4.3.0

**Dynatrace StackPack v1.0.0**

* Feature: Gathers Topology from your Dynatrace instance and allows visualization of your Dynatrace components and the relations between them.

## See also

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md)
* StackState Agent integrations:
  - [Topology check/(github.com/)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_topology)
  - [Health check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/dynatrace_health)
* [How to generate a Dynatrace API token \(dynatrace.com\)](https://www.dynatrace.com/support/help/shortlink/api-authentication#generate-a-token)
* [Permissions for Dynatrace API tokens \(dynatrace.com\)](https://www.dynatrace.com/support/help/shortlink/api-authentication#token-permissions)

