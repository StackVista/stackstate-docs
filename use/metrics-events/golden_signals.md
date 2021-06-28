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

By default, the following response time streams a set for processes and services that serve on HTTP requests:

- HTTP total response time (s) (95th percentile)
- HTTP 5xx error response time (s) (95th percentile)
- HTTP 4xx error response time (s) (95th percentile)
- HTTP Success response time (s) (95th percentile)

### Traffic


### Errors


### Saturation

