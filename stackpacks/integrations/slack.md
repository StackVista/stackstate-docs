---
description: StackState SaaS
---

# Slack StackPack

## Overview

The Slack StackPack allows you to receive event notifications in Slack channels. The StackPack installs a number of event handler functions that can be used when [adding an event handler](/use/events/manage-event-handlers.md#add-event-handler) to a view in StackState.


![Slack StackPack](/.gitbook/assets/stackpack-slack.svg)

* Event handlers added to a StackState view run an event handler function in response to events that are generated in StackState.
* A Slack event handler function sends an alert to the specified Slack Webhook URL with details of the generated event.
* An alert appears in the Slack channel associated with the specified Slack Webhook.

![Slack alert](/.gitbook/assets/slack_alert.png)

## Setup

### Install

Install the Slack StackPack from the StackState UI **StackPacks** > **Integrations** screen. You don't need to enter any details.

### Configure

After the Slack StackPack has been installed, a Slack event handler function will be listed when you [add an event handler to a view](/use/events/manage-event-handlers.md#add-event-handler).

Note that you will need to [create a Slack Webhook \(slack.com\)](https://api.slack.com/messaging/webhooks).

### Upgrade

When a new version of the Slack StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** > **Integrations** > **Slack**. 

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

        
For an overview of recent StackPack updates, check the StackPack versions shipped with each StackState release.
{% endhint %}

## Integration details

### Data retrieved

The Slack integration is used to send event notifications to Slack. It doesn't retrieve any data from Slack.

## Uninstall

To uninstall the Slack StackPack, go to the StackState UI **StackPacks** > **Integrations** > **Slack** screen and click **UNINSTALL**.

{% hint style="info" %}
Before you uninstall the Slack StackPack, all event handlers that have been configured to use one of the Slack event handler functions installed by the StackPack must be deleted.
{% endhint %}

## Release notes

**Slack StackPack v0.0.7 (2021-12-10)** 

- Improvement: Add description text to StackPack pages.

**Slack StackPack v0.0.6 (2021-08-24)**

* Improvement: Add related problems to view health handler

**Slack StackPack v0.0.5 (2021-08-23)**

* Improvement: Include contributing causes to the problem handler
* Improvement: Support for warnings when Problems are created, merged and resolved.


## See also

* [Manage event handlers](/use/events/manage-event-handlers.md)
* [Event notifications](/use/events/event-notifications.md)
* [Problem notifications](/use/problem-analysis/problem_notifications.md)
* [Create a Slack Webhook\(slack.com\)](https://api.slack.com/messaging/webhooks)
