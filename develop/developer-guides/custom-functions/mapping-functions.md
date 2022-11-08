---
description: StackState Self-hosted v5.1.x 
---

# Mapping functions

## Overview

Mapping functions can optionally be used in topology synchronization to transform data. The goal of a mapping function is to process topology data from an external system and prepare parameters for use by a template function. There are two types of mapping functions:

* **Component mapping functions** - used in the synchronization of components.
* **Relation mapping functions** - used in the synchronization of relations.

## Create a custom mapping function

To add a custom component or relation mapping function: 

1. In the StackState UI go to the settings page for the type of mapping function you would like to add:
   * For component mapping functions, go to: **Settings** > **Topology Synchronization** > **Component Mapping Functions**
   * For relation mapping functions, go to: **Settings** > **Topology Synchronization** > **Relation Mapping Functions**
2. Click **ADD COMPONENT MAPPING FUNCTION** or **ADD RELATION MAPPING FUNCTION**.
3. Enter the required settings:
   * **Name** - The name of the mapper function is shown on the settings page and in the topology synchronization that uses it. 
   * **Description** - Optional. Describes the mapper function in further detail. Will be shown on the mapper function settings page.
   * **Script** - Defines the logic of the mapper function using the Groovy scripting language.
   * **Identifier** - Optional. Specifies the URN identifier for the mapping function. This should be set if you intend to include the mapping function in a StackPack.
4. Click **CREATE** to save the mapping function.
   * The mapping function will be listed on the settings page (**Component Mapping Functions** or **Relation Mapping Functions**).
   * The mapping function is available for use in [topology synchronization](/configure/topology/sync.md).

![Mapper function](../../../.gitbook/assets/mapping_function.png)

## Parameters

Mapping functions work with one system parameter `element`. This is used to process the component or relation JSON payload. It is not possible to add additional user parameters.


## Example

### Simple component mapping function

Here is an example of a simple component mapping function that adds a fixed label to the component’s data payload. This mapping function could also be replaced by adding the appropriate label block directly in the component template that is used. The example assumes that the `labels` data payload will be processed and converted into a StackState label. 
The script checks if the data payload already contains a key named `labels`, as shown on line 1. If the `labels` key is not present, then the value is initialized to an empty list to ensure that the value is going to be a list. If the `labels` key does exist, the assumption is made that the value is a list.

Line 5 appends the label `label-added-by-mapper-function` to the list of labels. The updated `element` variable is returned by the mapping function on line 7. 

```commandline
if (!element.data.containsKey("labels")) {
   element.data.labels = []
}

element.data.labels << "label-added-by-mapper-function"

return element
```

![Simple component mapping function](/.gitbook/assets/v51_simple_mapping_function_example.png)



-------


Mapper Functions are defined by a groovy script and input parameters that groovy script requires. The goal of a Mapper Function is to process topology data from an external system and prepare parameters for use by a template function.

Mapping functions can be created from the **Settings** page in the StackState UI.

![Mapper function](../../../.gitbook/assets/mapping_function.png)

There are two specific Mapper Function parameters:

* `ExtTopoComponent` / `ExtTopoRelation` - these are the required system parameters. Every Mapper Function must define one of these. They are used internally by StackState and cannot be changed using the API. They indicate the type of element - component or relation - that the Mapper Function supports.
* `TemplateLambda` - this is an optional parameter that specifies which template functions must be used with the Mapper Function.

An example of a simple Mapper Function:

```text
def params = [
    'name': element.getExternalId(),
    'description': element.getData().getString("description").get()
];

context.runTemplate(template, params)
```

