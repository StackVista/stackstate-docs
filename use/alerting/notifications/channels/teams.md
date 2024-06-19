---
description: StackState
---

# Teams 

## Configure Teams notifications

To send notifications to Slack follow these steps:

1. [Create an Incoming Webhook for your Teams channel](#create-webhook-for-channel)
3. [Add and test the channel](#add-and-test-the-channel)

### Create webhook for channel

In Teams, add the "Incoming Webhook" app to the channel you want to use for notifications.

![Add Incoming Webhook to channel](/.gitbook/assets/k8s/add-webhook-app.png)

Create the webhook and copy the URL that is created

![Configure Webhook](/.gitbook/assets/k8s/configure-webhook-for-teams-channel.png)

{% hint style="info" %}

## Add and test the channel

![Configure Teams Channe](/.gitbook/assets/k8s/configure-teams-channel.png)

Back in StackState you can now use the Webhook URL to create a notification channel.

## Teams messages for notifications

When a notification is opened or closed a new Teams message is created in the channel.

<figure><img width="75%" src="/.gitbook/assets/k8s/notifications-teams-example.png" alt="Teams example"><figcaption><p>Teams messages for an open and close notification</p></figcaption></figure>

## Related

* [Troubleshooting](../troubleshooting.md)
