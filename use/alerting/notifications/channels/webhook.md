---
description: StackState Kubernetes Troubleshooting
---

# Webhook

Webhooks are custom HTTP callbacks that you define and run. They can take any action needed whenever a notification is opened or closed, for example by creating a ticket in a ticketing system that is not supported natively by StackState or by simply writing the notifiation message payloads to an S3 bucket for future reference.

The webhook channel sends the notifications data as [JSON over HTTP](#webhook-requests-and-payload).

## Configure a webhook

![Configure a webhook](/.gitbook/assets/k8s/notifications-webhook-channel-configuration.png)

To configure a webhook complete the fields:

1. URL - enter the URL of the webhook endpoint. The URL must be percent-encoded if it contains special characters.
2. Secret token - a secret token that StackState will include in every request to [validate it](#validate-the-requests)
3. Metadata - add additional key/value pairs that are included in the payload. This can be used when the same endpoint handles multiple StackState webhooks and needs some extra information
4. Enable SSL verification - (default on) enable SSL certificate validation. Only disable when using self-signed certificates or certificate authorities not supported by StackState

Finally select "Add channel". The webhook channel will appear on the right. To test that the webhook works send a test message by clicking the "Test" button.

## Webhook requests and payload

The Webhook channel sends data as HTTP POST requests. The endpoint and payload are documented in an [OpenAPI specification](https://github.com/StackVista/stackstate-openapi/tree/master/spec_webhook).

### Example payload for a notification open request

```
{
    "component": {
        "identifier": "urn:kubernetes:/k8s-demo-cluster:sock-shop:service/catalogue",
        "link": "https://play.stackstate.com/#/components/urn%3Akubernetes%3A%2Fk8s-demo-cluster%3Asock-shop%3Aservice%2Fcatalogue?timeRange=1702624556757_1702646156757&timestamp=1702635356757",
        "name": "catalogue",
        "tags": [
            "app.kubernetes.io/component:catalogue",
            "app.kubernetes.io/instance:sock-shop",
            "app.kubernetes.io/managed-by:Helm",
            "app.kubernetes.io/name:sock-shop",
            "app.kubernetes.io/version:0.3.5",
            "cluster-name:k8s-demo-cluster",
            "cluster-type:kubernetes",
            "component-type:kubernetes-service",
            "domain:business",
            "extra-identifier:catalogue",
            "helm.sh/chart:sock-shop",
            "name:catalogue",
            "namespace:sock-shop",
            "service-type:ClusterIP",
            "stackpack:kubernetes"
        ],
        "type": "service"
    },
    "event": {
        "state": "CRITICAL",
        "title": "HTTP - response time - is above 3.0 seconds",
        "triggeredTimeMs": 1702635356757,
        "type": "open"
    },
    "monitor": {
        "identifier": "urn:stackpack:kubernetes-v2:shared:monitor:kubernetes-v2:http-response-time",
        "link": "https://play.stackstate.com/#/monitors/urn%3Astackpack%3Akubernetes-v2%3Ashared%3Amonitor%3Akubernetes-v2%3Ahttp-response-time",
        "name": "HTTP - response time - is above 3 seconds",
        "tags": []
    },
    "notificationConfiguration": {
        "identifier": "urn:system:default:notification-configuration:testing-2",
        "link": "https://play.stackstate.com/#/notifications/urn%3Asystem%3Adefault%3Anotification-configuration%3Atesting-2",
        "name": "Test Notification"
    },
    "notificationId": "836f628c-1258-4500-b1c7-23884e00f439",
    "metadata": {
        "team": "Team A"
    }
}
```

The sections in the `open` payload are:

1. Component: the StackState component that the notification applies to. This includes the components name, identifier, type, and tags. It also contains a link to the StackState UI that will open the component at the time of the health state change
2. Event: the event that triggered this notification. It can either be of type `open` or `close` (see next section). An `open` state means that the monitor is still in a critical (or deviating) state for the specified component. A `close` state means that the monitor was open before but that the issue has been resolved. The state and triggered time are included. Also included is a `title` which is a short description of the problem as provided by the monitor, it is the same title shown in the highlights page of the component, this can be different and more detailed than the monitor name.
3. Monitor: the monitor that triggered the notification. Next to the monitor name, tags and identifier also a link is included. The link will open the monitor in the StackState UI.
4. Notification configuration: The notification configuration for this notification. Includes a name, identifier and link. The link will open the notification configuration in the StackState UI.
5. notificationId: A unique identifier for this notification. See also the [Notification life cycle](#notification-life-cycle)
6. Metadata: It is possible to specify metadata on a webhook channel. The metadata is one-to-one reproduced here as a set of key/value pairs.


### Exampe payload for a notification close request

```
{
    "component": {
        "identifier": "urn:kubernetes:/gke-demo-dev.gcp.stackstate.io:sock-shop:service/catalogue",
        "link": "https://stac-20533-webhook-channel-management-api.preprod.stackstate.io/#/components/urn%3Akubernetes%3A%2Fgke-demo-dev.gcp.stackstate.io%3Asock-shop%3Aservice%2Fcatalogue?timeRange=1702624556757_1702646156757&timestamp=1702635356757",
        "name": "catalogue",
        "tags": [
            "app.kubernetes.io/component:catalogue",
            "app.kubernetes.io/instance:sock-shop",
            "app.kubernetes.io/managed-by:Helm",
            "app.kubernetes.io/name:sock-shop",
            "app.kubernetes.io/version:0.3.5",
            "cluster-name:gke-demo-dev.gcp.stackstate.io",
            "cluster-type:kubernetes",
            "component-type:kubernetes-service",
            "domain:business",
            "extra-identifier:catalogue",
            "helm.sh/chart:sock-shop",
            "name:catalogue",
            "namespace:sock-shop",
            "service-type:ClusterIP",
            "stackpack:kubernetes"
        ],
        "type": "service"
    },
    "event": {
        "reason": "HealthStateResolved",
        "type": "close"
    },
    "monitor": {
        "identifier": "urn:stackpack:kubernetes-v2:shared:monitor:kubernetes-v2:http-response-time",
        "link": "https://stac-20533-webhook-channel-management-api.preprod.stackstate.io/#/monitors/urn%3Astackpack%3Akubernetes-v2%3Ashared%3Amonitor%3Akubernetes-v2%3Ahttp-response-time",
        "name": "HTTP - response time - is above 3 seconds",
        "tags": []
    },
    "notificationConfiguration": {
        "identifier": "urn:system:default:notification-configuration:testing-2",
        "link": "https://stac-20533-webhook-channel-management-api.preprod.stackstate.io/#/notifications/urn%3Asystem%3Adefault%3Anotification-configuration%3Atesting-2",
        "name": "Test Notification"
    },
    "notificationId": "836f628c-1258-4500-b1c7-23884e00f439",
    "tags": {
        "team": "Team A"
    }
}
```

The sections in the `close` payload are the same as in the `open` payload except for the `event`. The `type` is now `close` and there is only a `reason` field indicating why the notification was closed. The value in this field is an enum, the [OpenAPI specification](https://github.com/StackVista/stackstate-openapi/tree/master/spec_webhook) documents the possible values.

## Notification life cycle

As can be seen from the payload each notification is uniquely identified by its `notificationId`. It is possible, even common, to receive multiple messages for the same notification, but they will always follow the life cycle of a notification.

A notification is first created when a monitor state changes to deviating or critical (whether deviating is applicable depends on the [notification settings](../configure.md#configure-when-to-notify)). A message with event type `open` is sent to the webhook.

A notification can be updated when the `state` or the `title` in the event change. Changes to the component and other parts of the message will be included but on their own they won't trigger an update. A notification update also sends a message with event type `open` to the webhook. The message will have the same `notificationId` which can be used to update the data in the external system (instead of creating a new notification).

Finally a notification is closed when the monitor state changes back to a non-critical (or deviating) state. A message with event type `close` is sent to the webhook. This is also the last time that the specific `notificationId` is used.

Note that a notification can be both opened and closed for different reasons than a health state change:
* A tag is added to a component or monitor. This can cause some critical monitor health state to suddenly match the selection criteria in a notification configuration and corresponding notifications will be opened.
* For the same reason removal of a tag from a component or monitor can close a notification even though the health state is still critical.
* Changes to the notification configuration itself can also result in many new notifications being opened or closed.

## Validate the requests

The secret token specified in the channel configuration is included in the webhook requests in the  `X-StackState-Webhook-Token` header. Your webhook endpoint can check the value to verify the requests is legitimate.

## Retries

The webhook channel will retry requests for a notification until it receives a status 200 OK response (the body in the response is ignored). If the webhook fails to process the message (for example because a database is unreachable right at the time) it can simply respond with a 500 status code. StackState will re-send the same message within a few seconds in the hope that the issue has been resolved now.

If a notification was updated or closed the old message will however be discarded and the new, updated, message will be send and again retried until it succeeds.

## Example webhook

To test how webhooks work you can use this simply Python script that starts an HTTP server and writes the received payload to standard out.

1. Save this Python script as `webhook.py`:
```python
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import sys

class WebhookHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_POST(self):
        content_len = int(self.headers.get('content-length', 0))
        notification = json.loads(self.rfile.read(content_len))
        print("Notification received: ", json.dumps(notification, indent = 2))
        self.send_response(200)
        self.end_headers()

httpd = HTTPServer(('', int(sys.argv[1])), WebhookHTTPRequestHandler)
httpd.serve_forever()
```
2. Run the webhook server on an unused port (for example 8000): `python3 webhook.py 8000`
3. Configure the webhook in StackState with the URL for your webhook server `http://webhook.example.com:8000`
4. Click `test` on the webhook channel

{% hint style="info" %}
The URL for your webhook must be accessible by StackState, so a localhost address or a local ip-address won't be sufficient.
{% endhint %}

The example doesn't authenticate the request, which can be added by verifying the value of the [token header](#validate-the-requests).

Instead of implenting this by hand it is also possible to use the [OpenAPI specification](https://github.com/StackVista/stackstate-openapi/tree/master/spec_webhook) for the webhook to generate a server implemenation in any of the languages supported by the [OpenAPI generators](https://openapi-generator.tech/).

## Related

* [Troubleshooting](../troubleshooting.md)