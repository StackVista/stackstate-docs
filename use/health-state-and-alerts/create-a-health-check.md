---
description: 
---

# Create a health check

- ??? do health checks always need to be manually added or is there a default added when a component/relation is created?
- ??? are health checks added with stackpacks?

## Overview

Health checks report the status of components and relations in StackState. Any component/relation in a StackState topology view with a telemetry stream can have a health check assigned. 

## Check functions

Each health check uses a check function to monitor the telemetry stream attached to the component/relation. The telemetry changes a check function responds to determine the way in which the health check reports component/relation health state. A number of check functions are included out of the box with StackState, or you could create your own:

- **Baseline anomaly detection**<br />Officially a baseline function, see [baseline anomaly detection](/use/health-state-and-alerts/baselining.md).

- **Event contains key/value**<br />Check that the last event contains (at the top-level), the specified value for a key.<br />Returns: `HEALTH_STATE` - `trueState` when the key/value is present, `falseState` when it is not.<br />

- **Event fixed state**<br />This check will always return the state that is provided when an event has been received.<br />Returns: `HEALTH_STATE`<br />

- **Event fixed run state**<br />This check will always return the run state that is provided when an event has been received.<br />Returns: `RUN_STATE`<br />

- **Metrics failed ratio**
Calculate the ratio between the last values of two streams (one is the normal metric stream and one is the failed metric stream). This ratio is compared against the deviating or critical value.
Returns: `HEALTH_STATE`

- **Metric fixed state**
This check will always return the health state that is provided when a metric has been received.
Returns: `HEALTH_STATE`

- **Metric fixed run state**
This check will always return the run state that is provided when a metric has been received.
Returns: `RUN_STATE`

- **Metrics last/max threshold**
Checks whether the ratio of the last value and its maximum is above the critical or deviating percentage.
Returns: `HEALTH_STATE`

- **Metrics local anomaly detection**
Check to detect spikes by calculating a standard deviation on the points in the time window and report deviating when a number of values exceed the multiple.
Returns: `HEALTH_STATE`

- **Metrics maximum average**
Calculate the health state by comparing the average of all metric points in the time window against the configured maximum values.
Returns: `HEALTH_STATE`



Health checks generate events that can be alerted on. 

To create a health check:

1. Select a component or relation in the topology. Health checks require telemetry streams.
2. Optionally, if there are no telemetry streams available on the component or relation then you can create one.
3. Under the health section click on the `add` plus button. An `add check` dialog appears.
4. In the `add check` dialog provide a name for the health check.
5. Optionally, you can provide a description and remediation hint. The description can be used to explain the check in greater detail. The remediation hint is automatically displayed on the component or relation when this check goes to a non clear state \(e.g. `critical` or `deviating`\).
6. Select a check function. Check functions are scripts that take streaming telemetry as an input, check the data based on its logic and on the supplied arguments and outputs a health state. Some may check a metric stream for a threshold, some for spikes, others will a text contained in the event, etc. Each check function requires different arguments. If you want to know what a check function does exactly or want to create your own check function then you can find a full listing of all check functions under the `settings / check functions` page.
7. Each check function has different arguments that need to be supplied. These arguments determine the behavior of the check.
8. At least one of the arguments is a telemetry stream \(some checks may require multiple streams\). For metric streams a windowing method and window size need to be supplied that determine how often the check function runs based on the incoming metrics. If the windowing method is set to batching and window size is set to 60 seconds than the check runs every minute with a minute of metrics. If the windowing method is set to sliding and the window size to 60 seconds then check runs whenever the data flows in after 60 seconds of metrics have been collected.
9. Click `Create` to create the health check. The check is now active and visible under the health section. At first the check will appear gray, because its health state is not yet known. As soon as enough telemetry has been received the check will get a health state.