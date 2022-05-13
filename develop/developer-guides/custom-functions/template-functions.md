---
description: StackState Self-hosted v4.6.x
---

# Template functions

## Overview

Template functions are defined by a JSON template and input parameters required by the template to render elements of StackState topology - mainly components or relations. When executed template functions substitutes all handlebar parameter references with values of input parameters. Template functions must define all parameters that template body refers to.

Template functions are used in cooperation with Mapping functions to create StackState topology elements. Mapper function parse topological data of external system and prepares input parameters for Template function.

## Create template functions from existing components and relations

An easy way to create template functions is to create them based on existing component or relation. This option is available as **+ Add as template** in the context menu or from the right panel details tab when detailed information about an element is displayed. After adding component or relation as template, its template function will appear in the Templates list in the Templates panel.

## Manually create a template function

Below are some examples templates to create components. Note that a template is not limited to rendering only components and relations. It can render JSON for any StackState domain object that is supported by restapi, for example a Domain, Layer, Check or Stream. and also not only single object, but several multiple objects with one template.

* A simple template that creates a component. Its template function must define the parameters with the following names: `name`, `description`, `componentTypeId`, `layerId`, `domainId` and `environmentId`.

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

* A template to create a relation between the components `{{ sourceId }}` and `{{ targetId }}`. Its template Function must define parameters with the following names: `name`, `description`, `relationTypeId`, `sourceId` and `targetId`.

  ```text
         [{
           "_type": "Relation",
           "checks": [],
           "streams": [],
           "labels": [],
           "name": "{{ name }}",
           "description": "{{ description }}",
           "type": {{ relationTypeId }},
           "source": {{ sourceId }},
           "target": {{ targetId }}
         }]
  ```