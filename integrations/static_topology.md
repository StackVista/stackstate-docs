---
title: Static Topology StackPack
kind: documentation
---

## What is the Static Topology StackPack?

The Static Topology StackPack reads topology information from an external CSV file and synchronizes the data with StackState.

## Configuration

Static topology is read from two CSV files:

1. A CSV file containing components
2. A CSV file containing relations

Both CSV files are read to form a topology. The component and relation CSV files require a CSV header. The header specification is as follows:

### Component file specification

* `id` - The component's unique identifier
* `name` - The component's name
* `type` - The type of a component, e.g. VM, datastore, rack, etc.
* `domain` (Optional) - The StackState domain where the component should be visualized
* `layer` (Optional) - The StackState layer in where the component should be visualized
* `environment` (Optional) - The StackState environment in where the component should be visualized
* All other fields are added as meta data on the component

Note: the fields are expected to be in lowercase letters.

### Relation file specification

* `sourceid` - The component's identifier that is used to create a relation from. The identifier has to match the component's `id` in the component CSV.
* `targetid` - The component's identifier that is used to create a relation to. The identifier has to match the component's `id` in the component CSV.
* `type` - The type of a relation, e.g. uses, 'depends on'

Note: the fields are expected to be in lowercase letters.

## Example CSV files

Component csv:
```
id,name,type,layer,domain,environment
1,component1,vm,machines,mydomain,myenvironment
2,component2,vm,machines,mydomain,myenvironment
```

Relation csv:
```
sourceid,targetid,type
1,2,uses
```

## Setup

### Configuration

1.  Configure the Agent to read CSV topology files. Edit `conf.d/static_topology.yaml`:
{{< highlight yaml>}}
# Static topology from file
init_config:

instances:
  - type: csv
    components_file: /path/to/components.csv
    relations_file: /path/to/relations.csv
    delimiter: ';'

    #tags:
    #  - optional_tag1
    #  - optional_tag2

{{< /highlight >}}

2.  Restart the Agent

### Configuration Options

* `type` - Set to `csv` for parsing CSV typed files
* `components_file` - Absolute path to CSV file containing topology components
* `relations_file` - Absolute path to CSV file containing topology relations
* `delimiter` - CSV field delimiter
* `tags` (Optional) - StackState labels to add to each component and relation read from the CSV files.

{{< insert-example-links conf="static_topology" check="static_topology" >}}


### Validation

Execute the info command and verify that the integration check has passed. The output of the command should contain a section similar to the following:
{{< highlight shell>}}
Checks
======

  [...]

  static_topology
  -------
      - instance #0 [OK]
{{< /highlight >}}
