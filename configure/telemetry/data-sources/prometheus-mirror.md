---
description: Rancher Observability Self-hosted v5.1.x 
---

# Prometheus mirror

## Overview

Prometheus mirror is a gateway between Rancher Observability and Prometheus that enables Prometheus telemetry in Rancher Observability.

## Prerequisites

The Prometheus Mirror has the following prerequisites:

* The mirror must be reachable from Rancher Observability
* Prometheus must be reachable from the mirror **without authentication**

## Helm

The Prometheus mirror is available via the Rancher Observability helm repository. Configure your helm with these 2 commands:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

Install the Prometheus mirror with the following command:

```text
helm install prometheusmirror stackstate/prometheusmirror --set global.apiKey=API_KEY
```

Alternatively, you can use the Docker container directly:

```text
docker pull stackstate/prometheusmirror:latest
```

## Mirror configuration

The Prometheus mirror is configured using the following parameters:

* `global.apiKey` - the API key used to authenticate communication between the mirror and Rancher Observability
* `workers` - number of workers processes \(default: `20`\)
* `port` - the port the mirror is listening on \(default: `9900`\)

## Rancher Observability configuration

In order to start using Prometheus mirror in Rancher Observability one has to create Mirror Datasource

### Configure Mirror Datasource

Create a new Mirror datasource:

* **DataSourceUrl** - points to the Prometheus mirror endpoint, for example `http://prometheusmirror.stackstate.svc.cluster.local:9900/`
* **API Key** - should be the same key as specified by `global.apiKey` mirror configuration
* **Connection Details JSON** - the mirror configuration json, for example:

  ```json
    {
      "host": "<prometheus host>",
      "port": <prometheus port>,
      "requestTimeout": 20000
    }
  ```

  Prometheus host/port refers to the actual Prometheus host/port (not the mirror).

## Query Configuration

### Prometheus Counter

Counter queries fetch counter metrics from Prometheus. The retrieved counter values are transformed to a rate.

The following are sample parameters for a counter query:

* \_\_counter\_\_ = go\_memstats\_lookups\_total
* job = payment-service
* name = payment
* instance = 127.0.0.1:80

### Prometheus Gauge

Gauge queries fetch gauge metrics from Prometheus.

The following are sample parameters for a gauge query:

* \_\_gauge\_\_ = go\_gc\_duration\_seconds
* job = payment-service
* name = payment
* instance = 127.0.0.1:80

### Prometheus Histogram and Summary

Prometheus histogram and summary queries are **not** supported from the query interface. They still can be configured using tilda-query.

### Tilde query ~

The query allows arbitrary Prometheus queries, for example:

```text
~ = histogram_quantile(0.95, sum(rate(request_duration_seconds_bucket{instance='127.0.0.1:80', name='payment-service'}[1m])) by (name, le)) * 1000
```

## See also

* [Developer guide - mirroring telemetry](../../../develop/developer-guides/mirroring.md)
* [Developer tutorial - Set up a mirror to pull telemetry data from an external system](../../../develop/tutorials/mirror_tutorial.md)

