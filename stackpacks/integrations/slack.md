---
description: StackState core integration
---

# Slack StackPack

## Overview

The Slack StackPack allows you to receive event notifications in Slack channels. A number of [event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md) that can be use when [adding an event handler to a view](/use/metrics-and-events/send-event-notifications.md) in StackState.

![Slack StackPack](/.gitbook/assets/stackpack-slack.svg)

* Event handlers added to a StackState view run an event handler function in response to events that are generated in StackState.
* A Slack event handler function sends an alert to the specified Slack Webhook URL with details of the generated event.
* An alert appears in the Slack channel associated with the specified Slack Webhook.

![Slack alert](/.gitbook/assets/slack_alert.png)

## Setup

### Install

Install the Slack StackPack from the StackState UI **StackPacks** > **Integrations** screen. You do not need to provide any parameters.

### Configure

After the Slack StackPack has been installed, a Slack event handler function will be listed when you [add an event handler to a view](/use/stackstate-ui/views/manage-event-handlers.md#add-event-handler).

Note that you will need to [create a Slack Webhook\(slack.com\)](https://api.slack.com/messaging/webhooks).

### Upgrade

When a new version of the Slack StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** > **Integrations** > **Slack**. For a quick overview of recent StackPack updates, check the [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

## Integration details

### Data retrieved

The Slack integration is used to send event notifications to Slack. It does not retrieve any data from Slack.

## Uninstall

To uninstall the Slack StackPack, go to the StackState UI **StackPacks** > **Integrations** > **Slack** screen and click **UNINSTALL**.

If an event handler is currently configured to use one of the Slack event handlers installed by the Slack StackPack, it will not be possible to uninstall the StackPack.

## Release notes

**Slack StackPack v0.0.6 (2021-08-24)**

* Improvement: Add related problems to view health handler


**Slack StackPack v0.0.5 (2021-08-23)**

* Improvement: Include contributing causes to the problem handler, use time travelling correctly for URLs
* Improvement: Support for warnings when Problems are created, merged and resolved.

**Slack StackPack v0.0.4 (2021-03-26)**

* Improvement: Update documentation.


**Slack StackPack v0.0.3 (2020-08-18)**

* Feature: Introduced the Release notes pop up for customer

**Slack StackPack v0.0.2 (2020-04-10)**

* Improvement: Updated StackPacks integration page, categories, and icons for the SaaS trial

## See also

* [Manage event handlers](/use/stackstate-ui/views/manage-event-handlers.md)
* [Event notifications](/use/metrics-and-events/send-event-notifications.md)
* [Problem notifications](/use/problem-analysis/problem_notifications.md)
* [Create a Slack Webhook\(slack.com\)](https://api.slack.com/messaging/webhooks)
