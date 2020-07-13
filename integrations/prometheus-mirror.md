---
title: Prometheus Mirror
kind: documentation
description: Pull telemetry from Prometheus using mirroring.
---

# Prometheus Mirror

  Prometheus mirror is a gateway between StackState and prometheus that enables prometheus telemetry in stackstate.

# Mirror Setup

  Prometheus mirror is available as docker image from `quay.io/stackstate/prometheusmirror:latest`.
  For convenience there is a helm chart available from https://helm.stackstate.io/charts/prometheusmirror-x.x.x.tgz

  The important parameters are the following:
  * `global.apiKey` - the key used for mirror authentication
  * `workers` - number of workers processes

# StackState Configuration

  In order to start using prometheus mirror in StackState one has to create Mirror Datasource

## Configure Mirror Datasource

  Create new Mirror datasource
  * DataSourceUrl - points to prometheus mirror endpoint  http://<host>:9900
  * Api Key - should be the same key as specified by `global.apiKey` mirror install
  * Connection Details JSON - the mirror configuration json, e.g.
    ```
      {
        "host": "<prometheus host>",
        "port": <prometheus port>,
        "requestTimeout": 20000
      }
    ```
    Prometheus host/port must point to actual prometheus host/port (not the mirror)

# Query Configuration

## Prometheus Counter

  Counter query allows fetching counter type of metric from prometheus.
  The retrieved counter values are transformed to a rate.

  The example of the configuration of query conditions are given below:

  * __counter__ = go_memstats_lookups_total
  * job = payment-service
  * name = payment
  * instance = 127.0.0.1:80

## Prometheus Gauge

  Gauge query allows fetching gauge type of metrics from prometheus.

  The example of the configuration of query conditions are given below:

  * __gauge__ = go_gc_duration_seconds
  * job = payment-service
  * name = payment
  * instance = 127.0.0.1:80

## Prometheus Histogram and Summary

  Prometheus histogram and summary queries are not supported from query interface. They still can be configured using tilda-query.

## Tilda ~ query

  The query allows arbitrary prometheus queries, e.g.
  ```
    ~ = histogram_quantile(0.95, sum(rate(request_duration_seconds_bucket{instance='127.0.0.1:80', name='payment-service'}[1m])) by (name, le)) * 1000
  ```
