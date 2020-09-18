---
title: Wildcard search
kind: Documentation
aliases:
  - /usage/wildcard_search/
---

# Wildcard search in Logz.io

{% hint style="warning" %}
This page describes StackState version 4.0.<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

StackState provides ability to make Logz.io and Elasticsearch wildcard search operations. This approach introduces the **Support Wildcards in values** switch in the Telemetry Sources page for Logz.io.

### Optional Prerequisites:

* To use wildcard search you need to set the **Support Wildcards in values** to the `On` status while creating a new Telemetry Source.

## Usage

You can make wildcard searches for Logz.io in the Telemetry Stream for the selected components. Add a new stream to your component, then you can use following characters to enhance your search:

* `*` - can match zero or more characters, including an empty one. Value should not start with an asterisk.
* `?` - matches any single character. You can add multiple question marks to the value. Value should not start with a question mark.

Please note, that the **Support Wildcards in values** switch is set to `Off` value by default. If this switch is not set to the `On` state, then `*` and `?` will not be treated as an escaped character and will not trigger a wildcard search.

### Example

To search for the latest image related results, you could use a following filter and value:

`wildcardImageSearch` == `example/image*latest`

