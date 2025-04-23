---
description: SUSE Observability
---

# Open Telemetry concepts

This is a summary of the most important concepts in Open Telemetry and should be sufficient to get started. For a more detailed introduction use the [Open Telemetry documentation](https://opentelemetry.io/docs/concepts/)

## Signals

Open Telemetry recognizes 3 telemetry signals:

* Traces
* Metrics
* Logs

At the momemt SUSE Observability supports traces and metrics, logs will be supported in a future version. For Kubernetes logs it is possible to use the [SUSE Observability agent](/k8s-quick-start-guide.md) instead.

### Traces

Traces allow us to visualize the path of a request through your application. A trace consists of one or more spans that together form a tree, a single trace can be entirely within a single service, but it can also go across many services. Each span represents an operation in the processing of the request and has:
* a name
* start and end time, from that a duration can be calculated
* status
* attributes
* resource attributes (see [resources](#resources))
* events

Span attributes are used to provide metadata for the span, for example a span that for an operation that places an order can have the `orderId` as an attribute, or a span for an HTTP operation can have the HTTP method and URL as attributes.

Span events can be used to represent a point in time where something important happened within the operation of the span. For example if the span failed there can be an `exception` or an `error` event that captures the error message, a stacktrace and the exact point in time the error occurred.

### Metrics

Metrics are measurements captured at runtime and they result in a metric event. Metrics are important indicators for application performance and availability and are often used to alert on an outage or performance problem. Metrics have:
* a name
* a timestamp
* a kind (counter, gauge, histogram, etc.)
* attributes
* resource attributes (see [resources](#resources))

Attributes provide the metadata for a metric.

## Resources

A resource is the entity that produces the telemetry data. The resource attributes provide the metadata for the resource. For example a process running in a container, in a pod, in a namespace in a Kubernetes cluster can have resource attributes for all these entities. 

Resource attributes are often automatically assigned by the SDKs. However it is recommended to always set the `service.name` and `service.namespace` attributes explicitly. The first one is the logical name for the service, if not set the SDK will set an `unknown_service` value making it very hard to use the data later in SUSE Observability. The namespace is a convenient way to organize your services, especially useful if you have the same services running in multiple locations.

## Semantic conventions

Open Telemetry defines common names for operations and data, they call this the semantic conventions. Semantic conventions follow a naming scheme that allows for standardizing processing of data across languages, libraries and code bases. There are semantic conventions for all signals and for resource attributes. They are defined for many different platforms and operations on the [Open Telemetry website](https://opentelemetry.io/docs/specs/semconv/attributes-registry/). SDKs make use of the semantic conventions to assign these attributes and SUSE Observability also respects the conventions and relies on them, for example to recognize Kubernetes resources.

