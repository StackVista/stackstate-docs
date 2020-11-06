---
description: 
---

## Add a custom telemetry stream to a component

- ??? Where does telemetry come from?
- ??? Why does it need to be manually added to a component(s) - is this always required or will it sometimes be added automatically when the component is created in sts?
- ??? What if there isn't any telemetry available?
- ??? How to know if telemetry is available?


The sample check we are running also sends telemetry \(metrics\) to StackState, one metric stream for each of the application components. Let's find that telemetry data and map it to one of our applications.

Find the sample check's components in StackState and click on the **some-application-1** component. The Component Details pane opens on the right, showing the metadata of this component.

In the **Telemetry streams** section, click on the **Add** button. This opens the Stream Wizard and allows you to add a new stream. Enter **Gauge** as the name for the stream and select the **StackState Metrics** datasource.

In the Stream Creation screen, fill in the following parameters:

* Time window: Last hour
* Filters: `tags.related` = `application_id_1`
* Select: `example.gauge` by `Mean`

The stream preview on the right should show the incoming metric values. Here is what that looks like:

![](/.gitbook/assets/example-telemetry-stream.png)

Click on the **Save** button to permanently add the stream to the **some-application-1** component.