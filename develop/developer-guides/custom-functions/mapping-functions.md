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
   * **Parameters** - Mapping functions work with one system parameter `element`. This is used to process the component or relation JSON payload. It is not possible to add additional user parameters.
   * **Script** - Defines the logic of the mapper function using the Groovy scripting language.
   * **Identifier** - Optional. Specifies the URN identifier for the mapping function. This should be set if you intend to include the mapping function in a StackPack.
4. Click **CREATE** to save the mapping function.
   * The mapping function will be listed on the settings page (**Component Mapping Functions** or **Relation Mapping Functions**).
   * The mapping function is available for use in [topology synchronization](/configure/topology/sync.md).

![Mapper function](../../../.gitbook/assets/mapping_function.png)

## Examples

### Simple - add a fixed label

This example shows a simple component mapping function - the **Fixed label mapping function** - that adds a fixed label to the component’s data payload. This mapping function could also be replaced by adding the appropriate label block directly in the component template that is used.

1. [The mapping function script](#script)
2. [Add the mappnig function to topology synchronization](#topology-synchronization)
3. [The resulting component](#component)

#### Script 

The script checks if the data payload already contains a key named `labels`, as shown on line 1. If the `labels` key is not present, then the value is initialized to an empty list to ensure that the value is going to be a list. If the `labels` key does exist, the assumption is made that the value is a list.

Line 5 appends the label `label-added-by-mapper-function` to the list of labels. The updated `element` variable is returned by the mapping function on line 7. 

```commandline
if (!element.data.containsKey("labels")) {
   element.data.labels = []
}

element.data.labels << "label-added-by-mapper-function"

return element
```

#### Topology synchronization

Mapping functions are specified in step 3/5 of a topology synchronization. Here, the **Fixed label** mapping function is added to the **Other sources** mapping. In essence, every component processed by this topology synchronization will receive the label. A generic component template is used that converts the `data.labels` payload to a StackState label.

![Topology synchronization](/.gitbook/assets/v51_simple_mapping_synchronization.png)

#### Component

The resulting component is shown here.

![Component with label](/.gitbook/assets/v51_simple_mapping_result.png)

* **Component JSON** - The component JSON object that was sent to the StackState receiver as part of a larger JSON payload is shown on the left. The JSON defines a component with name **Application1**. The JSON payload is processed by the topology synchronization on which the mapper function was configured.
* **Mapping function** - A part of the mapping function is shown at the bottom to show the value of the label.
* **Component template** - A part of the component template is shown in the center. In the component template, the `labels` payload is processed using the `join` helper, as shown on line 30. This iterates through each string in the label list and outputs the JSON block on lines 31 until 34. The `this` variable inside the `join` helper on line 33 is used access the current value in the iteration. In this example, there is only one label to be processed. This is because there is no `labels` key in the original JSON and the mapping function adds the only one. Lines 37 until 40 also define a fixed label. The label defined there will have the value `demo:demo`. This shows that, in this example, the mapping function could also be replaced by adding the appropriate label block directly in the component template.
* **Component details** - On the right is the Component Details tab of the **Application1** component after the JSON payload has been  processed by topology synchronization. 
The **Application1** component has two labels:
  * The `demo:demo` label that was added by the component template. 
  * The `label-added-by-mapper-function` that was added by the mapping function .

## See also

* [Topology synchronization](/configure/topology/sync.md)
