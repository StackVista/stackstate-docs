---
title: Specifying time
kind: Documentation
description: Functions related to time and timing.
---

# Script API: Time

Some scripting functions of StackState may accept an `Instant` or `Duration` parameter, representing both a point in time and a range of time.

## Type: `Instant`

An instant can be specified in the following ways:

* As a natural number representing the time in milliseconds since the [Unix epoch](https://en.wikipedia.org/wiki/Unix_time). Almost all StackState response that have a time field represent time in this way. Most nodes for example have a `lastUpdateTimestamp` field that is represented in this way.
* As a string representing time according to a [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) string of which nothing is ommitted. Must be of format: `[YYYY]-[MM]-[DD]T[HH]:[mm]:[SS]Z`.
* As a string representing relative time. Relative time string start with `+` or `-`, followed by a natural number, followed by a time modifier \(see section below\).

Examples of valid instants:

* `1570738241087`
* `"2019-09-18T17:34:02.666Z"`
* `"-523s"`

## Type: `Duration`

A duration is specified as a natural number followed by a time modifier \(see section below\).

Examples of valid durations:

* `"1d"`
* `"9w"`
* `"3m"`

## Time modifiers

The following modifiers are usable for both `Instant` and `Duration`.

* `s` - seconds
* `m` - minutes \(60 seconds\)
* `h` - hours \(60 minutes\)
* `d` - days \(24 hours\)
* `w` - weeks \(7 days\)

