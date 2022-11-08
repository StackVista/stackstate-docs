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
2. [Add the mapping function to topology synchronization](#topology-synchronization)
3. [The resulting component](#component)

#### Script 

The script checks if the data payload already contains a key named `labels`, as shown on line 1. If the `labels` key is not present, then the value is initialized to an empty list to ensure that the value is going to be a list. If the `labels` key does exist, the assumption is made that the value is a list.

Line 5 appends the label `label-added-by-mapper-function` to the list of labels. The updated `element` variable is returned by the mapping function on line 7. 

{% code lineNumbers="true" %}
```commandline
if (!element.data.containsKey("labels")) {
   element.data.labels = []
}

element.data.labels << "label-added-by-mapper-function"

return element
```
{% endcode %}

#### Topology synchronization

Mapping functions are specified in step 3/5 of a topology synchronization. Here, the **Fixed label** mapping function is added to the **Other sources** mapping. In essence, every component processed by this topology synchronization will receive the label. A generic component template is used that converts the `data.labels` payload to a StackState label.

![Topology synchronization](/.gitbook/assets/v51_simple_mapping_synchronization.png)

#### Component

The process and resulting component is shown here.

![Component with label](/.gitbook/assets/v51_simple_mapping_result.png)

1. **Component JSON** - The component JSON object that was sent to the StackState receiver as part of a larger JSON payload is shown on the left. The JSON defines a component with name **Application1**. The JSON payload is processed by the topology synchronization on which the mapper function was configured.
2. **Mapping function script** - A part of the mapping function is shown at the bottom to show the value of the label.
3. **Component template** - A part of the component template is shown in the center. In the component template, the `labels` payload is processed using the `join` helper, as shown on line 30. This iterates through each string in the label list and outputs the JSON block on lines 31 until 34. The `this` variable inside the `join` helper on line 33 is used access the current value in the iteration. In this example, there is only one label to be processed. This is because there is no `labels` key in the original JSON and the mapping function adds the only one. Lines 37 until 40 also define a fixed label. The label defined there will have the value `demo:demo`. This shows that, in this example, the mapping function could also be replaced by adding the appropriate label block directly in the component template.
4. **Component properties** - On the right is the Component Details tab of the **Application1** component after the JSON payload has been  processed by topology synchronization.  The **Application1** component has two labels:
   * The `demo:demo` label that was added by the component template. 
   * The `label-added-by-mapper-function` that was added by the mapping function .

### Dynamic - add metric streams

This example is used for hosts reported by StackState Agent. The mapping function adds the information needed to create a metric stream to the data payload, the template can then convert the information to actual metric streams. 

1. [The mapping function script](#script-2)
2. [Metric stream](#metric-stream)

#### Script

Line 1 of the script sets the value of the key streams to be a list. 

The entries of that list are also added, as shown on lines 2 through to 14. Each entry will be a map of `key:value` pairs with enough information about the metric stream for the template to create the stream definition. Each entry contains the keys `name`, `metric`, `id`, and `priority`.

Line 17 contains an `if` statement checking whether the operating system is Linux by checking the `os.linux` data payload. If the `if` statement resolves to `True`, then two more metric streams are added to the streams list. This illustrates that the mapping function can be used to make  decisions based on the received data to change the resulting topology element.

{% code overflow="wrap" lineNumbers="true" %}
```commandline
element.data.put("streams", [
  [name: "CPU time - User (percentage, normalized for number of cores)", metric: "system.cpu.user", id: "-102", priority: "MEDIUM"],
  [name: "CPU time - Idle (percentage, normalized for number of cores)", metric: "system.cpu.idle", id: "-103", priority: "MEDIUM"],
  [name: "CPU time - IOWait (percentage, normalized for number of cores)", metric: "system.cpu.iowait", id: "-104", priority: "MEDIUM"],
  [name: "CPU time - System (percentage, normalized for number of cores)", metric: "system.cpu.system", id: "-105", priority: "MEDIUM"],

  [name: "File handles in use (fraction)", metric: "system.fs.file_handles.in_use", id: "-106", priority: "MEDIUM"],

  [name: "Memory - Usable (fraction)", metric: "system.mem.pct_usable", id: "-109", priority: "MEDIUM"],
  [name: "Memory - Usable (MB)", metric: "system.mem.usable", id: "-110", priority: "LOW"],
  [name: "Memory - Total (MB)", metric: "system.mem.total", id: "-111", priority: "LOW"],

  [name: "Swap - Free (fraction)", metric: "system.swap.pct_free", id: "-112", priority: "MEDIUM"],
  [name: "Swap - Total (MB)", metric: "system.swap.total", id: "-113", priority: "LOW"]
])

if (element.data["os.linux"] == "linux") {
  element.data.put("streams", element.data["streams"] << [name: "File handles max (value)", metric: "system.fs.file_handles.max", id: "-107", priority: "LOW"])
  element.data.put("streams", element.data["streams"] << [name: "System load (1 minute, normalized for number of cores)", metric: "system.load.norm.1", id: "-108", priority: "MEDIUM"])
}

// Streams whose ids will be referenced form the template
element.data.put("streamIds", [usable_memory: "-110"])

element

```
{% endcode %}

#### Metric stream

The template and a resulting stream are shown here.

![Metric stream from mapping function](/.gitbook/assets/v51_dynamic_mapping_metric.png)

From the mapping function, one entry from the **streams** list is shown at the top to illustrate how the component template handles the data. 
The **streams** section of the component template is shown on the left. On the right, the resulting metric stream is shown.

The template shows the streams block starting on line 53 in the screenshot above. For easy reference, the full streams block is shown below.

* Line 2 in the streams block below shows the `join` helper being used to iterate over each entry in the streams list. 
* Inside the `join` helper’s code block, a definition of a metric stream is placed. Each entry in the streams list adds a new stream definition to the resulting template JSON.  Variables are used to create stream blocks dynamically. These variables are available on each entry of the streams list. Each entry contains the following variables: `name`, `metric`, `id`, and `priority`. 
* The `name` key is referenced on line 5 to add the value as the name of the stream. In the screenshot above, the resulting name of the stream is shown on the right. 
* The `conditions` block on line 7 adds two conditions for each metric stream. 
* Lines 8 through to 11 define a filter for the host. The value for that condition is obtained from `element.data.host` and not from the streams list. 
* The condition on lines 12 through to 15 references the metric key provided by the streams list entry. 
* In the screenshot above, the `name` condition is shown on the right, in the **Select** drop-down. 

{% code title="Template streams block from line 53 in screenshot" overflow="wrap" lineNumbers="true" %}
```commandline
  "streams": [
    {{# join element.data.streams "," }}
      {
        "_type": "MetricStream",
        "name": "{{ name }}",
        "query": {
          "conditions": [
            {
              "key": "host",
              "value": "{{ element.data.host }}"
            },
            {
              "key": "name",
              "value": "{{ metric }}"
            }
            {{# if conditions }}
            {{# join conditions "," "," }}
            {
              "key": "{{ key }}",
              "value": "{{ value }}"
            }
            {{/ join }}
            {{/if }}
          ],
          "_type": " MetricTelemetryQuery",
          "metricField": "value",
          "aggregation": "MEAN"
        },
        "dataSource": {{ get "urn:stackpack:common:data-source:stackstate-metrics" }},
        "dataType": "METRICS",
        "id": {{ id }}
        {{#if priority }},
        "priority": "{{ priority }}"
        {{/if }}
      }
    {{/ join }}
  ], 
```
{% endcode %}

After processing, the resulting component contains quite some metric stream definitions - one metric stream definition for each entry in the streams list. 
The list and the join helper shows that definitions can be created dynamically. 
Alternatively, it would have been possible to add each metric stream definition inside the streams block, however, this would make the streams block somewhat large and repetitive. 


## See also

* [Topology synchronization](/configure/topology/sync.md)
