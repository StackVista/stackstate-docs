---
description: StackState Self-hosted v5.1.x 
---

# Logz.io

## Overview

You can use the Logz.io StackPack to connect StackState to Logz.io.

Using this StackPack, you can:

* plot log events from Logz.io onto your topology
* monitor and create event notifications based on Logz.io log events

Logz.io is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Installation

Install the Logz.io StackPack from the StackPacks page in StackState.

## Wildcard search

StackState provides ability to make Logz.io and Elasticsearch wildcard search operations. This approach introduces the **Support Wildcards in values** switch in the Telemetry Sources page for Logz.io.

### Optional Prerequisites:

* To use wildcard search you need to set the **Support Wildcards in values** to the `On` status while creating a new Telemetry Source.

You can make wildcard searches for Logz.io in the Telemetry Stream for the selected components. Add a new stream to your component, then you can use following characters to enhance your search:

* `*` - can match zero or more characters, including an empty one. Value should not start with an asterisk.
* `?` - matches any single character. You can add multiple question marks to the value. Value should not start with a question mark.

Please note, that the **Support Wildcards in values** switch is set to `Off` value by default. If this switch isn't set to the `On` state, then `*` and `?` won't be treated as an escaped character and won't trigger a wildcard search.

### Example

To search for the latest image related results, you could use a following filter and value:

`wildcardImageSearch` == `example/image*latest`

