# Checks and streams

## Overview

Checks are the mechanisms through which elements \(components and relations\) get a health state. The state of an element is determined from data in the associated telemetry streams.

* Read more about [checks](checks_and_streams.md#checks)
* Read more about [telemetry streams](checks_and_streams.md#telemetry-streams)

## Checks

Checks determine the health state of an element by monitoring one or more telemetry streams. Each telemetry stream supplies either metrics \(time-series\) or logs \(logs and events\) data.

### Check Functions

StackState checks are based on check functions - reusable, user defined scripts that specify when a health state should be returned. This makes checks particularly powerful, allowing StackState to monitor any number of available telemetry streams. For example, you could write a check function to monitor:

* Are we seeing a normal amount of hourly traffic?
* Have there been any fatal exceptions logged?
* What state did other systems report?

A check function receives parameter inputs and returns an output health state. Each time a check function is executed, it updates the health state of the checks it ran for. If a check function does not return a health state, the health state of the check remains unchanged.

## Telemetry streams




