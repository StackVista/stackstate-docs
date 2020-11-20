# Enable email alerts

## Overview

StackState can send an email alert whenever the health state of an entity or view changes. To enable email alerts, the StackState configuration must include details of the SMTP server to use. 

## Configure the SMTP server to use for email alerting

{% tabs %}
{% tab title="Kubernetes" %}

1. Update the StackState configuration in `values.yaml` to include SMTP server details:
    ```
    stackstate:
      components:
        server:
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
3. Add an email [event handler](/use/health-state-and-alerts/set-up-alerting.md#send-alerts-with-event-handlers) to a view from the StackState UI.
{% endtab %}
{% tab title="Linux" %}
1. Update the StackState configuration file `application_stackstate.conf` to include SMTP server details:
    ```
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
3. Add an email [event handler](/use/health-state-and-alerts/set-up-alerting.md#send-alerts-with-event-handlers) to a view from the StackState UI.
{% endtab %}
{% endtabs %}

## See also

- [Add an event handler](/use/health-state-and-alerts/set-up-alerting.md#send-alerts-with-event-handlers)
- [Event handler functions](/configure/topology/event-handlers.md)