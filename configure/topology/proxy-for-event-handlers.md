# Use a proxy for event handlers

## Overview

StackState can be configured to use a proxy for event handlers. When client proxy settings are configured for http or https in the StackState `application.conf` file, these will be used by all event handlers. No further changes are required in the event handler script.

## Configure proxies for event handlers

To use a proxy for event handlers, http and/or https `client.proxy` details must be added to the `akka` section of the StackState `application.conf` file.

1. Edit `application.conf`.
2. Uncomment the `client.proxy` section under `akka.http` and add details of the proxy **host** and **port**. Note that http and https proxies can be configured here.
    ```
    akka {
      ...
      http {
    #   Global proxy settings for StackState. For now only picked up by our event handlers.
    #   Both http/https can be configured here
    #     client.proxy {
    #       https {
    #         host = ""
    #         port = 443
    #       }
    #     }
      }
    }
    ```
3. Save the `application.conf` file.
4. Restart StackState to apply the configuration changes.
5. All event handlers will now use the configured proxy.


## See also

- [Send event notifications](/use/health-state-and-event-notifications/send-event-notifications.md)
- [Custom event handler functions](/develop/developer-guides/custom-functions/event-handler-functions.md)
- [Enable email event notifications](/configure/topology/configure-email-event-notifications.md)
- [Akka HTTP\(S\) Proxy \(docs.akka.io\)](https://doc.akka.io/docs/akka-http/current/client-side/client-transport.html#http-s-proxy)