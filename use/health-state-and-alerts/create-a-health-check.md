---
description: 
---

# Create a health check

- ??? do health checks always need to be manually added or is there a default added when a component/relation is created?

Health checks report the status of a StackState component or relation using a check function that responds to a telemetry stream attached to the component/relation. Each component/relation in a StackState topology view can have a health check assigned. The check function used by a health check determines the way in which the health state is reported. A number of check functions are included out of the box with StackState, or you could create your own:

- 


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