---
description: StackState Self-hosted v5.1.x 
---

# Using Templated STJ and STY

## Overview

StackState makes use of StackState Templated JSON (STJ) and StackState Templated YAML (STY) for configuration.

The templating is based on [handlebars \(handlebarsjs.com\)](https://handlebarsjs.com/) and comes with a number of [StackState functions](st_reference.md).

This table described which variant is used where:

| Functionality                                                           | STJ | STY |
|:------------------------------------------------------------------------|:---:|:---:|
| [Synchronization framework](/configure/topology/sync.md#template-functions "StackState Self-Hosted only") |  ✅  |  -  |
| [StackPacks](/develop/developer-guides/stackpack/develop_stackpacks.md "StackState Self-Hosted only")     |  -  |  ✅  |
| [Monitors](/develop/developer-guides/monitors/create-custom-monitors.md "StackState Self-Hosted only")    |  -  |  ✅  |
| [Backup/restore](/setup/data-management/backup_restore/ "StackState Self-Hosted only")                    |  -  |  ✅  |

## Handlebars syntax

StackState template files use handlebars. Content that is placed between double curly brackets `{{ some content }}` is included in the output. The example below shows handlebars used in a component template:

{% tabs %}
{% tab title="STJ" %}

This is a component described in JSON

{% code lineNumbers="true" %}
```json
[{
  "_type": "Component",
  "checks": [],
  "streams": [],
  "labels": [],
  "name": "{{ name }}",
  "description": "{{ description }}",
  "type" : {{ componentTypeId }},
  "layer": {{ layerId }},
  "domain": {{ domainId }},
  "environments": [{{ environmentId }}]
}]
```
{% endcode %}

{% endtab %}
{% tab title="STY" %}

This is a monitor described in YAML

{% code lineNumbers="true" %}
```yaml
_version: 1.0.39
timestamp: 2022-05-23T13:16:27.369269Z[GMT]
nodes:
- _type: Monitor
  name: CPU Usage
  description: A simple CPU-usage monitor. If the metric is above a given threshold, the state is set to CRITICAL.
  identifier: urn:system:default:monitor:cpu-usage
  remediationHint: Turn it off and on again.
  function: {{ get "urn:system:default:monitor-function:metric-above-threshold" }}
  arguments:
  threshold: 90.0
  topolopgyIdentifierPattern: "urn:host:/${tags.host}"
  metrics: |-
  Telemetry
  .query("StackState Metrics", "")
  .metricField("system.cpu.system")
  .groupBy("tags.host")
  .start("-1m")
  .aggregation("mean", "15s")
  intervalSeconds: 60
```
{% endcode %}

{% endtab %}
{% endtabs %}


### Conditionals: \#if / else

Run some template code conditionally if a variable has a value.

{% tabs %}
{% tab title="Template" %}
```text
{{# if description }}
"description": "{{ description }}",
{{else}}
"description": "noop",
{{/ if }}
```
{% endtab %}

{% tab title="Data" %}
```text
[ description: "hello world" ]
```
{% endtab %}

{% tab title="Result" %}
```text
"description": "hello world"
```
{% endtab %}
{% endtabs %}

### Looping: \#each

Loop over an array or map of data.

{% tabs %}
{% tab title="Template" %}
```text
[
  {{# each names }}
  "hello {{this}}",
  {{/ each }}
  "bye y'all!"
]
```
{% endtab %}

{% tab title="Data" %}
```text
[ names: [ "stackstate", "handlebars" ]]
```
{% endtab %}

{% tab title="Result" %}
```text
[
  "hello stackstate",
  "hello handlebars",
  "bye y'all!"
]
```
{% endtab %}
{% endtabs %}

## StackState handlebars functions

StackState adds a number of function to the handlebars syntax. You can use these to create complex JSON results.

➡️ [Learn more about the available handlebars functions](st_reference.md).

## See also

* [StackState Template Language Functions](st_reference.md)
* [Synchronization Framework](/configure/topology/sync.md#template-functions "StackState Self-Hosted only")
* [StackPacks](/develop/developer-guides/stackpack/develop_stackpacks.md "StackState Self-Hosted only")
* [Monitors](/develop/developer-guides/monitors/create-custom-monitors.md)
* [Backup/Restore](/setup/data-management/backup_restore/ "StackState Self-Hosted only")
