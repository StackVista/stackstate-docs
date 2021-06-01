---
description: StackState curated integration
---

# Static Health

### What is the Static Health Integration?

Visualize static health information in StackState by reading from CSV files. The health consists of check states.

### Configuration


Static health is read from a CSV file with a header, that specifies which fields are used:


| Header | Mandatory | Description |
| ------ | --------- |: ----------- |
| **check_state_id** | yes |  Identification for the check state within the health stream |
| **name** | yes | The display name of the check state |
| **health** | yes | The health state of the check state. Can be clear, deviating or critical |
| **topology_element_identifier** | yes | Identifier of the component or relation the check state will be attached to  |
| **message** | no | Additional descriptive message of the check state |

Example:

```
check_state_id,name,health,topology_element_identifier,message
example_check_1,Example check,critical,urn:component/some_component,Something went wrong
example_check_2,Another example check,clear,urn:component/some_component,This is going well
```

### Setup

#### Configuration

Configure the Agent to read CSV topology files. Edit `conf.d/static_health.yaml`:

```text
init_config:

instances:
  - type: csv
    health_file: /path/to/health.csv
    delimiter: ';'
```

* Restart the Agent

#### Configuration Options

* `type` - Set to `csv` for parsing CSV typed files
* `health_file` - Absolute path to CSV file containing health state
* `delimiter` - CSV field delimiter

#### Validation

Execute the info command and verify that the integration check has passed. The output of the command should contain a section similar to the following:

## Checks

\[...\]

### static\_health

* instance \#0 \[OK\]

