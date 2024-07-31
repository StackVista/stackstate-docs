---
description: StackState v6.0
---

# Teams 

## Configure Teams notifications

To send notifications to Slack follow these steps:

1. [Create a Power Automate Flow](#create-a-power-automate-flow)
2. [Add and test the channel](#add-and-test-the-channel)

### Create a Power Automate Flow

In Teams, create a new Flow from the "Webhook" template.
![Create Flow from Webhook template](/.gitbook/assets/k8s/notifications-teams-webhook-template.png)

Select the Team and Channel you want the notification pasted to and save the flow.

Edit the flow and click the "When a Teams webhook request is received" box.  
Copy the HTTP URL parameter.

![Select URL from Flow](/.gitbook/assets/k8s/notifications-teams-select-url.png)

{% hint style="info" %}

## Add and test the channel

![Configure Teams Channe](/.gitbook/assets/k8s/configure-teams-channel.png)

Back in StackState you can now use the Webhook URL to create a notification channel.

## Teams messages for notifications

When a notification is opened or closed a new Teams message is created in the channel.

<figure><img width="75%" src="/.gitbook/assets/k8s/notifications-teams-example.png" alt="Teams example"><figcaption><p>Teams messages for an open and close notification</p></figcaption></figure>

## Related

* [Troubleshooting](../troubleshooting.md)
