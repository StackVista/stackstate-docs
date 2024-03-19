---
description: StackState Self-hosted v5.1.x 
---

# Static Health

## Overview

The Static Health integration is used to visualize static health information in StackState by reading from CSV files. The health consists of check states.

Static Health is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Setup

### Prerequisites

To set up the Static Health integration you will need to have:

* StackState [](../../setup/agent/about-stackstate-agent.md) installed on a machine that can connect to StackState.

### Configure

To configure StackState  to read CSV health files:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/static_health.d/conf.yaml` to include the following details:
   * **type** - set to `csv` for parsing CSV typed files.
   * **health\_file** - the absolute path to the CSV file containing health state information.
   * **delimiter** - the delimiter used in the CSV file.

     ```text
     init_config:

     instances:
     - type: csv
      health_file: /path/to/health.csv
      delimiter: ';'
     ```
2. [Restart StackState ](../../setup/agent/about-stackstate-agent.md#deployment) to apply the configuration changes.
3. Once the Agent has restarted, wait for the Agent to collect data from the specified [health CSV file](static_health.md#csv-file-format) and send it to StackState.

{% hint style="info" %}
The configured `collection_interval` will be used as the [`repeat_interval` for the health synchronization](../../../configure/health/health-synchronization.md#repeat-interval). Make sure that the value set for the `collection_interval` matches the time that the check will take to run.
{% endhint %}

## CSV file format

### Fields

Static health is read from a CSV file with a header row, that specifies the fields that are included in the file. The available fields are listed in the table below.

| Field name | Mandatory | Description                                                                     |
| :--- | :--- |:--------------------------------------------------------------------------------|
| **check\_state\_id** | yes | Identification for the check state within the health stream.                   |
| **name** | yes | The display name of the check state.                                           |
| **health** | yes | The health state of the check state. Can be `CLEAR`, `DEVIATING` or `CRITICAL`. |
| **topology\_element\_identifier** | yes | Identifier of the component or relation the check state will be attached to.   |
| **message** | no | Additional descriptive message of the check state.                             |

{% tabs %}
{% tab title="Example health CSV file" %}
```text
check_state_id,name,health,topology_element_identifier,message
check_1,Example check,critical,urn:component/some_component,Something went wrong
check_2,Another example check,clear,urn:component/some_component,This is going well
```
{% endtab %}
{% endtabs %}

### Delimiter

The delimiter used in the CSV file can be specified when you [configure the Static Health check](static_health.md#configure) on StackState Agent V3.

## See also

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md)
* [Health state in StackState](../../use/concepts/health-state.md)
* [Health Synchronization](../../configure/health/health-synchronization.md)
* [Debug Health Synchronization](../../configure/health/debug-health-sync.md)

