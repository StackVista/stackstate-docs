---
description: Rancher Observability Self-hosted v5.1.x 
---

# Enable email event notifications

## Overview

Rancher Observability can send an event notification by email whenever the health state of an entity or view changes. To enable email event notifications, the Rancher Observability configuration must include details of the SMTP server to use.

## Configure an SMTP server to use for email event notifications

{% tabs %}
{% tab title="Kubernetes" %}
1. Update the Rancher Observability configuration in `values.yaml` to include SMTP server details:

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

2. Restart Rancher Observability to apply the configuration changes.
3. You can [manage the event handlers configured for a view](/use/events/manage-event-handlers.md) in the Rancher Observability UI right panel **View summary** tab under **Event handlers**.
{% endtab %}

{% tab title="Linux" %}
1. Update the Rancher Observability configuration file `application_stackstate.conf` to include SMTP server details:

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

2. Restart Rancher Observability to apply the configuration changes.
3. You can [manage the event handlers configured for a view](/use/events/manage-event-handlers.md) in the Rancher Observability UI right panel **View summary** tab under **Event handlers**.
{% endtab %}
{% endtabs %}

## See also

* [Manage Event Handlers](/use/events/manage-event-handlers.md)
* [Event handler functions](../../develop/developer-guides/custom-functions/event-handler-functions.md)

