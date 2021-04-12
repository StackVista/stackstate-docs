---
title: Component and Relation templates
kind: Documentation
---

# Templates

{% hint style="warning" %}
This page describes StackState version 4.x.  
The StackState 4.0 version range is End of Life (EOL) and no longer supported.

We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Templates are functions defined by JSON template files and input parameters required by the template to render elements of StackState topology - components and relations. When executed, the template function substitutes all handlebar `{{paramName}}` parameter references with values of input parameters.

Template functions are used in cooperation with Mapping Functions to create StackState topology elements. Mapping Function parses the topological data of an external system and prepares input parameters for the Template Functions.

## Component template function

Component's Template Function must define the following parameters: `name`, `description`, `componentTypeId`, `layerId`, `domainId`, `environmentId`.

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

## Relation template function

Relation Template Function creates a relation between `{{sourceId}}` and `{{targetId}}`. Template function must define the following parameters: `name`, `description`, `relationTypeId`, `sourceId`, `targetId`.

```text
[{
  "_type": "Relation",
  "checks": [],
  "streams": [],
  "labels": [],
  "name": "{{ name }}",
  "description": "{{ description }}",
  "type" : {{ relationTypeId }},
  "source": {{ element.sourceId }},
  "target": {{ element.targetId }},
}]
```

