---
description: Automate alerts and actions based on events
---

# Event handlers

## Overview

Event handlers can be attached to a StackState view to [trigger alerts and actions](/use/health-state-and-alerts/set-up-alerting.md) in response to a configured event within the view.

To trigger an alert or action, the event handler will run an [event handler function](#event-handler-functions). This can be set as **Run event handler** in the StackState UI **Add event handler** dialogue.

![Add an event handler](/.gitbook/assets/event_handlers_tab.png)

## Event handler functions

Event handler functions are used to trigger an alert or action in a specific system outside of StackState. For example, an email or a POST to a webhook URL. A number of default event handler functions are included out of the box with StackState, or you can [create a custom event handler function](#create-a-custom-event-handler-function). The event handler functions included with StackState are described below:

- **Email**: Send an email alert to a specified email address. Note that an [SMTP server must be configured](/configure/topology/configure-email-alerts.md) in StackState to send email alerts.
- **HTTP webhook POST**: Send an HTTP POST request to a specified URL.
- **Slack**: Send a notification to a specified Slack webhook URL.
- **SMS**: Send an SMS alert (MessageBird) to a specified phone number.

## Create a custom event handler function




## See also

- [StackState views](/use/views/README.md)
- [Set up alerting](/use/health-state-and-alerts/set-up-alerting.md)