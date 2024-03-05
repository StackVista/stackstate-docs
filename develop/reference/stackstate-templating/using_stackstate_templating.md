---
description: StackState SaaS
---

# Using Templated STJ and STY

## Overview

StackState makes use of StackState Templated JSON (STJ) and StackState Templated YAML (STY) for configuration.

The templating is based on [handlebars \(handlebarsjs.com\)](https://handlebarsjs.com/) and comes with a number of [StackState functions](template_functions.md).

This table described which variant is used where:

| Functionality                                                                                                      | STJ | STY |
|:-------------------------------------------------------------------------------------------------------------------|:---:|:---:|
| [Monitor definitions](/develop/developer-guides/monitors/create-custom-monitors.md)                                |  -  |  ✅  |

## Handlebars syntax

In handlebars, content that is placed between double curly brackets `{{ some content }}` will be replaced in the output. The example below shows handlebars used in an STJ component template and an STY monitor definition:

{% tabs %}
{% tab title="STJ" %}

This is a component described in STJ

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

This is a monitor described in STY

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
    topolopgyIdentifierPattern: "urn:host:/${sts_host}"
    metrics: |-
      Telemetry
        .promql("avg by (sts_host) (system.cpu.system[15s])")
        .start("-1m")
        .step("15s")
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

➡️ [Learn more about the available handlebars functions](template_functions.md).

## See also

* [StackState template functions](template_functions.md)
* [Create custom monitors](/develop/developer-guides/monitors/create-custom-monitors.md)
