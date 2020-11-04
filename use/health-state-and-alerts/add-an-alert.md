---
description: Alert when issues occur
---

# Alerts

When something goes wrong within your IT environment StackState can alert you or your team mates with a message in the form of an email, private message, mobile ping or incident report. Additionally, StackState can trigger automation to take corrective measures. This guide will help you set this up.

## How events trigger alerts

Before configuring StackState to send out alerts it is helpful to have a general understanding of how an alert is triggered.

All telemetry in StackState flows through either metric or event streams that are part of to the components in the topology. Checks determine the health state of these components based on their telemetry streams. All health states, like the check health state, component health state and view health state are based on the health states determined by checks. All state changes generate events. The different types of events can trigger event handlers that can send out an alert or trigger some type of automation.

![Events Perspective](/.gitbook/assets/event-perspective.png)

The entire flow of events that lead to an alert follow this path:

* A check changes health state \(e.g. becomes `critical`\).
* This causes the component to change state for which an event is shown in the event stream pane \(in a view click on the bell icon on the far right\).
* The health state propagates to other components that causes their propagated health state to change based on the propagation function of each component. This triggers an event for all affected components. These events are not visible in the event stream, but can be used for alerting.
* A view that contains these components can also change health state based on these changes. This triggers a `view state change` event to be created. These events are not shown in the event stream.
* Events that are triggered by components contained in a view or by the view changing state itself can trigger event handlers.
* Event handlers are configured on views and can send alerts or trigger some kind of automation.

## Send alerts with event handlers

You can use StackState event handlers to send out alerts whenever there is a change in the health state of individual components, relations or topology views. A number of event handlers are included out of the box:

- **Email**: Send an email alert to a specified email address. Note that an [SMTP server must be configured](/configure/topology/configure-email-alerts.md) in StackState.
- **HTTP webhook POST**: Send an HTTP POST request to a specified URL.
- **Slack**: Send a notification to a specified Slack webhook URL.
- **SMS**: Send an SMS alert (MessageBird) to a specified phone number.

Event handlers can be added from the StackState UI Events Perspective.

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

1. Go to the [Events Perspective](/use/views/events_perspective.md).
2. Select **Events Settings** on the left.
3. Click **ADD EVENT HANDLER**.
4. Select the event handler function you wish to add.
5. Enter the required details, these will vary according to the type of event handler function you have selected.
6. Select the type of state changes that should trigger alerts:
    - **State changes** - trigger on either an own health state change or a propagated health state change of a component/relation.
    - **Own state changes** - trigger only on an own health state change of a component/relation.
    - **Propagated state changes** - trigger only on a propagated health state change of a component/relation.
    - **View state changes** - trigger only on a health state change of the entire view.
7. Click **SAVE**.



