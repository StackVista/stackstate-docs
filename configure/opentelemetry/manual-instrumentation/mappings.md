---
description: StackState Self-hosted v5.0.x
---

# Manual instrumentation mappings for StackState
Before we jump into the nitty-gritty of the actual code we can write for a OpenTelemetry instrumentation, let's first look
at what key-value pairs we require within our spans, and where it is found inside the StackState UI.

You will have to include the span key values when you create your spans inside the manual OpenTelemetry instrumentation.

We will get to a few code examples later on in the documentation.

## Defining a tracer name and version that StackState understands
For StackState to understand your data, a tracer name and version needs to be passed to with your instrumentation.
StackState requires the following:

- Tracer Name: `@opentelemetry/instrumentation-stackstate`
- Version: `1.0.0`

We will show how the above is implemented when we get to the code examples page. For now, it is good to know that is the above does not match what the StackState Agent is expecting then it will not be displayed on StackState. 

If you run you StackState Agent in debug mode then you should receive a message about an unknown instrumentation and the name that was passed to it

## Span mapping requirements - Summary
Below is a table with a summary of all the span keys that's required

You need to include **ALL** the keys below when creating a span as they all need to be provided before the component will appear on your StackState instance.

| ***Key***                       |  ***Type***  | ***Required***  | ***Allowed Value*** | ***Example***                |
|:--------------------------------|:------------:|:---------------:|:-------------------:|:-----------------------------|
| **trace.perspective.name**      |   `string`   |     **yes**     |     Any string      | AWS RDS: Hello World Database|
| **service.name**                |   `string`   |     **yes**     |     Any string      | AWS RDS: Database            |
| **resource.name**               |   `string`   |     **yes**     |     Any string      | Database                     |
| **service.type**                |   `string`   |     **yes**     |     Any string      | AWS RDS                      |
| **service.identifier**          |   `string`   |     **yes**     |     Any string      | aws:rds:database:hello-world |
| **http.status_code**            |   `number`   |     **no**      |     HTML status     | 200                          |

## Span mapping requirements - Breakdown
### Trace Perspective Name
  - `Key`
    - trace.perspective.name
  - `Expected`
    - This field can be any string value
  - `Example`
    - AWS RDS: Hello World Database
  - `Description`
    - This is the core name of your component and trace in StackState. This will be used as the main identifier to spot your component in the Topology Perspective or on the horizontal lines within the Trace Perspective view within a trace.

{% tabs %}
{% tab title="Topology Perspective" %}

**Example of where the trace.perspective.name is displayed within the Topology Perspective**

1) When you view the Topology Perspective page your component should be visible with this as the primary identifier,
as seen within the picture below.

![service type](../../../.gitbook/assets/otel_traces_trace_perspective_c.png)

{% endtab %}
{% tab title="Topology Perspective - Component Properties" %}

**Example of where the trace.perspective.name is displayed within the Topology Perspective within your component properties**

1) Click on your component in the StackState Topology Perspective
2) Click on the `SHOW ALL PROPERTIES` button on the right side, a popup will appear.
3) A row with the key `name` will contain the value you defined, as seen below in the image.
4) Your component will also contain a new label called service-name, this will also represent your component name.

![service type](../../../.gitbook/assets/otel_traces_trace_perspective_a.png)

{% endtab %}
{% tab title="Trace Perspective" %}

**Example of where the trace.perspective.name is displayed within the Trace Perspective**

1) In your top navigation bar click on the `trace perspective` icon
2) Find the trace in the list of traces and click on it to expand the trace (There might be multiple traces, make sure you select one that contains your trace).
3) You will notice that a horizontal graph line will contain the name of your component as seen below.

![service type](../../../.gitbook/assets/otel_traces_trace_perspective_b.png)

{% endtab %}
{% endtabs %}


### Service Name
  - `Key`
    - service.name
  - `Expected`
    - This field can be any string value
  - `Example`
    - AWS RDS: Database
  - `Description`
    - The service name property will be a unique value attached to your span within your trace in the Trace Perspective.

{% tabs %}
{% tab title="Trace Perspective" %}

**Example of where the service.name is displayed within the Trace Perspective**

1) In your top navigation bar click on the `trace perspective` menu item.
2) Find the trace in the list of traces and click on it to expand the trace (There might be multiple traces, make sure you select one that contains your trace).
3) Click on the `SHOW ALL PROPERTIES` button on the right side, a popup will appear.
4) A row with the key `span.serviceName` will contain the value you defined, as seen below in the image.

![service type](../../../.gitbook/assets/otel_traces_service_name_b.png)

{% endtab %}
{% endtabs %}


### Service Type
  - `Key`
    - service.type
  - `Expected`
    - This field can be any string value
  - `Example`
    - AWS RDS
  - `Description`
    - This will be the service displayed under your trace perspective for a specific trace.

{% tabs %}
{% tab title="Trace Perspective - Span Properties" %}

**Example of where the service.type is displayed within the Trace Perspective Span Properties view**

1) In your top navigation bar click on the `trace perspective` icon
2) Find the trace in the list of traces and click on it to expand the trace (There might be multiple traces, make sure you select one that contains your trace).
3) Click on the `SHOW ALL PROPERTIES` button on the right side, a popup will appear.
4) A row with the key `service` will contain the value you defined, as seen below in the image.

![service type](../../../.gitbook/assets/otel_traces_service_type.png)
{% endtab %}
{% endtabs %}

### Service Identifier ([Used for Merging Components](/configure/opentelemetry/manual-instrumentation/merging.md))
  - `Key`
    - service.identifier
  - `Expected`
    - This field can be any string value
  - `Example`
    - aws:rds:database:hello-world
  - `Description`
    - This value will be added to the identifier list on your component within StackState.
    - ***NB. Components with the same service identifiers will merge into one component, This allows you to merge multiple components and create relations, or merge with an existing StackState component. You can read more about this on the [merging with existing StackState components](/configure/opentelemetry/manual-instrumentation/merging.md) page***

{% tabs %}
{% tab title="Topology Perspective - Component Properties" %}

**Example of where the service.identifier is displayed within the Topology Perspective Component Properties view**

1) Click on your component in the StackState Topology Perspective
2) Click on the `SHOW ALL PROPERTIES` button on the right side, a popup will appear.
3) The row with the key `identifiers` will contain the value you defined, as seen below in the image.
4) ***NB. It is recommended to go and read the [merging with existing StackState components](/configure/opentelemetry/manual-instrumentation/merging.md) page to know how this value can be leverage to create relations***

![service identifier](../../../.gitbook/assets/otel_traces_service_identifier.png)
{% endtab %}
{% endtabs %}


### Resource Name
- `Key`
    - resource.name
- `Expected`
    - This field can be any string value
- `Example`
    - Database
- `Description`
    - This will be the resource.name will be displayed under your trace perspective for a specific trace.

{% tabs %}
{% tab title="Trace Perspective" %}

**Example of where the resource.name is displayed within the Trace Perspective**

1) In your top navigation bar click on the `trace perspective` menu item.
2) Find the trace in the list of traces and click on it to expand the trace (There might be multiple traces, make sure you select one that contains your trace).
3) The section on your right side will contain a row with the key `Resource`, the value displayed next to the key will be the one you defined.

![resource name](../../../.gitbook/assets/otel_traces_trace_resource.png)

{% endtab %}
{% endtabs %}

### HTTP Status Code ([Health State](/configure/opentelemetry/manual-instrumentation/health.md))
  - `Key`
    - http.status_code
  - `Expected`
    - A valid HTTP status for example `200`, `400` or higher
  - `Example`
    - 200
  - `Description`
    - This controls the health state for the component in StackState. 
    - If you post a `400` or higher than the component will go into critical state
      or if you post a `200` then your component will be healthy. This allows you to control the health state of your component
    - For a more advanced breakdown head over to the [OpenTelemetry Custom Instrumentation - Health State Page](/configure/opentelemetry/manual-instrumentation/health.md) for a more in-depth explanation, 
      how health state works with merging components, and what is metrics is displayed by default with the health state and custom instrumentation.

{% tabs %}
{% tab title="Topology Perspective (Healthy)" %}
**You will see the following color on your component if you post a `http.status_code` of `200`**

This means that your component is in a healthy state.

![Healthy](../../../.gitbook/assets/otel_traces_health_state_a.png)
{% endtab %}

{% tab title="Topology Perspective (Critical)" %}
**You will see the following color on your component if you post a `http.status_code` of `400` or higher**

This means that your component is in a critical state.

![Critical](../../../.gitbook/assets/otel_traces_health_state_b.png)
{% endtab %}

{% tab title="Trace Perspective - Span Properties" %}

**The http status can be found in the following location regardless of what the HTTP status actually is**

1) In your top navigation bar click on the `trace perspective` menu item.
2) Find the trace in the list of traces and click on it to expand the trace (There might be multiple traces, make sure you select one that contains your trace).
3) Click on the `SHOW ALL PROPERTIES` button on the right side, a popup will appear.
4) The row with the value `http.status_code` will contain the value you defined, as seen below in the image.

![Healthy](../../../.gitbook/assets/otel_traces_health_state_c.png)
{% endtab %}
{% endtabs %}
