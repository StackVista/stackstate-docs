# Configure email alerts

To receive email alerts for changes in health state, the StackState configuration must include SMTP server details. 

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
3. Add an email [event handler](/use/health-state-and-alerts/set-up-alerting.md#send-alerts-with-event-handlers).
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
3. Add an email [event handler](/use/health-state-and-alerts/set-up-alerting.md#send-alerts-with-event-handlers).
{% endtab %}
{% endtabs %}