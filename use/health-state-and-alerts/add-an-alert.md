---
description: Use event handlers to trigger an alert or automated action on component or view state changes.
---

# Trigger alerts and actions

## Overview

StackState can be configured to send out alerts or trigger automated actions in response to changes in the health state. Event handlers assigned to a view will run when state change events are generated either by the associated components/relations or by the view itself. 

## Event handlers 

Event handlers are functions that run in response to an event. A number of event handlers are included out of the box, or you could create your own:

- **Email**: Send an email alert to a specified email address. Note that an [SMTP server must be configured](/configure/topology/configure-email-alerts.md) in StackState to send email alerts.
- **HTTP webhook POST**: Send an HTTP POST request to a specified URL.
- **Slack**: Send a notification to a specified Slack webhook URL.
- **SMS**: Send an SMS alert (MessageBird) to a specified phone number.

## Add an event handler to a view

You can add an event handler to a view from the StackState UI Events Perspective.

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

1. Go to the [Events Perspective](/use/views/events_perspective.md).
2. Select **Events Settings** on the left.
3. Click **ADD EVENT HANDLER**.
4. Select the type of state changes that should trigger an alert or automated action:
    - **View state changes** - triggers only on a health state change of the entire view. Recommended to reduce noise.
    - **Own state changes** - triggers with every change to the own health state of a component or relation in the view.
    - **Propagated state changes** - triggers for every change to the propagated health state of a component or relation in the view. The propagated health state is calculated based on the component’s dependencies. Use to alert on potential impact.
5. Select the [event handler](#event-handlers) function that should run whenever the selected event type is generated.
6. Enter the required details, these will vary according to the event handler function you have selected.
7. Click **SAVE**.

## See also

- [Configure an SMTP server to send email alerts](/configure/topology/configure-email-alerts.md)
- [How alerts are triggered](/use/health-state-and-alerts/how-alerts-are-triggered.md)
- [Events Perspective](/use/views/events_perspective.md)

