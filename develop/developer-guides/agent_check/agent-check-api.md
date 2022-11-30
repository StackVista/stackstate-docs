---
description: StackState Self-hosted v5.1.x 
---

# Agent check API

## Overview

The Agent check API can be used to create checks that run on the [StackState Agent](../../../setup/agent/about-stackstate-agent.md). This page explains how to work with the Agent check API to write checks that send topology, metrics, events and service status information to StackState.

Code examples for the open source StackState Agent checks can be found on GitHub at: [https://github.com/StackVista/stackstate-agent-integrations](https://github.com/StackVista/stackstate-agent-integrations).

## Agent checks

From **Agent 2.18**, we've introduced [AgentChecksV2](https://github.com/StackVista/stackstate-agent-integrations/blob/master/stackstate_checks_base/stackstate_checks/base/checks/v2/base.py#L124) which has some key difference to historic Agent Checks. The key differences being:
- V2 Agent Check checks requires a return value in the form of a [CheckResponse](https://github.com/StackVista/stackstate-agent-integrations/blob/master/stackstate_checks_base/stackstate_checks/base/checks/v2/types.py#L8)
- V2 Agent Check includes two new check base classes:
  - [StatefulAgentCheck](https://github.com/StackVista/stackstate-agent-integrations/blob/master/stackstate_checks_base/stackstate_checks/base/checks/v2/stateful_agent_check.py#L8)
  - [TransactionalAgentCheck](https://github.com/StackVista/stackstate-agent-integrations/blob/master/stackstate_checks_base/stackstate_checks/base/checks/v2/transactional_agent_check.py#L8)


### Agent Check V2 (Agent 2.18+)
An Agent Check is a Python class that inherits from `AgentCheckV2` and implements the `check` method:

```text
from stackstate_checks.base.checks.v2.base import AgentCheckV2
from stackstate_checks.checks import CheckResponse

class MyCheck(AgentCheckV2):
    def check(self, instance): # type: (InstanceType) -> CheckResponse
        # Collect metrics and topologies, events, return CheckResponse
        return CheckResponse()

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```

#### Error Handling
In the event of a check error, the exception should be returned as part of the check response: 
```python
from stackstate_checks.base.checks.v2.base import AgentCheckV2
from stackstate_checks.checks import CheckResponse

class MyCheck(AgentCheckV2):
    def check(self, instance): # type: (InstanceType) -> CheckResponse
        # Collect metrics and topologies, events, return CheckResponse
        try:
          this_triggers_an_exception()
        except Exception as e:
          return CheckResponse(check_error=e)

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```


A more comprehensive example can be found in the [StackState Agent Integrations repo](https://github.com/StackVista/stackstate-agent-integrations/tree/master/agent_v2_integration_sample)

### StatefulAgentCheck (Agent 2.18+)
An Stateful Agent Check is a Python class that inherits from `StatefulAgentCheck` and implements the `stateful_check` method. This is intended to be used for agent checks that requires the ability to persist data across check runs and be available in the event of agent failure. If an agent failure occurs, the persisted state will be used in the next check run. **Persistent state is persisted even in the event of check failure.** The `StatefulAgentCheck` receives the current persistent state as an input parameter. The `persistent_state` parameter of the `CheckResponse` return type is then set as the new persistent state value. 

```text
from stackstate_checks.base.checks.v2.stateful_agent_check import StatefulAgentCheck
from stackstate_checks.checks import CheckResponse

class MyCheck(StatefulAgentCheck):
    def stateful_check(self, instance, persistent_state): # type: (InstanceType, StateType) -> CheckResponse
        # Collect metrics and topologies, events, return CheckResponse
        return CheckResponse(persistent_state=persistent_state)

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```

A more comprehensive example can be found in the [StackState Agent Integrations repo](https://github.com/StackVista/stackstate-agent-integrations/tree/master/agent_v2_integration_stateful_sample)

### TransactionalAgentCheck (Agent 2.18+)
An Transactional Agent Check is a Python class that inherits from `TransactionalAgentCheck` and implements the `transactional_check` method. This is intended to be used for agent checks that require transactional behavior for updating it's state. A Agent Check transaction is considered a success if the data submitted by the Agent Check reaches StackState. This enables checks to never process / submit data that has already been received by StackState. **Persistent state is persisted even in the event of check failure, while transactional state is only persistent once a transaction has succeeded.** The `TransactionalAgentCheck` receives the current transactional and persistent state as input parameters. The `transactional_state` and `persistent_state` parameters of the `CheckResponse` return type are then correspondingly set as the new state values.

```text
from stackstate_checks.base.checks.v2.transactional_agent_check import TransactionalAgentCheck
from stackstate_checks.checks import CheckResponse

class MyCheck(TransactionalAgentCheck):
    def transactional_check(self, instance, transactional_state, persistent_state):
        # type: (InstanceType, StateType, StateType) -> CheckResponse
        # Collect metrics and topologies, events, return CheckResponse
        return CheckResponse(transactional_state=transactional_state,  persistent_state=persistent_state)

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```

A more comprehensive example can be found in the [StackState Agent Integrations repo](https://github.com/StackVista/stackstate-agent-integrations/tree/master/agent_v2_integration_transactional_sample)


### Agent Check (To be deprecated)

An Agent Check is a Python class that inherits from `AgentCheck` and implements the `check` method:

```text
from stackstate_checks.checks import AgentCheck

class MyCheck(AgentCheck):
    def check(self, instance):
        # Collect metrics and topologies, emit events, submit service checks

    def get_instance_key(self, instance):
        # Provide an identifier (TopologyInstance)
```

### Agent Checks (all)
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

The `AgentCheck`, `AgentCheckV2`, `StatefulAgentCheck`, `TransactionalAgentCheck` class provides the following methods and attributes:

* `self.name` - a name of the check
* `self.init_config` - `init_config` that corresponds in the check configuration
* `self.log` - a [Python logger \(python.org\)](https://docs.python.org/2/library/logging.html)

## Scheduling

Multiple instances of the same check can run concurrently. If a check is already running, it isn't necessary to schedule another one.

## Send data

### Topology

Topology elements can be sent to StackState with the following methods:

* `self.component` - Create a component in StackState. See [send components](agent-check-api.md#send-components).
* `self.relation` - Create a relation between two components in StackState. See [send relations](agent-check-api.md#send-relations).
* `self.start_snapshot()` - Start a topology snapshot for a specific topology instance source.
* `self.stop_snapshot()` - Stop a topology snapshot for a specific topology instance source.

#### Send components

Components can be sent to StackState using the `self.component(id, type, data)` method.

{% tabs %}
{% tab title="Example - send a component" %}
```text
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
```text
self.relation(
        "nginx3.e5dda204-d1b2-11e6-a015-0242ac110005",   # source ID
        "nginx5.0df4bc1e-c695-4793-8aae-a30eba54c9d6",   # target ID
        "uses_service",  # type
        {})   # data
```
{% endtab %}
{% endtabs %}

The method requires the following details:

* **source\_id** - string. The source component externalId.
* **target\_id** - string. The target component externalId.
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
```text
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
```text
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

The `event-dict` is a valid [event JSON dictionary](/configure/telemetry/send_events.md#json-property-events).

{% hint style="info" %}
Note that `msg_title` and `msg_text` are required fields from Agent V2.11.0.
{% endhint %}

All events will be collected and flushed with the rest of the Agent payload at the end of the `check` function.

### Status (Agent Check only)

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

This will be fully deprecated in Agent Check V2 in favour of the `CheckResponse`.

### Health

Health information can be sent to StackState with the following methods:

* `self.health.check_state` - send a check state as part of a snapshot.
* `self.health.start_snapshot()` - start a health snapshot. Stackstate will only process health information if it is sent as part of a snapshot.
* `self.health.stop_snapshot()` -  stop the snapshot, signaling that all submitted data is complete. Do this at the end of the check after all data has been submitted. If exceptions occur in the check or not all data can be produced for some other reason, this function should not be called.

#### Set up a health stream

To make the `self.health` API available, override the `get_health_stream` function to define a URN identifier for the health synchronization stream.

{% tabs %}
{% tab title="Example - define a health stream" %}
```text
from stackstate_checks.base import AgentCheck, ConfigurationError, HealthStreamUrn, HealthStream

...

class ExampleCheck(AgentCheck):

...

    def get_health_stream(self, instance):
        if 'url' not in instance:
            raise ConfigurationError('Missing url in topology instance configuration.')
        instance_url = instance['url']
        return HealthStream(
          urn=HealthStreamUrn("example", instance_url),
          sub_stream=self.hostname
          repeat_interval_seconds=20
          expiry_seconds=60
        )

...
```
{% endtab %}
{% endtabs %}

The `HealthStream` class has the following options:

* **urn** - HealthStreamUrn. The stream urn under which the health information will be grouped.
* **sub\_stream** - string. Optional. Allows for separating disjoint data sources within a single health synchronization stream. For example, the data for the streams is reported separately from different hosts.
* **repeat\_interval\_seconds** - integer. Optional. The interval with which data will be repeated, defaults to `collection_interval` (`min_collection_interval` for Agent V2.14.x or earlier). Used by StackState to detect when data arrives later than expected.
* **expiry\_seconds** - integer. Optional. Remove all data from the stream or substream after this time. Set to '0' to disable expiry \(this is only possible when the `sub_stream` parameter is omitted\). Default 4\*`repeat_interval_seconds`.

For more information on urns, health synchronization streams, snapshots and how to debug, see [health Synchronization](../../../configure/health/health-synchronization.md).

#### Send check states

Components can be sent to StackState using the `self.component(id, type, data)` method.

{% tabs %}
{% tab title="Example - send a check state" %}
```text
from stackstate_checks.base import Health

...

self.health.check_state(
  check_state_id="check_state_from_example_1",
  name="Example check state",
  health_value=Health.CRITICAL,
  topology_element_identifier="urn:component/the_component_to_attach_to",
  message="Optional clarifying message"
)
```
{% endtab %}
{% endtabs %}

The method requires the following details:

* **check\_state\_id** - string. Uniquely identifies the check state within the \(sub\)stream.
* **name** - string. Display name for the health check state.
* **health\_value** - Health. The StackState health value, can be `CLEAR`, `DEVIATING` or `CRITICAL`.
* **topology\_element\_identifier** - string. The component or relation identifier that the check state should bind to. The check state will be associated with all components/relations that have the specified identifier.
* **message** - string. Optional. Extended message to display with the health state. Supports Markdown.

For an example of how to create a component, see the [StackState Static Health check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/static_health/stackstate_checks/static_health/static_health.py).

### Checks and streams

Streams and health checks can be sent to StackState together with a topology component. These can then be mapped together in StackState by a StackPack to give you telemetry streams and health states on your components.

All telemetry classes and methods can be imported from `stackstate_checks.base`. The following stream types can be added:

* [Metric stream](agent-check-api.md#metric-stream) - a metric stream and associated metric health checks.
* [Events stream](agent-check-api.md#events-stream) - a log stream with events and associated event health checks.
* [Service check stream](agent-check-api.md#service-check-stream) - a log stream with service check statuses for a specific integration and associated event health checks.

In the example below, a `MetricStream` is created on the metric `system.cpu.usage` with some conditions specific to a component. A health check \(check\) `maximum_average` is then created on this metric stream using `this_host_cpu_usage.identifier`. The stream and check are then added to the streams and checks list for the component `this-host`.

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
```text
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

* **name** - The name for the stream in StackState.
* **conditions** - A dictionary of key:value arguments that are used to filter the event values for the stream.

**Event stream health check**

Event stream health checks can optionally be mapped to an events stream using the stream identifier. The following event stream health checks are supported out of the box:

| Event stream health check | Description |
| :--- | :--- |
| **contains\_key\_value** | Checks that the last event contains \(at the top-level\), the specified value for a key. |
| **use\_tag\_as\_health** | Checks that returns the value of a tag in the event as the health state. |
| **custom\_health\_check** | This method provides the functionality to send in a custom event health check. |

For details see the [EventHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L24).

{% tabs %}
{% tab title="Example - event stream health check" %}
```text
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

An event stream health check includes the details listed below. Note that a custom\_health\_check only requires a **name** and **check\_arguments**:

* **stream\_id** - the identifier of the stream the check should run on.
* **name** - the name the check will have in StackState.
* **description** - the description for the check in StackState.
* **remediation\_hint** - the remediation hint to display when the check return a CRITICAL health state.
* **contains\_key** - for check `contains_key_value` only. The key that should be contained in the event.
* **contains\_value** - for check `contains_key_value` only. The value that should be contained in the event.
* **found\_health\_state** - for check `contains_key_value` only. The health state to return when this tag and value is found.
* **missing\_health\_state** - for check `contains_key_value` only. The health state to return when the tag/value is not found.
* **tag\_name** - for check `use_tag_as_health` only. The key of the tag that should be used as the health state.

For details see the [EventHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L24).

#### Metric stream

Metric streams can be added to a component using the `MetricStream` class.

{% tabs %}
{% tab title="Example - metric stream" %}
```text
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

* **name** - The name for the stream in StackState.
* **metricField** - The name of the metric to select.
* **conditions** - A dictionary of key:value arguments that are used to filter the metric values for the stream.
* **unit\_of\_measure** - Optional. The unit of measure for the metric points, it gets appended after the stream name: `name (unit_of_measure)`
* **aggregation** - Optional. sets the aggregation function for the metrics in StackState. See [aggregation methods](/use/metrics/add-telemetry-to-element.md#aggregation-methods).
* **priority** - Optional. The stream priority in StackState, one of `NONE`, `LOW`, `MEDIUM`, `HIGH`. HIGH priority streams are used for anomaly detection in StackState.

**Metric stream health check**

Metric stream health checks can optionally be mapped to a metric stream using the stream identifier. Note that some metric health checks require multiple streams for ratio calculations.

The following metric stream health checks are supported out of the box:

| Metric stream health check | Description |
| :--- | :--- |
| **maximum\_average** | Calculates the health state by comparing the average of all metric points in the time window against the configured maximum values. |
| **maximum\_last** | Calculates the health state only by comparing the last value in the time window against the configured maximum values. |
| **maximum\_percentile** | Calculates the health state by comparing the specified percentile of all metric points in the time window against the configured maximum values. For the median specify 50 for the percentile. The percentile parameter must be a value &gt; 0 and &lt;= 100. |
| **maximum\_ratio** | Calculates the ratio between the values of two streams and compares it against the critical and deviating value. If the ratio is larger than the specified critical or deviating value, the corresponding health state is returned. |
| **minimum\_average** | Calculates the health state by comparing the average of all metric points in the time window against the configured minimum values. |
| **minimum\_last** | Calculates the health state only by comparing the last value in the time window against the configured minimum values. |
| **minimum\_percentile** | Calculates the health state by comparing the specified percentile of all metric points in the time window against the configured minimum values. For the median specify 50 for the percentile. The percentile must be a value &gt; 0 and &lt;= 100. |
| **failed\_ratio** | Calculates the ratio between the last values of two streams \(one is the normal metric stream and one is the failed metric stream\). This ratio is compared against the deviating or critical value. |
| **custom\_health\_check** | Provides the functionality to send in a custom metric health check. |

For details see the [MetricHealthChecks class \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/1e8f59bdbe13749119172d6066c3660feed6c9a9/stackstate_checks_base/stackstate_checks/base/utils/telemetry.py#L105).

{% tabs %}
{% tab title="Example - metric health check" %}
```text
MetricHealthChecks.maximum_average(
        this_host_cpu_usage.identifier, # stream_id
        "Max CPU Usage (Average)",  # name
        75,   # deviating value
        90,   # critical value
        remediation_hint="Too much activity on host")
```
{% endtab %}
{% endtabs %}

A metric stream health check has the details listed below. Note that a custom\_health\_check only requires a **name** and **check\_arguments**:

* **name** - the name the health check will have in StackState.
* **description** - the description for the health check in StackState.
* **deviating\_value** - the threshold at which point the check will return a DEVIATING health state.
* **critical\_value** - the threshold at which point the check will return a CRITICAL health state.
* **remediation\_hint** - the remediation hint to display when the check returns a CRITICAL health state.
* **max\_window** - the max window size for the metrics.
* **percentile** - for `maximum_percentile` and `minimum_percentile` checks only. The percentile value to use for the calculation. 
* stream identifier\(s\):  
  * **stream\_id** - for `maximum_percentile`, `maximum_last`, `maximum_average`, `minimum_average`, `minimum_last`, `minimum_percentile` checks. The identifier of the stream the check should run on.
  * **denominator\_stream\_id** - for `maximum_ratio` checks only. The identifier of the denominator stream the check should run on.
  * **numerator\_stream\_id** - for `maximum_ratio` checks only. The identifier of the numerator stream the check should run on.
  * **success\_stream\_id** - for `failed_ratio` checks only. The identifier of the success stream this check should run on.
  * **failed\_stream\_id** - for `failed_ratio` checks only. The identifier of the failures stream this check should run on.

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
        `remediation_hint` the remediation hint to display when this check return a CRITICAL health state
        """
```

## Logging

The `self.log` field is a [Python logger \(python.org\)](https://docs.python.org/2/library/logging.html) instance that prints to the main Agent log file. The log level can be set in the Agent configuration file `stackstate.yaml`.

{% tabs %}
{% tab title="Example - logging" %}
```text
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

A check should raise a significant exception when it can't work correctly, for example due to a wrong configuration or runtime error. Exceptions are logged and shown in the Agent status page. The `warning` method can be used to log a warning message and display it on the Agent status page.

```text
self.warning("This will be visible in the status page")
```

{% tabs %}
{% tab title="Example - warning message" %}
```text
if len(queries) > max_custom_queries:
    self.warning("Max number (%s) of custom queries reached. Skipping the rest."
                 % max_custom_queries)
```
{% endtab %}
{% endtabs %}

Example taken from the [StackState MySQL Agent check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/blob/master/mysql/stackstate_checks/mysql/mysql.py#L640).

## See also

* [Connect an Agent check with StackState using the Custom Synchronization StackPack](connect_agent_check_with_stackstate.md)
* [Agent check state](agent-check-state.md)
* [How to develop Agent checks](how_to_develop_agent_checks.md)
* [Developer guide - Custom Synchronization StackPack](../custom_synchronization_stackpack/)

