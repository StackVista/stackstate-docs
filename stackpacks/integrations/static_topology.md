---
description: StackState curated integration
---

# Static Topology

{% hint style="warning" %}
**This page describes StackState version 4.4.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

### What is the Static Topology StackPack?

The Static Topology StackPack reads topology information from an external CSV file and synchronizes the data with StackState.

### Configuration

Static topology is read from two CSV files:

1. A CSV file containing components
2. A CSV file containing relations

Both CSV files are read to form a topology. The component and relation CSV files require a CSV header. The header specification is as follows:

#### Component file specification

* `id` - The component's unique identifier
* `name` - The component's name
* `type` - The type of a component, e.g. VM, datastore, rack, etc.
* `domain` \(Optional\) - The StackState domain where the component should be visualized
* `layer` \(Optional\) - The StackState layer in where the component should be visualized
* `environment` \(Optional\) - The StackState environment in where the component should be visualized
* All other fields are added as meta data on the component

Note: the fields are expected to be in lowercase letters.

#### Relation file specification

* `sourceid` - The component's identifier that is used to create a relation from. The identifier has to match the component's `id` in the component CSV.
* `targetid` - The component's identifier that is used to create a relation to. The identifier has to match the component's `id` in the component CSV.
* `type` - The type of a relation, e.g. uses, 'depends on'

Note: the fields are expected to be in lowercase letters.

### Example CSV files

Component csv:

```text
id,name,type,layer,domain,environment
1,component1,vm,machines,mydomain,myenvironment
2,component2,vm,machines,mydomain,myenvironment
```

Relation csv:

```text
sourceid,targetid,type
1,2,uses
```

### Setup

#### Configuration

1. Configure the Agent to read CSV topology files. Edit `conf.d/static_topology.d/conf.yaml`:

   **Static topology from file**

   init\_config:

instances:

* type: csv components\_file: /path/to/components.csv relations\_file: /path/to/relations.csv delimiter: ';'

  **tags:**

  **- optional\_tag1**

  **- optional\_tag2**

* Restart the Agent

#### Configuration Options

* `type` - Set to `csv` for parsing CSV typed files
* `components_file` - Absolute path to CSV file containing topology components
* `relations_file` - Absolute path to CSV file containing topology relations
* `delimiter` - CSV field delimiter
* `tags` \(Optional\) - StackState labels to add to each component and relation read from the CSV files.

#### Validation

Execute the info command and verify that the integration check has passed. The output of the command should contain a section similar to the following:

## Checks

\[...\]

### static\_topology

* instance \#0 \[OK\]

## Release notes

**StaticTopology StackPack v2.3.2 \(2021-05-12\)**

* Bugfix: Use the domain, layer, environment and type coming from data in component template

**StaticTopology StackPack v2.3.1 \(2021-04-12\)**

* Improvement: Common bumped from 2.5.0 to 2.5.1

**StaticTopology StackPack v2.3.0 \(2021-04-02\)**

* Improvement: Enable auto grouping on generated views.
* Improvement: Common bumped from 2.2.3 to 2.5.0
* Improvement: StackState min version bumped to 4.3.0

**StaticTopology StackPack v2.2.1 \(2020-08-18\)**

* Feature: Introduced the Release notes pop up for customer

**StaticTopology StackPack v2.2.0 \(2020-08-04\)**

* Improvement: Deprecated StackPack specific layers and introduced a new common layer structure.
* Improvement: Replace resolveOrCreate with getOrCreate.

**StaticTopology StackPack v2.1.0 \(2020-04-23\)**

* Improvement: Upgrade the requirement and documentation of Static Topology to use AgentV2.

