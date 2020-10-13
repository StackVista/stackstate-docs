# Alerts with event handlers

You can configure StackState to send out alerts whenever there is a change in the health state of individual components, relations or topology views. A number of event handlers are included out of the box:

- Email: [Send an email alert](#set-up-email-alerts) to a specified email address.
- SMS: Send an SMS alert (MessageBird) to a specified phone number.
- HTTP webhook POST: Send an HTTP POST request to a specified URL.
- Slack: Send a notification to a specified Slack webhook URL.
- HipChat: Send a notification to a specified HipChat webhook URL.

## Set up email alerts

To receive email alerts for changes in health state the StackState configuration must include details of the SMTP server to use. 

1. Update the StackState configuration file `application_stackstate.conf` to include SMTP server details:
    ```
    stackstate{
        ...

        email {
            properties {
                "mail.smtp.auth" = "true"
                "mail.smtp.starttls.enable" = "true"
            }
            sender = "<EMAIL_SENDER_ADDRESS>"
            server {
              protocol = "smtp"
              host =  "<SMTP_SERVER_HOST>"
              port = 587
              username = "XXX"
              password = "XXX "
            }
        }
   
        ...
    }
   
    ``` 
2. Restart StackState to apply the configuration changes.
3. Add an email [event handler](#add-an-event-handler).

### Add an event handler

![Add email event handler](/.gitbook/assets/v41_add_email_event_handler.png)

1. Go to the [Events Perspective](/use/perspectives/event-perspective.md).
2. Select **Events Settings** on the left.
3. Click **ADD EVENT HANDLER**
4. Select the email event handler "Send view health state notifications via email".
5. Enter the required details:
    - **Subject Prefix** - will be added to the subject of the alert email.
    - **To** = the email address to send the alert to.
6. Select the type of state changes that should trigger alert emails:
    - **State changes** - 
    - **Own state changes** - 
    - **Propagated state changes** - 
    - **View state changes** - 
7. Click **SAVE**.


### Add an event handler

![Add event handler](/.gitbook/assets/v41_add_email_event_handler.png)

1. Go to the [Events Perspective](/use/perspectives/event-perspective.md).
2. Select **Events Settings** on the left.
3. Click **ADD EVENT HANDLER**
4. Select the event handler function you wish to add.
5. Enter the required details, these will vary according to the type of event handler function you have selected.
6. Select the type of state changes that should trigger alerts:
    - **State changes** - 
    - **Own state changes** - 
    - **Propagated state changes** - 
    - **View state changes** - 
7. Click **SAVE**.
