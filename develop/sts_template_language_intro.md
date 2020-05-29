---
title: Introduction to StackState Template Language
kind: documentation
---

# sts\_template\_language\_intro

Templates are used to convert raw synchronization data to components. Templates are defined in JSON extended with support for parameters, loops and conditions.

## Handlebars in STL

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

Please find more information on the [Component and Relation templates page.](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/concepts/component_and_relation_templates/README.md)

