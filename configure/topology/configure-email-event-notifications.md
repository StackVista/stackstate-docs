---
description: StackState Self-hosted v4.5.x
---

# Enable email event notifications

## Overview

StackState can send an event notification by email whenever the health state of an entity or view changes. To enable email event notifications, the StackState configuration must include details of the SMTP server to use.

## Configure an SMTP server to use for email event notifications

{% tabs %}
{% tab title="Kubernetes" %}
1. Update the StackState configuration in `values.yaml` to include SMTP server details:

   ```text
    stackstate:
      components:
        viewHealth:
          config: |
            stackstate{
              email {
                properties {
                  "mail.smtp.auth" = "true"   # "true" when user/pass provided   
                  "mail.smtp.starttls.enable" = "false"   # use "true" for TLS
                }
                sender = "<EMAIL_SENDER_ADDRESS>"
                server {
                  protocol = "smtp"
                  host =  "<SMTP_SERVER_HOST>"
                  port = 25
                  username = "XXX"      # optional
                  password = "XXX"      # optional
                }
              }
            }
   ```

2. Restart StackState to apply the configuration changes.
3. Use the [Manage event handlers](/use/stackstate-ui/views/manage-event-handlers.md) pane in the StackState UI to add an email event handler to a view.
{% endtab %}

{% tab title="Linux" %}
1. Update the StackState configuration file `application_stackstate.conf` to include SMTP server details:

   ```text
    stackstate{
      ...

      email {
        properties {
          "mail.smtp.auth" = "true"   # "true" when user/pass provided   
          "mail.smtp.starttls.enable" = "false"   # use "true" for TLS
        }
        sender = "<EMAIL_SENDER_ADDRESS>"
        server {
          protocol = "smtp"
          host =  "<SMTP_SERVER_HOST>"
          port = 25
          username = "XXX"      # optional
          password = "XXX"      # optional
        }
      }

       ...
    }
   ```

2. Restart StackState to apply the configuration changes.
3. Use the [Manage Event Handlers](/use/stackstate-ui/views/manage-event-handlers.md) in the StackState UI to add an email event handler to a view.
{% endtab %}
{% endtabs %}

## See also

* [Manage Event Handlers](/use/stackstate-ui/views/manage-event-handlers.md)
* [Event handler functions](../../develop/developer-guides/custom-functions/event-handler-functions.md)

