---
description: StackState for Kubernetes troubleshooting Self-hosted
---

# Configuring StackState for Slack notifications

{% hint style="warning" %}
SaaS users of StackState can use Slack notifications without extra configuration. This guide is only applicable for self-hosted StackState installations, that are planning to use the Slack notification channel.
{% endhint %}

Before you can use the Slack notification channel in StackState, you first need to follow the following steps to set up both Slack and StackState:

1. Create a Slack app for StackState in your workspace
2. Configure StackState with the credentials for that Slack app.

## Creating a Slack app for StackState

{% hint style="info" %}
You need to have the permissions in Slack to manage Slack apps for your workspace.
{% endhint %}

Go to the [Slack API page](https://api.slack.com/apps) and click on the **Create New App** button. 

* Select the "From an app manifest" option in the dialog that opens.
* Select the workspace you want to send notifications to and click next.
* Copy the contents of the Slack app manifest below and paste it into the text area. Make sure to replace the values in `redirect_urls` with the URL(s) of your StackState instance. Click next.
* Verify that the URL is correct and that the "bot scopes" listed are `channels:join, channels:read, chat:write, groups:read` and click the create button to create the app.
* On the "Basic information" page of the App it is possible to change the icon (in the Display information section), you can replace it with, for example, the [StackState logo](/resources/logo/stackstate-logo.png)

{% code title="Slack app manifest for StackState, make sure to replace the `redirect_urls` with the URL of your StackState instance." overflow="wrap" %}
```json
{
    "display_information": {
        "name": "StackState",
        "description": "Receive notification messages from StackState",
        "background_color": "#000000"
    },
    "features": {
        "bot_user": {
            "display_name": "StackState",
            "always_online": true
        }
    },
    "oauth_config": {
        "redirect_urls": [
            "https://the.url.of.your.stackstate.installation"
        ],
        "scopes": {
            "bot": [
                "channels:join",
                "channels:read",
                "chat:write",
                "groups:read"
            ]
        }
    },
    "settings": {
        "org_deploy_enabled": false,
        "socket_mode_enabled": false,
        "token_rotation_enabled": false
    }
}
```
{% endcode %}

## Configure StackState with the credentials for that Slack app

StackState needs to be configured with the credentials for the Slack app that you created. You can do this by adding the following to the `values.yaml` file of your StackState installation:

```yaml
stackstate:
  components:
    all:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_notifications_channels_slack_authentication_clientId: "<app client id>"
        secret:
          CONFIG_FORCE_stackstate_notifications_channels_slack_authentication_clientSecret: "<app client secret>"
```

The `<app client id>` and `<app client secret>` values can be found in the "App credentials" section on the "Basic Information" page of the Slack app you created. Apply these configuration changes by running the same Helm command used during installation of StackState ([for Kubernetes](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#deploy-stackstate-with-helm) or for [Openshift](/setup/install-stackstate/kubernetes_openshift/openshift_install.md#deploy-stackstate-with-helm)).

You're now ready to use the Slack notification channel!
