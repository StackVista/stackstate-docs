---
title: Introduction to StackState Template Language
kind: documentation
description: All configuration of StackState is described using StackState Templated Json.
---

# StackState Template Json \(STJ\)

Templates are used to convert raw synchronization data to components. Templates are defined in JSON extended with support for parameters, loops and conditions.

## Handlebars syntax

StackState template files are using handlebars - a content that is placed between double curly brackets `{{ some content }}`. Below example shows a few handlebars used by a component template:

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

StackState extends on that concept and allows to include different types of content within handlebars inside `.stj` files:

* you can include a script \(Groovy\): `{{ include "path/to/script.groovy" }}`
* you can include an icon: `{{ include "path/to/icon.png" "base64" }}`
* you can include a template: `{{ include "path/to/template.handlebars" }}`

## Component and Relation templates

Please find more information on the [Component and Relation templates page.](/concepts/components_and_relations.md)

