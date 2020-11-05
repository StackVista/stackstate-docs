---
description: Trigger alerts and actions on component or view state changes
---

# Add an alert

## Overview



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



