---
description: StackState Self-hosted v5.1.x 
---

# Using Templated STJ and STY

## Overview

StackState's [synchronization framework](/configure/topology/sync.md#template-functions "StackState Self-Hosted only") is configured using JSON. [stackpacks](/develop/developer-guides/stackpack/develop_stackpacks.md "StackState Self-Hosted only"), [monitors](/develop/developer-guides/monitors/create-custom-monitors.md "StackState Self-Hosted only") and [backup/restore](/setup/data-management/backup_restore/ "StackState Self-Hosted only") use YAML. To make it easy to work with large quantities of \(often repetitive\) JSON or YAML, StackState comes with the StackState Template JSON and YAML format (STJ/STY).

The templating is based on [handlebars \(handlebarsjs.com\)](https://handlebarsjs.com/) and comes with a number of [StackState functions](st_reference.md).

## Handlebars syntax

StackState template files use handlebars. Content that is placed between double curly brackets `{{ some content }}` is included in the output. The example below shows handlebars used in a component template:

{% code lineNumbers="true" %}
```text
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

## Component and relation templates

STJ Templates are used to create topology. 

➡️ [Learn more about component and relation templates](/configure/topology/sync.md#template-functions "StackState Self-Hosted only")

## StackPacks and import/export

STJ Templates are used to create topology.

➡️ [Learn more about creating stackpacks](/configure/topology/sync.md#template-functions "StackState Self-Hosted only")


## See also

* [StackState Template Language Functions](st_reference.md)

