---
description: StackState Self-hosted v5.1.x 
---

# Static Topology

## Overview

The Static Topology StackPack reads topology information from an [external CSV file](#csv-file-specification) and synchronizes the data with StackState.

Static Topology is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Setup

### Prerequisites

To set up the StackState Static Topology integration, you need to have:

* A correctly formatted [component CSV file](#component-csv-file) and [relation CSV file](#relation-csv-file).
* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) installed on a machine that can connect to StackState.

### Install

Install the Static Topology StackPack from the StackState UI **StackPacks** > **Integrations** screen. You will need to enter the following details:

* **Path to component CSV file** - the CSV file to read component data from.
* **Path to relation CSV file** - the CSV file to read relation data from.

The CSV files should follow the [Static Topology CSV file specification](#csv-file-specification) and be available in a location where StackState Agent is able to read them, for example `/etc/stackstate-agent/conf.d/`. StackState Agent V2 runs as system user/group `stackstate-agent`.

### Configure

To enable the Static Topology check and begin collecting topology data from the configured CSV files, add the following configuration to StackState Agent V2:

{% hint style="info" %}
Example Agent configuration file for Static Topology: [conf.yaml.example \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/static_topology/stackstate_checks/static_topology/data/conf.yaml.example)
{% endhint %}

1. Copy the example Agent configuration file `mv /etc/stackstate-agent/conf.d/static_topology.d/conf.yaml.example /etc/stackstate-agent/conf.d/static_topology.d/conf.yaml`.
2. Edit the copied Agent configuration file `/etc/stackstate-agent/conf.d/static_topology.d/conf.yaml` to add details of the CSV files:
    * **type** - Set to `csv` for parsing CSV files.
    * **components_file** - Path to the [component CSV file](#component-csv-file) to read component data from. The same as entered when the StackPack was installed.
    * **relations_file** - Path to the [relation CSV file](#relation-csv-file) to read relation data from. The same as entered when the StackPack was installed.
    * **delimiter** - The delimiter used in the CSV files.
    ```yaml
    init_config:
    
    instances:
      - type: csv
        components_file: /path/to/components.csv
        relations_file: /path/to/relations.csv
        delimiter: ','
     
        #tags:
        #  - optional_tag1
        #  - optional_tag2
    ```    

3. You can also add optional configuration:
    * **tags** - Tags to add to the imported topology elements.
4. Verify that the files could be read successfully using the command:
```yaml
agent check static_topology
```
5.[Restart the StackState Agent\(s\)](/setup/agent/about-stackstate-agent.md#deployment) to apply the configuration changes.
6.Once the Agent has restarted, wait for the Agent to collect data from the CSV files and send it to StackState.   

### Status

Execute the info command and verify that the integration check has passed. The output of the command should contain a section similar to the following:

```
Checks
[...]

static_topology
* instance #0 [OK]
```

## CSV file specification

Static topology is read from two CSV files:

1. A CSV file containing components
2. A CSV file containing relations

Both CSV files are read to form a topology. The CSV file for components and relations have different requirements, these are described on this page. Both files require a CSV header.

### Component CSV file

The component CSV file has details of components. The file should contain a header with the following fields:

* `id` - The component's unique identifier.
* `name` - The component's name.
* `type` - The component type. For example, VM, datastore or rack.
* `domain` \(Optional\) - The StackState domain where the component should be visualized.
* `layer` \(Optional\) - The StackState layer in where the component should be visualized.
* `environment` \(Optional\) - The StackState environment in where the component should be visualized.
* All other fields will be added as metadata on the component

{% hint style="info" %}
Headers are case-sensitive.
{% endhint %}

{% tabs %}
{% tab title="Example component CSV file" %}
```text
id,name,type,layer,domain,environment
1,component1,vm,machines,mydomain,myenvironment
2,component2,vm,machines,mydomain,myenvironment
```
{% endtab %}
{% endtabs %}

### Relation CSV file

The relation CSV file has details of relations between components. The file should contain a header with the following fields:

* `sourceid` - The identifier of the component to create a relation from. This must match the component `id` in the component CSV file.
* `targetid` - The identifier of the component to create a relation to. This must identifier has to match the component `id` in the component CSV file.
* `type` - The type of a relation. For example, 'uses' or 'depends on'.

{% hint style="info" %}
Headers are case-sensitive.
{% endhint %}

{% tabs %}
{% tab title="Example relation CSV file" %}
```text
sourceid,targetid,type
1,2,uses
```
{% endtab %}
{% endtabs %}

## Release notes

**StaticTopology StackPack v2.3.2 \(2021-05-12\)**

* Bugfix: Use the domain, layer, environment and type coming from data in component template

