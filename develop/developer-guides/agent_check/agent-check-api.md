# Agent check API

{% hint style="warning" %}
**This page describes StackState version 4.3.**

The StackState 4.3 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.3 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The Agent check API can be used to create checks that run on the [StackState Agent](/stackpacks/integrations/agent.md). This page explains how to work with the Agent check API to write checks that send topology, metrics, events and service status information to StackState.

Code examples for the open source StackState Agent checks can be found on GitHub at: [https://github.com/StackVista/stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations).

## Agent checks

An Agent Check is a Python class that inherits from `AgentCheck` and implements the `check` method:

```text
from stackstate_checks.checks import AgentCheck

class MyCheck(AgentCheck):
    def check(self, instance):
        # Collect metrics and topologies, emit events, submit service checks

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```

The Agent creates an object of type `MyCheck` for each element contained in the `instances` sequence of the corresponding Agent Check configuration file:

```text
instances:
  - host: localhost
    port: 6379

  - host: example.com
    port: 6379
```

{% hint style="info" %}
See the [example Agent check configuration file \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/data/conf.yaml.example).
{% endhint %}

All mapping included in the `instances` section of the Agent Check configuration file is passed to the `check` method using the declared `instance` value.

The `AgentCheck` class provides the following methods and attributes:

* `self.name` - a name of the check
* `self.init_config` - `init_config` that corresponds in the check configuration
* `self.log` - a [Python logger \(python.org\)](https://docs.python.org/2/library/logging.html)

## Scheduling

Multiple instances of the same check can run concurrently. If a check is already running, it is not necessary to schedule another one.

## Send data

### Topology

Topology elements can be sent to StackState with the following methods:

* `self.component` - Create a component in StackState. See [send components](#send-components).
* `self.relation` - Create a relation between two components in StackState.  See [send relations](#send-relations).
* `self.start_snapshot()` - Start a topology snapshot for a specific topology instance source.
* `self.stop_snapshot()` - Stop a topology snapshot for a specific topology instance source.

#### Send components

Components can be sent to StackState using the `self.component(id, type, data)` method. 

{% tabs %}
{% tab title="Example - send a component" %}
```
self.component(
        "urn:example:/host:this_host", # the ID
        "Host", # the type
        data={
            "name": "this-host",
            "domain": "Webshop",
            "layer": "Machines",
            "identifiers": ["urn:host:/this-host-fqdn"],
            "labels": ["host:this_host", "region:eu-west-1"],
            "environment": "Production"
            })
```
{% endtab %}
{% endtabs %}

The method requires the following details:

* **id** - string. A unique ID for this component. This has to be unique for this instance.
* **type** - string. A named parameter for this type.
* **data** - dictionary. A JSON blob of arbitrary data. The fields within this object can be referenced in the `ComponentTemplateFunction` and the `RelationTemplateFunction` within StackState.

See the example of creating a component in StackState in the [StackState MySQL check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L349).

All submitted topologies are collected by StackState and flushed together with all the other Agent metrics at the end of `check` function.

#### Send relations

Relations can be sent to StackState using the `self.relation(source_id, target_id, type, data)` method. 

{% tabs %}
{% tab title="Example - send a relation" %}
```
self.relation(
        "nginx3.e5dda204-d1b2-11e6-a015-0242ac110005",   # source ID
        "nginx5.0df4bc1e-c695-4793-8aae-a30eba54c9d6",   # target ID
        "uses_service",  # type
        {})   # data
```
{% endtab %}
{% endtabs %}

The method requires the following details:

* **source_id** - string. The source component externalId.
* **target_id** - string. The target component externalId.
* **type** - string. The type of relation.
* **data** - dictionary. A JSON blob of arbitrary data. The fields within this object can be referenced in the `ComponentTemplateFunction` and the `RelationTemplateFunction` within StackState.

See the example of creating a relation in StackState in the [StackState SAP check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/sap/stackstate_checks/sap/sap.py#L124).

All submitted topologies are collected by StackState and flushed together with all the other Agent metrics at the end of `check` function.

### Metrics

Metrics can be sent to StackState with the following methods:

* `self.gauge` - Sample a gauge metric.
* `self.count` - Sample a raw count metric.
* `self.rate` - Sample a point, with the rate calculated at the end of the check.
* `self.increment` - Increment a counter metric.
* `self.decrement` - Decrement a counter metric.
* `self.histogram` - Sample a histogram metric.
* `self.historate` - Sample a histogram based on rate metrics.
* `self.monotonic_count` - Sample an increasing counter metric.

{% tabs %}
{% tab title="Example - send a gauge metric" %}
```
self.gauge(
        "test.metric", # the metric name
        10.0, # value of the metric
        "tags": [ 
          "tag_key1:tag_value1",
          "tag_key2:tag_value2"
          ],
        "localdocker.test") # the hostname
```
{% endtab %}
{% endtabs %}

Each method accepts the following metric details:

* **name** - the name of the metric.
* **value** - the value for the metric. Defaults to 1 on increment, -1 on decrement.
* **tags** - optional. A list of tags to associate with this metric.
* **hostname** - optional. A hostname to associate with this metric. Defaults to the current host.

All submitted metrics are collected and flushed with all the other Agent metrics at the end of `check` function.

Check the example to send metrics in the [StackState MySQL check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L655).

### Events

Events can be sent to StackState with the `self.event(event_dict)` method. 

{% tabs %}
{% tab title="Example - send an event" %}
```
self.event(  
        {
        "context": {
          "category": "Changes",
          "data": { 
            "data_key1":"data_value1",
            "data_key2":"data_value2"
          },
          "element_identifiers": [
            "element_identifier1",
            "element_identifier2"
            ],
          "source": "source_system",
          "source_links": [
            {
              "title": "link_title",
              "url": "link_url"
              }
            ]
          },    
        "event_type": "event_typeEvent",
        "msg_title": "event_title",
        "msg_text": "event_text",
        "source_type_name": "source_event_type",
        "tags": [
          "tag_key1:tag_value1",
          "tag_key2:tag_value2",
          ],
        "timestamp": 1607432944
        })
```
{% endtab %}
{% endtabs %}

The `event-dict` is a valid [event JSON dictionary](/configure/telemetry/send_telemetry.md#event-json). 

{% hint style="info" %}
Note that `msg_title` and `msg_text` are required fields from Agent v2.11.0.
{% endhint %}

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

Streams and health checks can be sent to StackState together with a topology component. These can then be mapped together in StackState by a StackPack to give you telemetry streams and health states on your components. 

All telemetry classes and methods can be imported from `stackstate_checks.base`. The following stream types can be added:

* [Metric stream](#metric-stream) - a metric stream and associated metric health checks.
* [Events stream](#events-stream) - a log stream with events and associated event health checks.
* [Service check stream](#service-check-stream) - a log stream with service check statuses for a specific integration and associated event health checks.

In the example below, a `MetricStream` is created on the metric `system.cpu.usage` with some conditions specific to a component. A health check (check) `maximum_average` is then created on this metric stream using `this_host_cpu_usage.identifier`. The stream and check are then added to the streams and checks list for the component `this-host`.

{% tabs %}
{% tab title="Example - metric stream with metric health check" %}
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
                              priority="HIGH")

cpu_max_average_check = MetricHealthChecks.maximum_average(
                                this_host_cpu_usage.identifier,
                                "Max CPU Usage (Average)", 
                                75, 
                                90,
                                remediation_hint="Too much activity")

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
        checks=[cpu_max_average_check])
```
{% endtab %}
{% endtabs %}

#### Events stream

Log streams containing events can be added to a component using the `EventStream` class. 

{% tabs %}
{% tab title="Example - events stream" %}
```
EventStream(
        "Host events stream", # name
        conditions={
          "key1": "value1", 
          "key2": "value2"
          })
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
{% tab title="Example - event stream health check" %}
```
EventHealthChecks.contains_key_value(
        "this_host_events",   # stream_id
        "Events on this host",  # name
          75,   # contains_key
          90,   # contains_value
          "CRITICAL"  # health state when key found
          "CLEAR"   # health state when key not found
          remediation_hint="Bad event found!")
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
{% tab title="Example - metric stream" %}
```
MetricStream(
        "Host CPU Usage", # name
        "system.cpu.usage", # metricField
        conditions={
            "tags.hostname": "this-host", 
            "tags.region": "eu-west-1"
            },
        unit_of_measure="Percentage",
        aggregation="MEAN",
        priority="HIGH")
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
{% tab title="Example - metric health check" %}
```
MetricHealthChecks.maximum_average(
        this_host_cpu_usage.identifier, # stream_id
        "Max CPU Usage (Average)",  # name
        75,   # deviating value
        90,   # critical value
        remediation_hint="Too much activity on host")
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

{% hint style="info" %}
Depending on the configuration used, overriding the `__init__` constructor may cause the Agent to create several check instances, each calling the method.
{% endhint %}

The best practice recommendation is not to override anything from the base class, except the check method. However, sometimes it might be useful for a check to have its own constructor. In such cases, the `__init__` constructor can be overridden with **\_\_init\_\_** method using the following convention:

```text
from stackstate_checks.checks import AgentCheck

class MyCheck(AgentCheck):
    def __init__(self, name, init_config, instances):
        super(MyCheck, self).__init__(name, init_config, instances)
```

The following arguments are required to pass to `super`:

* **name** - the name of the check.
* **init_config** - the `init_config` section of the configuration files.
* **instances** - a one-element list that contains the instance options from the configuration file.

## Logging

The `self.log` field is a [Python logger \(python.org\)](https://docs.python.org/2/library/logging.html) instance that prints to the main Agent log file. The log level can be set in the Agent configuration file `stackstate.yaml`.

{% tabs %}
{% tab title="Example - logging" %}
```
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
{% tab title="Example - warning message" %}
```
if len(queries) > max_custom_queries:
    self.warning("Max number (%s) of custom queries reached. Skipping the rest."
                 % max_custom_queries)
```
{% endtab %}
{% endtabs %}

Example taken from the [StackState MySQL Agent check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L640).

## See also

* [Connect an Agent check with StackState using the Custom Synchronization StackPack](/develop/developer-guides/agent_check/connect_agent_check_with_stackstate.md)
* [How to develop Agent checks](/develop/developer-guides/agent_check/how_to_develop_agent_checks.md)
* [Developer guide - Custom Synchronization StackPack](/develop/developer-guides/custom_synchronization_stackpack)
