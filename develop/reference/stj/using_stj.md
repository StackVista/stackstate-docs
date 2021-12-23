---
description: StackState Self-hosted v4.5.x
---

{% hint style="info" %}
These are the docs for the StackState Self-hosted product. [Go to the StackState SaaS docs site](https://docs.stackstate.com/v/stackstate-saas/).
{% endhint %}

# Using STJ

## Overview

StackState's graph is entirely configured using JSON. To make it easy to work with large quantities of \(often repetitive\) JSON, StackState comes with the StackState Template JSON format \(STJ\).

STJ is based on [handlebars \(handlebarsjs.com\)](https://handlebarsjs.com/) and comes with a number of [StackState functions](stj_reference.md).

## Handlebars syntax

StackState template files use handlebars. Content that is placed between double curly brackets `{{ some content }}` is included in the output. The example below shows handlebars used in a component template:

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

## StackState Functions

StackState adds a number of function to the handlebars syntax. You can use these to create complex JSON results.

 [Learn more about the available functions](stj_reference.md).

## Component and relation templates

Templates are used to create topology. 

[Learn more about component and relation templates](/use/concepts/components_relations.md).

## See also

* [StackState Template Language Functions](stj_reference.md)

