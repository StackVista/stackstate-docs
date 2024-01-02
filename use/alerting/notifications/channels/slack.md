---
description: StackState Kubernetes Troubleshooting
---

# Slack 

## Configure Slack notifications

To send notifications to Slack follow these steps:

1. [Connect StackState to your Slack workspace](#connect-slack-workspace)
2. [Select a Slack channel to sent the notifications to](#select-a-slack-channel)
3. [Add and test the channel](#and-the-channel-and-test-it)

### Connect Slack Workspace

Click on the "Choose workspace" button. This will open a Slack webpage where StackState asks for permission to list channels and send messages to Slack channels. Make sure that in the top-right corner you have the desired Slack workspace selected.

Click "Allow" to continue.

### Select a Slack channel

![Select the Slack channel](/.gitbook/assets/k8s/notifications-slack-channel-configuration.png)

Back in StackState you can now select a Slack channel from the list. Select the channel where the notification messages need to be sent.

{% hint style="info" %}
Private channels will not be listed automatically. To select a private channel first invite the StackState bot into the private channel by sending a Slack message in the channel that mentions the bot `@StackState` and selecting "Invite them". Now the channel will become available in the list.
{% endhint %}

## And the channel and test it

Finally click the "Add channel" button. This adds the channel to the list of channels on the right. It will show a "Test" button. Press it to verify that the test message appears in the selected Slack channel. 

## Slack messages for notifications

When a notification is opened a new Slack message is created. This message will be updated for changes, usually only when the health state changes. In the thread for the message every change will show up as a message as well. Finally, when the notification is closed the Slack message is updated again (now the bar that shows the health state is grey) and a final message is added to the Slack thread that describes why the notification was closed.

<figure><img width="75%" src="/.gitbook/assets/k8s/notifications-slack-message-example.png" alt="Slack thread example"><figcaption><p>A Slack message with its thread for a closed notification</p></figcaption></figure>

## Related

* [Troubleshooting](../troubleshooting.md)