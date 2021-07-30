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
3. Add an email [event handler](../../use/metrics-and-events/send-event-notifications.md#send-event-notifications-with-event-handlers) to a view from the StackState UI.
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
3. Add an email [event handler](../../use/metrics-and-events/send-event-notifications.md#send-event-notifications-with-event-handlers) to a view from the StackState UI.
{% endtab %}
{% endtabs %}

## See also

* [Add an event handler](../../use/metrics-and-events/send-event-notifications.md#send-event-notifications-with-event-handlers)
* [Event handler functions](../../develop/developer-guides/custom-functions/event-handler-functions.md)

