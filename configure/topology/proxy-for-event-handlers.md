---
description: Rancher Observability Self-hosted v5.1.x 
---

# Use a proxy for event handlers

## Overview

Rancher Observability can be configured to use a proxy for event handlers. When client proxy settings are configured for `http` or `https` in the Rancher Observability `application_stackstate.conf` file, these will be used by all event handlers. No further changes are required in the event handler function script.

## Configure a proxy for event handlers

To use a proxy for event handlers, proxy details must be added to the `akka` section of the Rancher Observability `application_stackstate.conf` file.

1. Edit the file `application_stackstate.conf`.
2. Add details of the proxy `host` and `port` to the `akka` section at the bottom of the file. Note that the specified proxy will be used for both HTTP and HTTPS requests.

   ```text
   stackstate {
     ...
   }

   akka {
     http {
       ...
       client {
         proxy {
           https {
             host = "example-hostname"
             port = 443
           }
         } 
       }
       ...
     }
   }
   ```

3. Save the `application_stackstate.conf` file.
4. Restart Rancher Observability to apply the configuration changes. All event handlers will now use the configured proxy.

## See also

* [Manage Event Handlers](/use/events/manage-event-handlers.md)
* [Custom event handler functions](../../develop/developer-guides/custom-functions/event-handler-functions.md)
* [Enable email event notifications](configure-email-event-notifications.md)
* [Akka HTTP\(S\) Proxy \(docs.akka.io\)](https://doc.akka.io/docs/akka-http/current/client-side/client-transport.html#http-s-proxy)

