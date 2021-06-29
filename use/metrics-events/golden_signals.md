# Golden signals

## Overview

When monitoring distributed systems, if you have a defined SLO (Service Level Objective), StackState can alert you if one of your SLIs (Service Level Indicator) falls bellow a certain threshold. you can make use of the [four golden signals](https://sre.google/sre-book/monitoring-distributed-systems/#xref_monitoring_golden-signals) described below.

### Latency

To monitor the time it takes to service a request, StackState supports metric streams for HTTP response time for processes and services.

![HTTP total response time (s)](../../images/telemetry/http-response-time.png)

To add a latency stream, [add a telemetry stream](../health-state-and-event-notifications/add-telemetry-to-element.md) and select the following metric: `http_response_time_seconds`. You can filter the stream on any HTTP response code or any of the predefined groups:

- any
- success (100-399)
- 1xx
- 2xx
- 3xx
- 4xx
- 5xx

![HTTP response code](../../images/telemetry/http-code.png)

By default, the following response time streams are set for processes and services that serve on HTTP requests:

- HTTP total response time (s) (95th percentile)
- HTTP 5xx error response time (s) (95th percentile)
- HTTP 4xx error response time (s) (95th percentile)
- HTTP Success response time (s) (95th percentile)

### Traffic

Similar to measuring the latency, the StackState agent supports the `http_requests_per_second` telemetry stream. The same response codes and predefined groups are also supported for the traffic stream.

![HTTP total requests per second](../../images/telemetry/http-req-sec.png)

By default, the following request rate streams are set for processes and services that serve on HTTP requests:

- HTTP total rate (req/s)
- HTTP 5xx error rate (req/s)
- HTTP 4xx error rate (req/s)
- HTTP Success rate (req/s)

### Errors

StackState allows you to monitor on any specific HTTP error code or one of the 4xx or 5xx error groups, as explained above. If your SLO specifies a limit for the rate of errors in your system, you can add a check [as explained here](#-checks).

TODO: Add image with `HTTP 5xx error rate (req/s)` telemetry stream.

### Saturation

There are many ways StackState can help you monitor the saturation of your system, for example:

- HTTP Requests per second.
- CPU usage
- Memory usage

## Checks

