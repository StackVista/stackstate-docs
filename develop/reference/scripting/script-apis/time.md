---
description: StackState Self-hosted v5.0.x 
---

# Time - script API

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/reference/scripting/script-apis/time).
{% endhint %}

The Time API offers helper functions to manipulate with [time type](../time-in-scripts.md) in StackState scripts.

## Function: `Time.currentTimeSlice()`

Returns a time slice for the current timestamp

### Examples

```text
Time.currentTimeSlice().then { slice -> 
    Topology.query('environments in ("Production")')
    .at(slice)
    .components()
    .thenCollect { component -> 
       Component
       .withId(component.id)
       .at(slice)
       .get()
    } 
}
```

## Function: `Time.format(instant: Instant, pattern: String)`

Format an instant to string using the given formatting pattern

### Args

* `instant` - [an instant type representation](../time-in-scripts.md#type-instant).
* `pattern` - [Java date formatting pattern](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/time/format/DateTimeFormatter.html#patterns)

### Examples

Format an instant to ISO 8601 time

```text
Time.format(1577966400000, "yyyy-MM-dd'T'HH:mm:ss'Z'")
```

## Function: `Time.epochMs(instant: Instant)`

### Args

* `instant` - [an instant type representation](../time-in-scripts.md#type-instant).

### Examples

Convert a string timestamp to epoch

```text
Time.epochMs("2011-12-03T10:15:30Z")
```
