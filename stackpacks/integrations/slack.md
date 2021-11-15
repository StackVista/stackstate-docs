# Slack StackPack

## Overview

The Slack StackPack allows you to receive event notifications in Slack channels. A number of [event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md) that can be use when [adding an event handler to a view](/use/metrics-and-events/send-event-notifications.md) in StackState.

![Slack StackPack](/.gitbook/assets/stackpack-slack.svg)

* Event handlers added to a StackState view run an event handler function in response to events are generated in StackState.
* Configured Slack event handlers send an alert to the specified Slack web hook URL in response to health state changed or problem created/subsumed/resolved events.
* An alert appears in the Slack channel associated with the specified webhook.

![Slack alert](/.gitbook/assets/slack_alert.png)

## Setup

### Install

Install the Slack StackPack from the StackState UI **StackPacks** > **Integrations** screen. You do not need to provide any parameters.

### Configure

To add an event handler that sends notifications to Slack, you will need to [create a Slack Webhook\(slack.com\)](https://api.slack.com/messaging/webhooks).

### Upgrade

When a new version of the Slack StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** > **Integrations** > **Slack**. For a quick overview of recent StackPack updates, check the [StackPack versions](/setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

## Integration details

### Data retrieved

The Slack integration is used to send event notifications to Slack. It does not retrieve any data from Slack.

## Uninstall

## Release notes

## See also
