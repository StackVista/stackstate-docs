---
title: Agent Check Reference
kind: Documentation
---

# Checks in Agent v2

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

This document covers Agent V2 functionality to create checks with Agent V2 Check API. In below sections following topics are covered: sending checks on topology, metrics, events, and service checks, as well as overriding base class methods, logging, and error handling in checks. Code examples lead to StackState's [stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations) repository on GitHub.

## Agent V2 Check API

An Agent Check is a Python class that inherits from `AgentCheck` and implements the `check` method:

```text
from stackstate_checks.checks import AgentCheck

class MyCheck(AgentCheck):
    def check(self, instance):
        # Collect metrics, topologies, emit events, submit service checks

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```

The Agent creates an object of type `MyCheck` for each element contained in the `instances` sequence within the corresponding config file:

```text
instances:
  - host: localhost
    port: 6379

  - host: example.com
    port: 6379
```

Here is an example of the [config file](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/data/conf.yaml.example).

Any mapping provided in `instances` is passed to the `check` method using declared `instance` value.

The `AgentCheck` class provides following methods and attributes:

* `self.name` - a name of the check
* `self.init_config` - `init_config` that corresponds in the check configuration
* `self.log` - a [logger](https://docs.python.org/2/library/logging.html)

## Scheduling

Note: If there is a check already running, there is no need to schedule another one, as multiple instances of the same check will run concurrently.

## Sending topology

Sending topology is done by calling the following methods:

```text
self.component(id, type, data):                     # Creates a component within StackState
self.relation(source_id, target_id, type, data):    # Creates a relation between two components to StackState
self.start_snapshot():                              # Start a topology snapshot for a specific topology instance source
self.stop_snapshot():                               # Stop a topology snapshot for a specific topology instance source
```

Above methods can be called from anywhere in the check. The `data` field within the `self.component` and `self.relation` function represent a dictionary. The fields within this object can be referenced in the `ComponentTemplateFunction` and `RelationTemplateFunction` within StackState. Following example shows usage of `self.component` for [MySQL topology check](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L349).

All submitted topologies are collected and flushed with all the other Agent metrics by StackState at the end of `check` function.

### Sending Streams and Checks

Streams and Checks can be sent in with a component, which will then be mapped in StackState to give you telemetry streams and health states on your components. We support a few different streams and checks out of the box which are described below.

All of the telemetry classes and methods can be imported from `stackstate_checks.base`

Given the following example:

```text
this_host_cpu_usage = MetricStream("Host CPU Usage", "system.cpu.usage",
                                   conditions={"tags.hostname": "this-host", "tags.region": "eu-west-1"},
                                   unit_of_measure="Percentage",
                                   aggregation="MEAN",
                                   priority="HIGH")

cpu_max_average_check = MetricHealthChecks.maximum_average(this_host_cpu_usage.identifier,
                                                           "Max CPU Usage (Average)", 75, 90,
                                                           remediation_hint="There is too much activity on this host, try adding another host")

self.component("urn:example:/host:this_host", "Host",
               data={
                    "name": "this-host",
                    "domain": "Webshop",
                    "layer": "Machines",
                    "identifiers": ["urn:host:/this-host-fqdn"],
                    "labels": ["host:this_host", "region:eu-west-1"],
                    "environment": "Production"
               },
               streams=[this_host_cpu_usage],
               checks=[cpu_max_average_check])
```

We create a `MetricStream` on the `system.cpu.usage` metric with some conditions specific to our component. We then create a `maximum_average` check on our metric stream using `this_host_cpu_usage.identifier` . The stream and check is then added to the streams and checks list in our `this-host` component.

#### Events Stream

An Event stream can be added to a component using the `EventStream` class. It expects a stream `name` and `conditions` for the metric telemetry query in StackState. Event Streams have a few out of the box supported checks which can be mapped using the stream identifier.

```text
class EventStream(TelemetryStream):
    """
    creates a event stream definition for the component that will bind events in StackState for the conditions.
    args: `name, conditions`
    `name` The name for the stream in StackState
    `conditions` is a dictionary of key -> value arguments that are used to filter the event values for the stream.
    """

class EventHealthChecks(object):

    def contains_key_value(stream_id, name, contains_key, contains_value, found_health_state, missing_health_state, description=None, remediation_hint=None):
        """
        Check that the last event contains (at the top-level), the specified value for a key.
        Returns 'found_health_state' value when the state is contained and 'missing_health_state' when it is not
        contained.
        args: `stream_id, name, contains_key, contains_value, found_health_state, missing_health_state, description,
                remediation_hint`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `contains_key` the key that should be contained in the event
        `contains_value` the value that should be contained in the event
        `found_health_state` the health state to return when this tag and value is found
        `missing_health_state` the health state to return when the tag/value is not found
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        """

    def use_tag_as_health(stream_id, name, tag_name, description=None, remediation_hint=None):
        """
        Check that returns the value of a tag in the event as the health state.
        args: `stream_id, name, tag_name, description, remediation_hint`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `tag_name` the key of the tag that should be be used as the health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        """

    def custom_health_check(name, check_arguments):
        """
        This method provides the functionality to send in a custom event health check.
        args: `name, check_arguments`
        `name` the name this check will have in StackState
        `check_arguments` the check arguments
        """
```

#### Metric Stream

A Metric stream can be added to a component using the `MetricStream` class. It expects a stream `name` , `metricField`, `conditions` and optionally also `unit_of_measure`, `aggregation` and `priority` for the metric telemetry query in StackState. Metric Streams have a few out of the box supported checks which can be mapped using the stream identifier. Some of the Metric checks require multiple streams in which case they are referred to as the `denominator_stream_id` and `numerator_stream_id` used for ratio calculations.

```text
class MetricStream(TelemetryStream):
    """
    creates a metric stream definition for the component that will bind metrics in StackState for the conditions.
    args: `name, metricField, conditions, unit_of_measure, aggregation, priority`
    `name` The name for the stream in StackState
    `metricField` the name of the metric to select
    `conditions` is a dictionary of key -> value arguments that are used to filter the metric values for the stream.
    `unit_of_measure` The unit of measure for the metric points, it gets appended after the stream name:
    Stream Name (unit of measure)
    `aggregation` sets the aggregation function for the metrics in StackState. It can be:  EVENT_COUNT, MAX, MEAN,
    MIN, SUM, PERCENTILE_25, PERCENTILE_50, PERCENTILE_75, PERCENTILE_90, PERCENTILE_95, PERCENTILE_98,
    PERCENTILE_99
    `priority` sets the stream priority in StackState, it can be NONE, LOW, MEDIUM, HIGH.
    HIGH priority streams are used in StackState's anomaly detection.
    """

class MetricHealthChecks(object):

    def maximum_average(stream_id, name, deviating_value, critical_value, description=None, remediation_hint=None, max_window=None):
        """
        Calculate the health state by comparing the average of all metric points in the time window against the
        configured maximum values.
        args: `stream_id, name, deviating_value, critical_value, description, remediation_hint, max_window`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def maximum_last(stream_id, name, deviating_value, critical_value, description=None, remediation_hint=None,
    max_window=None):
        """
        Calculate the health state only by comparing the last value in the time window against the configured maximum
        values.
        args: `stream_id, name, deviating_value, critical_value, description, remediation_hint, max_window`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def maximum_percentile(stream_id, name, deviating_value, critical_value, percentile, description=None,
    remediation_hint=None, max_window=None):
        """
        Calculate the health state by comparing the specified percentile of all metric points in the time window against
        the configured maximum values. For the median specify 50 for the percentile. The percentile parameter must be a
        value > 0 and <= 100.
        args: `stream_id, name, deviating_value, critical_value, percentile, description, remediation_hint, max_window`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `percentile` the percentile value to use for the calculation
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def maximum_ratio(denominator_stream_id, numerator_stream_id, name, deviating_value, critical_value,
    description=None, remediation_hint=None, max_window=None):
        """
        Calculates the ratio between the values of two streams and compares it against the critical and deviating value.
        If the ratio is larger than the specified critical or deviating value, the corresponding health state is
        returned.
        args: `denominator_stream_id, numerator_stream_id, name, deviating_value, critical_value, description,
        remediation_hint, max_window`
        `denominator_stream_id` the identifier of the denominator stream this check should run on
        `numerator_stream_id` the identifier of the numerator stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def minimum_average(stream_id, name, deviating_value, critical_value, description=None, remediation_hint=None,
    max_window=None):
        """
        Calculate the health state by comparing the average of all metric points in the time window against the
        configured minimum values.
        args: `stream_id, name, deviating_value, critical_value, description, remediation_hint, max_window`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def minimum_last(stream_id, name, deviating_value, critical_value, description=None, remediation_hint=None,
    max_window=None):
        """
        Calculate the health state only by comparing the last value in the time window against the configured minimum
        values.
        args: `stream_id, name, deviating_value, critical_value, description, remediation_hint, max_window`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def minimum_percentile(stream_id, name, deviating_value, critical_value, percentile, description=None,
    remediation_hint=None, max_window=None):
        """
        Calculate the health state by comparing the specified percentile of all metric points in the time window against
        the configured minimum values. For the median specify 50 for the percentile. The percentile must be a
        value > 0 and <= 100.
        args: `stream_id, name, deviating_value, critical_value, percentile, description, remediation_hint, max_window`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `percentile` the percentile value to use for the calculation
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def failed_ratio(success_stream_id, failed_stream_id, name, deviating_value, critical_value,
    description=None, remediation_hint=None, max_window=None):
        """
        Calculate the ratio between the last values of two streams (one is the normal metric stream and one is the
        failed metric stream). This ratio is compared against the deviating or critical value.
        args: `success_stream_id, failed_stream_id, name, deviating_value, critical_value, description,
               remediation_hint, max_window`
        `success_stream_id` the identifier of the success stream this check should run on
        `failed_stream_id` the identifier of the failures stream this check should run on
        `name` the name this check will have in StackState
        `deviating_value` the threshold at which point this check will return a deviating health state
        `critical_value` the threshold at which point this check will return a critical health state
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        `max_window` the max window size for the metrics
        """

    def custom_health_check(name, check_arguments):
        """
        This method provides the functionality to send in a custom metric health check.
        args: `name, check_arguments`
        `name` the name this check will have in StackState
        `check_arguments` the check arguments
        """
```

#### Service Check

A Service Check stream can be added to a component using the `ServiceCheckStream` class. It expects a stream `name` and `conditions` for the metric telemetry query in StackState. Service Check Streams has one out of the box supported check which can be mapped using the stream identifier.

```text
class ServiceCheckStream(TelemetryStream):
    """
    creates a service check stream definition for the component that will bind service checks in StackState for the
    conditions.
    args: `name, conditions
    `name` The name for the stream in StackState
    `conditions` is a dictionary of key -> value arguments that are used to filter the event values for the stream.
    """

class ServiceCheckHealthChecks(object):

    def service_check_health(stream_id, name, description=None, remediation_hint=None):
        """
        Check that returns the service check status as a health status in StackState
        args: `stream_id, name, description, remediation_hint`
        `stream_id` the identifier of the stream this check should run on
        `name` the name this check will have in StackState
        `description` the description for this check in StackState
        `remediation_hint` the remediation hint to display when this check return a critical health state
        """
```

### Sending metrics

Following methods can be called from anywhere in the check:

```text
self.gauge(name, value, tags, hostname):           # Sample a gauge metric
self.count(name, value, tags, hostname):           # Sample a raw count metric
self.rate(name, value, tags, hostname):            # Sample a point, with the rate calculated at the end of the check
self.increment(name, value, tags, hostname):       # Increment a counter metric
self.decrement(name, value, tags, hostname):       # Decrement a counter metric
self.histogram(name, value, tags, hostname):       # Sample a histogram metric
self.historate(name, value, tags, hostname):       # Sample a histogram based on rate metrics
self.monotonic_count(name, value, tags, hostname): # Sample an increasing counter metric
```

Each method accepts following arguments:

* `name` - the name of the metric.
* `value` - the value for the metric. Defaults to 1 on increment, -1 on decrement.
* `tags` - a list of tags to associate with this metric. \(optional\)
* `hostname` - a hostname to associate with this metric. Defaults to the current host. \(optional\)

Check the example for sending metrics [here](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L655).

Note that all submitted metrics are collected and flushed with all the other Agent metrics at the end of `check` function.

## Sending events

Sending events is handled by calling `self.event(event_dict)` method. This method can be called from anywhere in the check. The `event-dict` parameter is a dictionary with the following keys and data types:

```text
{
"timestamp": int,           # the epoch timestamp for the event
"event_type": string,       # the event name
"api_key": string,          # the api key for your account
"msg_title": string,        # the title of the event
"msg_text": string,         # the text body of the event
"aggregation_key": string,  # a key to use for aggregating events
"alert_type": string,       # (optional) one of ('error', 'warning', 'success', 'info'), defaults to 'info'
"source_type_name": string, # (optional) the source type name
"host": string,             # (optional) the name of the host
"tags": list,               # (optional) a list of tags to associate with this event
"priority": string,         # (optional) specifies the priority of the event ("normal" or "low")
}
```

All events will be collected and flushed with the rest of the Agent payload at the end of the `check` function.

## Sending service checks

Reporting status of a service is handled by calling the `service_check` method:

```text
self.service_check(name, status, tags=None, message="")
```

The method can accept the following arguments:

* `name` - the name of the service check
* `status` - a constant describing the service status defined in the `AgentCheck` class:
  * `AgentCheck.OK` for success status.
  * `AgentCheck.WARNING` for failure status.
  * `AgentCheck.CRITICAL` for failure status.
  * `AgentCheck.UNKNOWN` for indeterminate status.
* `tags` - a list of tags to associate with the check. \(optional\)
* `message` - additional information about the current status. \(optional\)

Check the usage in the following [example](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L434).

## Base class methods overriding

By best practice, there is no need to override anything from the base class except the check method. However, sometimes it might be useful for a Check to have its own constructor. When overriding the **init** constructor, depending on the configuration, the Agent might create several different Check instances and the method would be called as many times.

To ease the porting of existing Checks to the new Agent, the **init** method in AgentCheck was implemented with the signature as below

```text
def __init__(self, *args, **kwargs):
```

When overriding, the following convention must be followed:

```text
from stackstate_checks.checks import AgentCheck

class MyCheck(AgentCheck):
    def __init__(self, name, init_config, instances):
        super(MyCheck, self).__init__(name, init_config, instances)
```

The arguments that needs to be received and then passed to `super` are the following:

* `name` - the name of the check.
* `init_config` - the init\_config section of the configuration files
* `instances` - a one-element list that contains the instance options from the configuration file.

## Logging

The `self.log` field is a [Logger](https://docs.python.org/2/library/logging.html) instance that prints to the Agent's main log file. Log level can be set in the Agent config file `stackstate.yaml`

## Error handling

In the event of a wrong configuration, a runtime error or in any case when it can't work correctly, a Check should raise a significant exception. Exceptions are logged and being shown in the Agent status page to help diagnose problems.

The `warning` method is present to log a warning message and display it in the Agent's status page.

```text
self.warning("This will be visible in the status page")
```

Example of the error handling can be found [here](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L640).

