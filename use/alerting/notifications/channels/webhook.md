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

### Example payload for an open notification request

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

### Exampe payload for a close notification request

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

## Validate the requests

The secret token specified in the channel configuration is included in the webhook requests in the  `X-StackState-Webhook-Token` header. Your webhook endpoint can check the value to verify the requests is legitimate.

## Retries


## Example webhook

A simple example webhook implementation (our debug webhook?) or even simpler, just a Python webserver that parses the json and logs it and completely ignore the OpenAPI spec (not strictly needed for Python).
