# Agent check API

## Overview

The Agent check API can be used to create checks that run on the [StackState Agent](/stackpacks/integrations/agent.md). This page explains how to work with the Agent check API to write checks that send topology, metrics, events and service status information to StackState.

Code examples for the open source StackState Agent checks can be found on GitHub at: [https://github.com/StackVista/stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations).

## Agent checks

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

Here is an example of the [config file \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/data/conf.yaml.example).

Any mapping provided in `instances` is passed to the `check` method using the declared `instance` value.

The `AgentCheck` class provides the following methods and attributes:

* `self.name` - a name of the check
* `self.init_config` - `init_config` that corresponds in the check configuration
* `self.log` - a [logger \(python.org\)](https://docs.python.org/2/library/logging.html)

## Scheduling

Multiple instances of the same check can run concurrently. If a check is already running, it is not necessary to schedule another one.

## Send data

### Topology

Topology is sent by calling the following methods:

```text
self.component(id, type, data):                     
# Creates a component within StackState

self.relation(source_id, target_id, type, data):    
# Creates a relation between two components to StackState

self.start_snapshot():                              
# Start a topology snapshot for a specific topology instance source

self.stop_snapshot():                               
# Stop a topology snapshot for a specific topology instance source
```

The above methods can be called from anywhere in the check. The `data` field within the `self.component` and `self.relation` function represent a dictionary. The fields within this object can be referenced in the `ComponentTemplateFunction` and the `RelationTemplateFunction` within StackState.

An example of usage of `self.component` can be found in the [MySQL topology check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L349).

All submitted topologies are collected by StackState and flushed together with all the other Agent metrics at the end of `check` function.

### Metrics

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

### Events

Sending events is handled by calling `self.event(event_dict)` method. This method can be called from anywhere in the check. 

```
self.event({
    "timestamp": int(time.time()),
    "source_type_name": "my system",
    "msg_title": "Status update for host: {0}".format(self.host),
    "msg_text": "An event happened on host: {0}".format(self.host),
    "host": self.host,
    "tags": [
        "status:success",
        "host:{0}".format(self.host)
    ]
})
```

The `event-dict` is a dictionary with the following keys and data types:

* **timestamp** - int. The epoch timestamp for the event.
* **event_type** - string. The event name.
* **api_key** - string. The api key for your account.
* **msg_title** - string. The title of the event.
* **msg_text** - string. The text body of the event.
* **aggregation_key** - string. A key to use for aggregating events.
* **context** - dict (optional). ???  
* **alert_type** - string (optional). One of ('error', 'warning', 'success', 'info'), defaults to 'info'.
* **source_type_name** - string (optional). The source type name.
* **host** - string (optional). The name of the host.
* **tags** - list (optional). A list of tags to associate with this event.
* **priority** - string (optional). The priority of the event ("normal" or "low").


All events will be collected and flushed with the rest of the Agent payload at the end of the `check` function.

### Status

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


### Checks and streams

Streams and health checks can be sent to StackState together with a topology component. These will then be mapped together in StackState to give you telemetry streams and health states on your components. 

All telemetry classes and methods can be imported from `stackstate_checks.base`. The fo.llowing stream types can be added:

* [Metric stream](#metric-stream) - a metric stream and associated metric health checks.
* [Events stream](#events-stream) - a log stream with events and associated event health checks.
* [Service check stream](#service-check-stream) - ???.

In the example below, a `MetricStream` is created on the metric `system.cpu.usage` with some conditions specific to a component. A health check (check) `maximum_average` is then created on this metric stream using `this_host_cpu_usage.identifier`. The stream and check are then added to the streams and checks list for the component `this-host`.

{% tabs %}
{% tab title="Example metric stream with metric health check" %}
```text
this_host_cpu_usage = MetricStream(
                        "Host CPU Usage", 
                        "system.cpu.usage",
                        conditions={
                            "tags.hostname": "this-host", 
                            "tags.region": "eu-west-1"
                            },
                        unit_of_measure="Percentage",
                        aggregation="MEAN",
                        priority="HIGH"
                        )

cpu_max_average_check = MetricHealthChecks.maximum_average(
                          this_host_cpu_usage.identifier,
                          "Max CPU Usage (Average)", 
                          75, 
                          90,
                          remediation_hint="Too much activity, add another host"
                          )

self.component(
  "urn:example:/host:this_host", 
  "Host",
  data={
      "name": "this-host",
      "domain": "Webshop",
      "layer": "Machines",
      "identifiers": ["urn:host:/this-host-fqdn"],
      "labels": ["host:this_host", "region:eu-west-1"],
      "environment": "Production"
      },
  streams=[this_host_cpu_usage],
  checks=[cpu_max_average_check]
  )
```
{% endtab %}
{% endtabs %}

#### Events stream

Log streams containing events can be added to a component using the `EventStream` class. 

{% tabs %}
{% tab title="Example events stream" %}
```
this_host_events = EventStream(
                    "Host events stream", # name
                    conditions={
                      "key1": "value1", 
                      "key2": "value2"
                      },
                    )
```
{% endtab %}
{% endtabs %}


Each events stream has the following details:

  - **name** - The name for the stream in StackState.
  - **conditions** - A dictionary of key:value arguments that are used to filter the event values for the stream.

##### Event stream health check

Event stream health checks can optionally be mapped to an events stream using the stream identifier. The following event stream health checks are supported out of the box:

| Event stream health check | Description |
|:---|:---|
| **contains_key_value** | Checks that the last event contains (at the top-level), the specified value for a key. |
| **use_tag_as_health** | Checks that returns the value of a tag in the event as the health state. |
| **custom_health_check** | This method provides the functionality to send in a custom event health check. |

For details see the [EventHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L24).

{% tabs %}
{% tab title="Example event stream health check" %}
```
cpu_max_average_check = EventHealthChecks.contains_key_value(
                          "this_host_events",           # stream_id
                          "Events on this host",        # name
                          75,                           # contains_key
                          90,                           # contains_value
                          "CRITICAL"                    # found_health_state
                          "CLEAR"                       # missing_health_state
                          remediation_hint="Bad event found!"
                          )
```
{% endtab %}
{% endtabs %}

An event stream health check includes the details listed below. Note that a custom_health_check only requires a **name** and **check_arguments**:

* **stream_id** - the identifier of the stream the check should run on.
* **name** - the name the check will have in StackState.
* **description** - the description for the check in StackState.
* **remediation_hint** - the remediation hint to display when the check return a critical health state.
* **contains_key** - for check `contains_key_value` only. The key that should be contained in the event.
* **contains_value** - for check `contains_key_value` only. The value that should be contained in the event.
* **found_health_state** - for check `contains_key_value` only. The health state to return when this tag and value is found.
* **missing_health_state** - for check `contains_key_value` only. The health state to return when the tag/value is not found.
* **tag_name** - for check `use_tag_as_health` only. The key of the tag that should be used as the health state.

For details see the [EventHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L24).

#### Metric stream

Metric streams can be added to a component using the `MetricStream` class. 

{% tabs %}
{% tab title="Example metric stream" %}
```
this_host_cpu_usage = MetricStream(
                        "Host CPU Usage", # name
                        "system.cpu.usage", # metricField
                        conditions={
                            "tags.hostname": "this-host", 
                            "tags.region": "eu-west-1"
                            },
                        unit_of_measure="Percentage",
                        aggregation="MEAN",
                        priority="HIGH"
                        )
```
{% endtab %}
{% endtabs %}

Each metric stream has the following details:

  - **name** - The name for the stream in StackState.
  - **metricField** - The name of the metric to select.
  - **conditions** - A dictionary of key:value arguments that are used to filter the metric values for the stream.
  - **unit_of_measure** - Optional. The unit of measure for the metric points, it gets appended after the stream name: `name (unit_of_measure)`
  - **aggregation** - Optional. sets the aggregation function for the metrics in StackState. See [aggregation methods](/develop/reference/scripting/script-apis/telemetry.md#aggregation-methods).
  - **priority** - Optional. The stream priority in StackState, one of `NONE`, `LOW`, `MEDIUM`, `HIGH`. HIGH priority streams are used for anomaly detection in StackState.

##### Metric stream health check

Metric stream health checks can optionally be mapped to a metric stream using the stream identifier. Note that some metric health checks require multiple streams for ratio calculations.

The following metric stream health checks are supported out of the box:

| Metric stream health check | Description |
|:---|:---|
| **maximum_average** | Calculates the health state by comparing the average of all metric points in the time window against the configured maximum values. |
| **maximum_last** | Calculates the health state only by comparing the last value in the time window against the configured maximum values. |
| **maximum_percentile** | Calculates the health state by comparing the specified percentile of all metric points in the time window against the configured maximum values. For the median specify 50 for the percentile. The percentile parameter must be a value > 0 and <= 100. |
| **maximum_ratio** | Calculates the ratio between the values of two streams and compares it against the critical and deviating value. If the ratio is larger than the specified critical or deviating value, the corresponding health state is returned. |
| **minimum_average** | Calculates the health state by comparing the average of all metric points in the time window against the configured minimum values. |
| **minimum_last** | Calculates the health state only by comparing the last value in the time window against the configured minimum values. |
| **minimum_percentile** | Calculates the health state by comparing the specified percentile of all metric points in the time window against the configured minimum values. For the median specify 50 for the percentile. The percentile must be a value > 0 and <= 100. |
| **failed_ratio** | Calculates the ratio between the last values of two streams (one is the normal metric stream and one is the failed metric stream). This ratio is compared against the deviating or critical value. |
| **custom_health_check** | Provides the functionality to send in a custom metric health check. |

For details see the [MetricHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L105).

{% tabs %}
{% tab title="Example metric health check" %}
```
cpu_max_average_check = MetricHealthChecks.maximum_average(
                          this_host_cpu_usage.identifier, # stream_id
                          "Max CPU Usage (Average)",      # name
                          75,                             # deviating value
                          90,                             # critical value
                          remediation_hint="Too much activity on this host"
                          )
```
{% endtab %}
{% endtabs %}

A metric stream health check has the details listed below. Note that a custom_health_check only requires a **name** and **check_arguments**:

* **name** - the name the health check will have in StackState.
* **description** - the description for the health check in StackState.
* **deviating_value** - the threshold at which point the check will return a deviating health state.
* **critical_value** - the threshold at which point the check will return a critical health state.
* **remediation_hint** - the remediation hint to display when the check returns a critical health state.
* **max_window** - the max window size for the metrics.
* **percentile** - for `maximum_percentile` and `minimum_percentile` checks only. The percentile value to use for the calculation. 
* stream identifier(s):  
  * **stream_id** - for `maximum_percentile`, `maximum_last`, `maximum_average`, `minimum_average`, `minimum_last`, `minimum_percentile` checks. The identifier of the stream the check should run on.
  * **denominator_stream_id** - for `maximum_ratio` checks only. The identifier of the denominator stream the check should run on.
  * **numerator_stream_id** - for `maximum_ratio` checks only. The identifier of the numerator stream the check should run on.
  * **success_stream_id** - for `failed_ratio` checks only. The identifier of the success stream this check should run on.
  * **failed_stream_id** - for `failed_ratio` checks only. The identifier of the failures stream this check should run on.

For details see the [MetricHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L105).
  
#### Service check stream

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



## Override base class methods

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

The `self.log` field is a [Python logger \(python.org\)](https://docs.python.org/2/library/logging.html) instance that prints to the main Agent log file. The log level can be set in the Agent configuration file `stackstate.yaml`.

{% tabs %}
{% tab title="Example logging" %}
```buildoutcfg
def _collect_type(self, key, mapping, the_type):
    self.log.debug("Collecting data with %s" % key)
    if key not in mapping:
        self.log.debug("%s returned None" % key)
        return None
    self.log.debug("Collecting done, value %s" % mapping[key])
    return the_type(mapping[key])
```
{% endtab %}
{% endtabs %}

Example taken from the [StackState MySQL Agent check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L731).

## Error handling

A check should raise a significant exception when it cannot work correctly, for example due to a wrong configuration or runtime error. Exceptions are logged and shown in the Agent status page. The `warning` method can be used to log a warning message and display it on the Agent status page.

```text
self.warning("This will be visible in the status page")
```

{% tabs %}
{% tab title="Example warning message" %}
```buildoutcfg
if len(queries) > max_custom_queries:
    self.warning("Max number (%s) of custom queries reached. Skipping the rest."
                 % max_custom_queries)
```
{% endtab %}
{% endtabs %}

Example taken from the [StackState MySQL Agent check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L640).

