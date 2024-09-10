---
description: SUSE Observability
---

# Configure notifications 

To configure a new notification these are the steps:

* [Create a new notification](#create-a-new-notification)
* [Configure when to notify](#configure-when-to-notify)
* [Define where notifications should be sent](#where-to-send-notifications)

## Create a new notification

Open the notifications page via the link in the bottom half of hamburger menu in the SUSE Observability UI. This opens an overview of all notifications that are already configured including their status.

You can check if the desired notification already exists. If not create a new one with the "Add new notification" button.

## Configure when to notify

![Adding a new notification](/.gitbook/assets/k8s/notifications-add-new-notification.png)

Configure the notification:

1. Name - Choose a name that's short but still describes what the intent is of this notification. It is for your own reference in the notifications overview.
2. Status - The notification can be disabled temporarily in case it's not yet needed, turns out to be too noisy etc.
3. Notify when - A critical health state always triggers a notification, but optionally also deviating states can be included.
4. Scope - In the example health states for all monitors on pods in the default Kubernetes namespace will be sent. Use the available  filters in the [scope](#scopes) section to change this selection.

### Scope

There are 4 possible scope filters. By default a notification will be sent for each critical (and optionally deviating) health state. The filters are used to limit this scope. A health state will only result in a notification when it matches all filters.

* Monitors: Select 1 or more specific monitors. Notifications will only be sent for health states of the selected monitors.
* Monitor tags: Select 1 or more monitor tags. Notifications will only be sent for health states of monitors that have at least one of the selected tags.
* Component types: Select 1 or more component types. Notifications will only be sent for health states of components of the selected types.
* Component tags: Select 1 or more component tags. Notifications will only be sent for health states of components that have at least one of the selected tags.

## Where to send notifications?

SUSE Observability can send notifications to different external systems via channels. Supported channels are:

* [Slack](channels/slack.md) - Send notifications to Slack
* [Webhook](channels/webhook.md) - Send notifications to a webhook, the webhook endpoint can translate the SUSE Observability payload into any custom third-party API needed
* [Opsgenie](channels/opsgenie.md) - Send notifications to OpsGenie

In general SUSE Observability sends two types of messages for notifications:

1. An `open` message when a health state goes to Critical or Deviating. This message can be repeated when there are changes in the health state
2. A `close` message when the health state isn't Critical or Deviating anymore or when for other reasons (the component disappeared, the monitor was removed, etc.) the notification isn't active anymore.
