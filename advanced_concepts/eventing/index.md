---
title: Eventing
kind: Documentation
---
StackState generates events for every change in your IT Stack. It is possible to react to events with event handlers and to view events in the event stream.

## Events

Everything that StackState detects as a change within your IT Stack is recorded with an event. Events pertaining to a view can be viewed in the event stream that can be opened via the events icon in the right toolbar. Possible events are:

* Health state changed event: If a component or relation changes its [health state](/basic_concepts/#health-states) this event is triggered. It contains the old and new health state and a reference to the component/relation that changed state.
* Propagated health state changed event: If a component or relation changes its propagated health state this event is triggered. It contains the old and new propagated health state and a reference to the component/relation that changed health state.
* View health state changed event: If a view changes its view health state this event is triggered. It contains the old and new view health state and a reference to the view that changed health state.

It is also possible to act upon events with event handlers. Event handlers can be set on a view via the 'View event handlers' tab of the Events pane.

## Event handlers

Event handlers can be used to perform some action when a specific event occurs. Event handlers are based on event handler functions and can be set for a view on the 'Events' pane. An event handler always has an event type as input. Depending on the event handler
function it can have multiple other parameters of different types as input.

Some actions an event handler could perform are:

* Send a notification e-mail
* Send a Slack message
* Trigger a provisioning tool to perform a new deployment

## Event handler functions

An event handler function is a reusable user-defined script that defines a single function that based on some parameter inputs performs some action. The event handler function must have at least one parameter that is a StackState event stream for one of the
event types. Every time an event of the specified type occurs the function will be run with the parameters specified for the function in the event handler.

## Configuring a proxy for event handlers

To configure a proxy for event handlers, put the following configuration in the
`etc/application_stackstate.conf` file. This works for both HTTP and HTTPS.

```
akka.http.client.proxy {
 https {
   host = "<my-proxy-host>"
   port = <my-proxy-port>
 }
}
```
