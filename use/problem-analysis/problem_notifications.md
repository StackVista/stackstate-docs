---
description: StackState SaaS
---

# Problem notifications

## Overview

Problems in StackState generate events that can be used to trigger event notifications.

## Send notifications for problem events

To send a notification when problem events are generated:

1. Install the [Slack StackPack](/stackpacks/integrations/slack.md).
2. Select the [view](/use/stackstate-ui/views/about_views.md) that includes the elements for which you would like to receive notifications.
3. You can [add an event handler that listens to problem events](/use/events/manage-event-handlers.md) in the StackState UI right panel **View summary** tab under **Event handlers**.

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
You can create a custom event handler function to trigger actions or send notifications to systems other than Slack in response to problem events.
{% endhint %}

## See also

* [What is a problem?](about-problems.md)
* [Problem navigation](problem_investigation.md)
* [Problem lifecycle](problem-lifecycle.md)
* [Manage Event Handlers](/use/events/manage-event-handlers.md)
