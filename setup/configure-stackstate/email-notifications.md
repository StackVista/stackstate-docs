---
description: SUSE Observability Self-hosted
---

# Configuring SUSE Observability for E-mail notifications

{% hint style="warning" %}
SaaS users of SUSE Observability can use E-mail notifications without extra configuration. This guide is only applicable for self-hosted SUSE Observability installations, that are planning to use the E-mail notification channel.
{% endhint %}

Before you can use the E-mail notification channel in SUSE Observability, you first need to follow the following steps:

## Configure SUSE Observability with the SMTP configuration

SUSE Observability needs to be configured with credentials to connect to the SMTP server. You can do this by adding the following to the `values.yaml` file of your SUSE Observability installation:

```yaml
stackstate:
  components:
    all:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_email_sender: "<stackstate@example.com>"
          CONFIG_FORCE_stackstate_email_server_host: "<smtp.example.com>"
          CONFIG_FORCE_stackstate_email_server_username: "<user name>"
        secret:
          CONFIG_FORCE_stackstate_email_server_password: "<user password>"
```

This will use port `587` on the SMTP server and uses the `STARTTLS` command to establish a secure connection.
To use a different port, it can be specified explicitly:

```yaml
stackstate.components.all.extraEnv.open:
  CONFIG_FORCE_stackstate_email_server_port: 465
```
