# Add telemetry during topology synchronization

## Overview

Topology that is imported to StackState using a StackPack or other integration is described as synchronized topology. Synchronized topology data arriving in StackState from external systems is normalized using a template. The template defines how a topology element should be build in StackState, such as the layer it belongs to, the health checks to add and any telemetry streams that should be attached to it. The StackPacks provided with StackState already include templates with the relevant telemetry streams for each imported element type. If you create your own integrations or have additional telemetry streams you would like to link with imported components, you can edit the template used during synchronization to automatically add these to imported topology. 

## Add telemetry streams to the synchronization template

If you want to add a telemetry stream to all topology elements imported by a specific integration, you can edit its template function to include the additional telemetry stream. 

### Edit a template function with the template editor

The StackState template editor allows you to customize how StackState builds topology elements from imported topology data. The template editor can be accessed from the StackState UI.

![Template editor](/.gitbook/assets/edit_template.png)

1. Click on an element to open the **Component details** on the right of the screen.
2. Click on **...** and select **Edit template**. 
3. The template editor will open for the template that was used to create the selected element. Three sets of information are displayed:
    - **input paramaters** - the raw data imported for a specific element.
    - **template function** - the template function used by the synchronization that imported the element. When an element is imported, the synchronization will run the template function with input parameters. This outputs a [structured JSON string](/develop/reference/stj/templates.md), which is used to build the **Component properties** you see on the right side of the StackState UI.
    - **Result** - Click **PREVIEW** to see the output of the template function when it runs with the specified input parameters. You can choose to view the result either in JSON format or as it will appear in the StackState UI **Component properties**.
4. You can edit the template function to change how the topology element is built in StackState, for example to [add a telemetry stream to every element imported with this template](#add-a-telemetry-stream-to-a-template-function).

{% hint style="info" %}
Note that you are editing the template for the synchronization that imported the element, not the template for this specific element. Changes saved here will be applied to all future synchronizations for all elements built using this template. 
{% endhint %}

![](/.gitbook/assets/template_editor.png)

### Add a telemetry stream to a template function

The telemetry streams attached to topology elements during synchronization are configured in the template function as `streams: []`. To add a telemetry stream to a component the fields described below are required. The most important part of the stream configuraton is the `query`, this represents the conditions used to filter the stream:

| Field | Allowed values | Description | 
|:---|:---|:---|
| `_type` | MetricStream<br />EventStream | The type of Data Stream. |
| `name` | | A name for the Data Stream. |
| `query._type` | MetricTelemetryQuery<br />EventTelemetryQuery | The type of the Query |
| `query.conditions` | |  A collection of `"key", "value"` attributes used to filter the stream. The keys are defined by the data source, wheras value can be any string, numeric or boolean. |
| `query.metricField` | | Metric streams only. The metric to observe in the stream. |
| `query.aggregation` | MEAN<br />PERCENTILE_25<br />PERCENTILE_50<br />PERCENTILE_75<br />PERCENTILE_90<br />PERCENTILE_95<br />PERCENTILE_98<br />PERCENTILE_99<br />MAX<br />MIN<br />SUM<br />VALUE_COUNT<br />EVENT_COUNT | Metric streams only. The function to apply to aggregate the data. |
| `datasource` | | The data source where to connect to fetch the data. |
| `datatype` | METRICS<br />EVENTS | The kind of data received on the stream. |

For example, a CloudWatch metric stream:

```
{
    ...
    "streams": [
    {
      "_type": "MetricStream",
      "name": "Invocation Duration",
      "query": {
        "conditions": [
            {"key": "Namespace","value": "AWS/Lambda"},
            {"key": "Resource","value": "{{ element.data.FunctionName }}"},
            {"key": "Region","value": "{{ element.data.Location.AwsRegion }}"}
        ],
        "_type": "MetricTelemetryQuery",
        "metricField": "Duration",
        "id": -27,
        "aggregation": "MEAN"
      },
      "dataSource": {{ resolve "DataSource" "CloudWatchSource" }},
      "id": -13,
      "dataType": "METRICS"
    }
    ]
}
```


## See also

- [Add a single telemetry stream to a single component](/use/health-state-and-alerts/add-telemetry-to-element.md)
- [Reference guide: StackState template JSON](/develop/reference/stj/README.md)




