---
description: StackState Self-hosted v5.0.x
---

# Overview

The page explains how health state in StackState works with custom instrumentations in specific scenarios. Before reading further:

* If you have not already read about the health state span mapping `http.status_code`, head over to the page [tracer and span mappings](/stackpacks/integrations/opentelemetry/manual-instrumentation/mappings.md) to understand how the health state is mapped to a span. 
* If you are not familiar with how health state works in StackState, see the page [about health state](/use/concepts/health-state.md) to learn about the types of element health state available, what propagated health state is and how it works.

# Health state without merging

In the following scenario, three components were created with the manual instrumentation:

1. **Parent Component** - the root span.
   - Added `http.status_code` of `200`
2. **Child Component** - the second span. Has the parent span ID of the first (root) span.
   - Added `http.status_code` of `200`
3. **Child 2 Component** - the third span. Has the parent span ID of the second span
   - Added `http.status_code` of `200`

As seen below, it works as expected and all three components are healthy - they have a CLEAR state.

![Topology Perspective Healthy Manual Instrumentation Components](../../../../.gitbook/assets/v50_otel_topology_perspective_healthy_component.png)

Now, let's change the `http.status_code` of the second span to `400`

As you can see below, the **Child Component** turned into a DEVIATING and then a CRITICAL state and this unhealthy health state propagates upwards to the **Parent Component**.

{% tabs %}
{% tab title="CLEAR to DEVIATING" %}
![Topology Perspective Single Deviating Manual Instrumentation Component](../../../../.gitbook/assets/v50_otel_topology_perspective_deviating_component.png)
{% endtab %}
{% tab title="DEVIATING to CRITICAL" %}
![Topology Perspective Single Critical Manual Instrumentation Component](../../../../.gitbook/assets/v50_otel_topology_perspective_critical_component.png)
{% endtab %}
{% endtabs %}

# Health state with merging

Now we want to test how health state works when merging with a pre-existing component. For details on how custom instrumentations will be merged with existing components in StackState, see the page [Merging components](merging.md).

In the following scenario, three components were created with the manual instrumentation:

1. **Parent Component** - the root span.
   - Added `http.status_code` of `200`
2. **Child Component** - the second span. Has the parent span ID of the first (root) span.
   - Added `http.status_code` of `200`
3. **Child 2 Component** - the third span. Has the parent span ID of the second span.
   - Added `http.status_code` of `200`

This time, two pre-existing AWS components are included in the filter so that we can see them on StackState. One pre-existing component is in a CRITICAL state and one is in a CLEAR (healthy) state. The three created components and the two pre-existing AWS components can be seen in the screenshot below. No components have been merged here.

![Manual Instrumentation Components Unmerged To Pre-Existing Components](../../../../.gitbook/assets/v50_otel_components_unmerged.png)

## Merge with a healthy component

Now let's get a `service.identifier` from the bottom right CLEAR (green) component called `otel-example-custom-instrumentation-dev-create-custom-component`.

As you can see in the image below, this component has an identifier of `arn:aws:lambda:eu-west-1:965323806078:function:otel-example-custom-instrumentation-dev-create-custom-component`

![Topology Perspective Properties View - Identifier Preview](../../../../.gitbook/assets/v50_otel_traces_merge_with_healthy.png)

We can merge the **Child Component** with this healthy AWS Lambda component. To do this, we need to add the identifier for the AWS component into the manual instrumentation for the **Child Component**.

This produces the following result:

![OTEL Component Merged With Pre-Existing Healthy Component](../../../../.gitbook/assets/v50_otel_traces_merge_with_healthy_complete.png)

As you can see, the relations have now successfully been drawn between the components and the merged one. The health state of the resulting component stayed as CLEAR, this is as expected seeing as both components had a `200` state to start with.

## Merge with an unhealthy component

Now let's get a `service.identifier` from the bottom left CRITICAL (red) component called `otel-example-custom-instrumentation-dev-force-error` and remove the current one that we are using on the right.

As you can see in the image below, this component has an identifier of `arn:aws:lambda:eu-west-1:965323806078:function:otel-example-custom-instrumentation-dev-force-error`

![Topology Perspective Properties View - Identifier Preview](../../../../.gitbook/assets/v50_otel_traces_merge_with_critical.png)

We can merge the **Child Component** with the unhealthy AWS Lambda component by adding the identifier into the manual instrumentation for the **Child Component**.

This produces the following result:

![OTEL Component Merged With Pre-Existing Critical Component](../../../../.gitbook/assets/v50_otel_traces_merge_with_critical_complete.png)

The original component has a `200` (CLEAR) status and the component that it merged with has a `400` status. As you can see, the DEVIATING or CRITICAL state will always take precedence. If one of the components that has been merged changes to have a CRITICAL or DEVIATING state, it will be indicated as shown above.

The unhealthy state will then propagate upwards to the parent relations.
