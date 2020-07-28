---
description: Pull telemetry from Prometheus using mirroring.
---

# Prometheus mirror

## Prometheus Mirror

Prometheus mirror is a gateway between StackState and Prometheus that enables Prometheus telemetry in StackState.

## Prerequisites

The Prometheus Mirror has the following prerequisites:

* The mirror must be reachable from StackState
* Prometheus must be reachable from the mirror **without authentication**

## Helm

The Prometheus mirror is available via the StackState helm repository. Configure your helm with these 2 commands:

```text
helm repo add stackstate https://helm.stackstate.io
helm repo update
```

Install the Prometheus mirror with the following command:

```text
helm install prometheusmirror stackstate/prometheusmirror --set global.apiKey=API_KEY
```

Alternatively, you can use the docker container directly:

```text
docker pull stackstate/prometheusmirror:latest
```

## Mirror configuration

The Prometheus mirror is configured using the following parameters:

* `global.apiKey` - the API key used to authenticate communication between the mirror and StackState
* `workers` - number of workers processes \(default: `20`\)
* `port` - the port the mirror is listening on \(default: `9900`\)

## StackState configuration

In order to start using Prometheus mirror in StackState one has to create Mirror Datasource

### Configure Mirror Datasource

Create a new Mirror datasource:

* **DataSourceUrl** - points to Prometheus mirror endpoint  [http://:9900](http://:9900)
* **Api Key** - should be the same key as specified by `global.apiKey` mirror configuration
* **Connection Details JSON** - the mirror configuration json, e.g.

  ```text
    {
      "host": "<prometheus host>",
      "port": <prometheus port>,
      "requestTimeout": 20000
    }
  ```

  Prometheus host/port refers to the actual Prometheus host/port \(not the mirror\).

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

### Tilda ~ query

The query allows arbitrary Prometheus queries, e.g.

```text
    ~ = histogram_quantile(0.95, sum(rate(request_duration_seconds_bucket{instance='127.0.0.1:80', name='payment-service'}[1m])) by (name, le)) * 1000
```

