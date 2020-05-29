---
title: Agent Check Reference
kind: Documentation
---

# Checks in Agent v2

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

## Sending metrics

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

