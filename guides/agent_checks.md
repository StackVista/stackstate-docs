---
title: Writing checks for the API-Integration StackPack
kind: Documentation
listorder: 9
autotocdepth: 2
sidebar:
  nav:
    - header: Guide to Agent Checks
    - text: Overview
      href: "#overview"
    - text: Setup
      href: "#setup"
    - text: Agent Check Interface
      href: "#agent-check-Interface"
    - text: Configuration
      href: "#configuration"
    - text: Directory Structure
      href: "#directory-structure"
    - text: Your First Check
      href: "#your-first-check"
    - text: An HTTP Check
      href: "#an-http-check"
    - text: Troubleshooting
      href: "#troubleshooting"
    - text: Testing integrations
      href: "#testing-integrations"
---


<!--
======================================================
OVERVIEW
======================================================
-->

## Overview

This guide details how to collect metrics and events from a new data source
by writing an Agent Check, a Python plugin for the StackState API-Integration StackPack. We'll
look at the `AgentCheck` interface, and then write a simple Agent Check
that collects timing metrics and status events from HTTP services.

Any custom checks will be included in the main check run loop, meaning
they will run every check interval, which defaults to 15 seconds.


<!--
======================================================
SETUP
======================================================
-->

## Setup

First off, ensure you've properly
<a href="/integrations/">installed the API-Integration
StackPack</a> in StackState and the API-Integration agent component on your development machine.

<!--
======================================================
INTERFACE
======================================================
-->

## Agent Check Interface

All custom checks inherit from the `AgentCheck` class found in `checks/__init__.py`
and require a `check()` method that takes one argument, `instance` which is a
`dict` having the configuration of a particular instance. The `check` method is
run once per instance defined in the check configuration (discussed later).

### Sending metrics

Sending metrics in a check is easy.

You have the following methods available to you:

    self.gauge( ... ) # Sample a gauge metric

    self.increment( ... ) # Increment a counter metric

    self.decrement( ... ) # Decrement a counter metric

    self.histogram( ... ) # Sample a histogram metric

    self.rate( ... ) # Sample a point, with the rate calculated at the end of the check

    self.count( ... ) # Sample a raw count metric

    self.monotonic_count( ... ) # Sample an increasing counter metric

    self.raw( ... ) # Report a raw metric, no sampling is applied

All of these methods take the following arguments:

- `metric`: The name of the metric
- `value`: The value for the metric (defaults to 1 on increment, -1 on decrement)
- `tags`: (optional) A list of tags to associate with this metric.
- `hostname`: (optional) A hostname to associate with this metric. Defaults to the current host.
- `device_name`: (optional) A device name to associate with this metric.

These methods may be called from anywhere within your check logic. At the end of
your `check` function, all metrics that were submitted will be collected and
flushed out with the other Agent metrics.

### Sending events

At any time during your check, you can make a call to `self.event(...)` with one argument: the payload of the event. Your event should be structured like this:

    {
        "timestamp": int, the epoch timestamp for the event,
        "event_type": string, the event name,
        "api_key": string, the api key for your account,
        "msg_title": string, the title of the event,
        "msg_text": string, the text body of the event,
        "aggregation_key": string, a key to use for aggregating events,
        "alert_type": (optional) string, one of ('error', 'warning', 'success', 'info');
            defaults to 'info',
        "source_type_name": (optional) string, the source type name,
        "host": (optional) string, the name of the host,
        "tags": (optional) list, a list of tags to associate with this event
        "priority": (optional) string which specifies the priority of the event (Normal, Low)
    }

At the end of your check, all events will be collected and flushed with the rest
of the Agent payload.

### Sending service checks

Your custom check can also report the status of a service by calling the `self.service_check(...)` method.

The service_check method will accept the following arguments:

- `check_name`: The name of the service check.
- `status`: An integer describing the service status. You may also use the class status definitions:
  - `AgentCheck.OK` or `0` for success
  - `AgentCheck.WARNING` or `1` for warning
  - `AgentCheck.CRITICAL` or `2` for failure
  - `AgentCheck.UNKNOWN` or `3` for indeterminate status
- `tags`: (optional) A list of key:val tags for this check.
- `timestamp`: (optional) The POSIX timestamp when the check occured.
- `hostname`: (optional) The name of the host submitting the check. Defaults to the host_name of the agent.
- `check_run_id`: (optional) An integer ID used for logging and tracing purposes. The ID does not need to be unique. If an ID is not provided, one will automatically be generated.
- `message`: (optional) Additional information or a description of why this status occured.

### Sending components and relations

At any time during your check, you can make a call to `self.component(...)` with the following arguments:

- `instance_id`: dictionary, containing information on the topology source
- `id`: string, identifier of the component
- `type`: string, a component type classification
- `data`: (optional) arbitrary nesting of dictionaries and arrays with additional information

A second call `self.relation(...)` serves to push relation information to StackState. This call takes the following arguments:

- `instance_id`: dictionary, containing information on the topology source
- `source_id`: string, identifier of the source component
- `target_id`: string, identifier of the target component
- `type`: string, a component type classification
- `data`: (optional) arbitrary nesting of dictionaries and arrays with additional information

At the end of your check, all components and relations will be collected and flushed with the rest of the Agent payload.


### Sending components and relations in a snapshot

Components and relations can be sent as part of a snapshot. A snapshot represents the total state of some external
topology. By putting components and relations in a snapshot, StackState will persist all the topology elements
present in the snapshot, and remove everything else for the topology instance. Creating snapshots is facilitated by two
functions:

Starting a snapshot can be done with `self.start_snapshot(...)`, with the following argument:

- `instance_id`: dictionary, containing information on the topology source

Stopping a snapshot can be done with `self.stop_snapshot(...)`, with the following argument:

- `instance_id`: dictionary, containing information on the topology source


### Exceptions

If a check cannot run because of improper configuration, programming error or
because it could not collect any metrics, it should raise a meaningful exception.
This exception will be logged, as well as be shown in the Agent info command for
easy debugging. For example:

    $ sudo /etc/init.d/stackstate-agent info

      Checks
      ======

        my_custom_check
        ---------------
          - instance #0 [ERROR]: ConnectionError('Connection refused.',)
          - Collected 0 metrics & 0 events


### Logging

As part of the parent class, you're given a logger at `self.log`, so you can do
things like `self.log.info('hello')`. The log handler will be `checks.{name}`
where `{name}` is the name of your check (based on the filename of the check
module).

<!--
======================================================
CONFIGURATION
======================================================
-->

## Configuration

Each check will have a configuration file that will be placed in the `conf.d`
directory. Configuration is written using [YAML](http://www.yaml.org/). The
file name should match the name of the check module (e.g.: `haproxy.py` and
`haproxy.yaml`).

The configuration file has the following structure:

{{< highlight console >}}
init_config:
    min_collection_interval: 20
    key1: val1
    key2: val2

instances:
    - username: jon_smith
      password: 1234

    - username: jane_smith
      password: 5678
{{< /highlight >}}
`min_collection_interval` can be added to the init_config section to help define how often the check should be run. If it is greater than the interval time for the agent collector, a line will be added to the log stating that collection for this script was skipped. The default is `0` which means it will be collected at the same interval as the rest of the integrations on that agent. If the value is set to 30, it does not mean that the metric will be collected every 30 seconds, but rather that it could be collected as often as every 30 seconds. The collector runs every 15-20 seconds depending on how many integrations are enabled. If the interval on this agent happens to be every 20 seconds, then the agent will collect and include the agent check. The next time it collects 20 seconds later, it will see that 20 < 30 and not collect the custom agent check. The next time it will see that the time since last run was 40 which is greater than 30 and therefore the agent check will be collected.

<div class="alert alert-info">
YAML files must use spaces instead of tabs.</div>

### init_config

The *init_config* section allows you to have an arbitrary number of global
configuration options that will be available on every run of the check in
`self.init_config`.

### instances

The *instances* section is a list of instances that this check will be run
against. Your actual `check()` method is run once per instance. This means that
every check will support multiple instances out of the box.

<!--
======================================================
DIRECTORY STRUCTURE
======================================================
-->

## Directory Structure

Before starting your first check it is worth understanding the checks directory
structure. There are two places that you will need to add files for your check.
The first is the `checks.d` folder, which lives in your Agent root.

For all Linux systems, this means you will find it at:

    /etc/sts-agent/checks.d/

For Windows Server >= 2008 you'll find it at:

    C:\Program Files (x86)\StackState\Agent\checks.d\

    OR

    C:\Program Files\StackState\Agent\checks.d\


The other folder that you need to care about is `conf.d` which lives in the
Agent configuration root.

For Linux, you'll find it at:

    /etc/sts-agent/conf.d/

For Windows, you'll find it at:

    C:\ProgramData\StackState\conf.d\

    OR

    C:\Documents and Settings\All Users\Application Data\StackState\conf.d\


You can also add additional checks to a single directory, and point to it in `StackState.conf`:

    additional_checksd: /path/to/custom/checks.d/

<!--
======================================================
FIRST CHECK
======================================================
-->

## Your First Check

<div class="alert alert-warning">
The names of the configuration and check files must match. If your check
is called <code>mycheck.py</code> your configuration file <em>must</em> be
named <code>mycheck.yaml</code>.
</div>

To start off simple, we'll write a check that does nothing more than send a
value of 1 for the metric `hello.world`. The configuration file will be very
simple, including no real information. This will go into `conf.d/hello.yaml`:

{{< highlight console >}}
init_config:

instances:
    [{}]

{{< /highlight >}}

The check itself will inherit from `AgentCheck` and send a gauge of `1` for
`hello.world` on each call. This will go in `checks.d/hello.py`:

{{< highlight python >}}
from checks import AgentCheck
class HelloCheck(AgentCheck):
    def check(self, instance):
        self.gauge('hello.world', 1)

{{< /highlight >}}

As you can see, the check interface is really simple and easy to get started
with. In the next section we'll write a more useful check that will ping HTTP
services and return interesting data.


<!--
======================================================
HTTP CHECK
======================================================
-->

## An HTTP Check

Now we will guide you through the process of writing a basic check that will
check the status of an HTTP endpoint. On each run of the check, a GET
request will be made to the HTTP endpoint. Based on the response, one of the
following will happen:

  - If the response is successful (response is 200, no timeout) the response
  time will be submitted as a metric.
  - If the response times out, an event will be submitted with the URL and
  timeout.
  - If the response code != 200, an event will be submitted with the URL and
  the response code.

### Configuration

First we will want to define how our configuration should look, so that we know
how to handle the structure of the `instance` payload that is passed into the
call to `check`.

Besides just defining a URL per call, it'd be nice to allow you to set a timeout
for each URL. We'd also want to be able to configure a default timeout if no
timeout value is given for a particular URL.

So our final configuration would look something like this:

{{< highlight console >}}
init_config:
    default_timeout: 5

instances:
    -   url: https://google.com

    -   url: http://httpbin.org/delay/10
        timeout: 8

    -   url: http://httpbin.org/status/400

{{< /highlight >}}

### The Check

Now we can start defining our check method. The main part of the check will make
a request to the URL and time the response time, handling error cases as it goes.

In this snippet, we start a timer, make the GET request using the
[requests library](http://docs.python-requests.org/en/latest/) and handle and
errors that might arise.

{{< highlight python >}}
# Load values from the instance config
url = instance['url']
default_timeout = self.init_config.get('default_timeout', 5)
timeout = float(instance.get('timeout', default_timeout))

# Use a hash of the URL as an aggregation key
aggregation_key = md5(url).hexdigest()

# Check the URL
start_time = time.time()
try:
    r = requests.get(url, timeout=timeout)
    end_time = time.time()
except requests.exceptions.Timeout as e:
    # If there's a timeout
    self.timeout_event(url, timeout, aggregation_key)

if r.status_code != 200:
    self.status_code_event(url, r, aggregation_key)
{{< /highlight >}}

If the request passes, we want to submit the timing to StackState as a metric. Let's
call it `http.response_time` and tag it with the URL.

{{< highlight python >}}
timing = end_time - start_time
self.gauge('http.response_time', timing, tags=['http_check'])
{{< /highlight >}}

Finally, we'll want to define what happens in the error cases. We have already
seen that we call `self.timeout_event` in the case of a URL timeout and
we call `self.status_code_event` in the case of a bad status code. Let's
define those methods now.

First, we'll define `timeout_event`. Note that we want to aggregate all of these
events together based on the URL so we will define the aggregation_key as a hash
of the URL.

{{< highlight python >}}
def timeout_event(self, url, timeout, aggregation_key):
    self.event({
        'timestamp': int(time.time()),
        'event_type': 'http_check',
        'msg_title': 'URL timeout',
        'msg_text': '%s timed out after %s seconds.' % (url, timeout),
        'aggregation_key': aggregation_key
    })
{{< /highlight >}}


Next, we'll define `status_code_event` which looks very similar to the timeout
event method.

{{< highlight python >}}
def status_code_event(self, url, r, aggregation_key):
    self.event({
        'timestamp': int(time.time()),
        'event_type': 'http_check',
        'msg_title': 'Invalid response code for %s' % url,
        'msg_text': '%s returned a status of %s' % (url, r.status_code),
        'aggregation_key': aggregation_key
    })
{{< /highlight >}}

### Putting It All Together

For the last part of this guide, we'll show the entire check. This module would
be placed into the `checks.d` folder as `http.py`. The corresponding
configuration would be placed into the `conf.d` folder as `http.yaml`.

Once the check is in `checks.d`, you can test it by running it as a python
script. Restart the Agent for the changes to be enabled. **Make sure to change the conf.d path in the test method**. From your
Agent root, run:

    PYTHONPATH=. python checks.d/http.py

You'll see what metrics and events are being generated for each instance.

Here's the full source of the check:

{{< snippet-code-block file="guides-agentchecks-ex-all.py" nocomments="true" >}}

<!--
======================================================
Troubleshooting
======================================================
-->

## Troubleshooting

Custom Agent checks can't be directly called from python and instead
 need to be called by the agent. To test this, run:

    sudo -u sts-agent sts-agent check <CHECK_NAME>

If your issue continues, please reach out to Support with the help page that
 lists the paths it installs.

## Testing integrations

 Automated unit tests help ensure that your integration is working as designed and guard against regression.

 Though we don't require tests for each metric collected, we strongly encourage you to provide as much coverage as possible.

 ## Adding Tests

 Tests can be easily added by extending the `AgentCheckTest` class. Additionally, you may import Attributes from Nose to manage requirements.

 ~~~
 from nose.plugins.attrib import attr
 from tests.checks.common import AgentCheckTest

 @attr(requires='network')
 class HTTPCheckTest(AgentCheckTest)`
   ...
 ~~~

## The AgentCheckTest Class

 The following test methods are provided by the `AgentCheckTest` class. For more details about the class, please reference the [source code](https://github.com/StackVista/sts-agent/blob/master/tests/checks/common.py).

### Test and Check Status Methods

#### `coverage_report()`

 Prints the test coverage status of metrics, events, service checks and service metadata. Also lists items for each that lack test coverage.

#### `print_current_state()`

 Prints a report of the metrics, events, service checks, service metadata and warnings provided by the integration.


### Run Checks Methods

#### `run_check(config, agent_config=None, mocks=None, force_reload=False)`

 Parameters:


 * **config** (*dictionary*) – A check configuration dictionary containing an array of `instances`. For example:

 ~~~
 {
     'instances': [
         {
             'name': 'simple_config',
             'url': 'http://httpbin.org',
         }
     ]
 }
 ~~~


 * **agent_config** (*dictionary*) – A customized StackState agent configuration.
 * **mocks** (*dictionary*) – A dictionary keyed by method name (string) with values of method. For example:

 ~~~
 {
     'get_services_in_cluster': self.mock_get_services_in_cluster,
     'get_nodes_with_service': self.mock_get_nodes_with_service,
 }
 ~~~


 * **force_reload** (*boolean*) – Reload the check before running it.

#### `run_check_twice(config, agent_config=None, mocks=None, force_reload=False)`

 Similar to `run_check`, this method will run the check twice with a 1 second delay between runs.


#### `run_check_n(config, agent_config=None, mocks=None, force_reload=False, repeat=1, sleep=1)`

 Similar to `run_check`, this method will run the check multiple times.


 Parameters:


 * **repeat** (*integer*) – The number of times the check will run.
 * **sleep** (*integer*) – The delay in seconds between check runs.

### Metric Methods

#### `assertMetric(metric_name, value=None, tags=None, count=None, at_least=1, hostname=None, device_name=None, metric_type=None)`

 Parameters:


 * **metric_name** (*string*) – The name of the metric.
 * **value** (*variable*) – The value for the metric.
 * **tags** (*list of strings*) – The tags associated with the metric.
 * **count** (*integer*) – The number of candidate metrics the assertion should test for. Typical values are:
   * `None`: will not test for the count
   * `1`: tests for exactly one metric
   * `0`: tests for no matches (works as a negation)
 * **at_least** (*integer*) – The minimum number of candidate metrics the assertion should test for.
 * **hostname** (*string*) – The name of the host associated with the metric.
 * **device_name** (*string*) – The name of the device associated with the metric.
 * **metric_type** (*string*) – The type of metric to test for. If set, it must be one of `gauge`, `counter`, `rate`, or `count` as defined by the [checks metric types](https://github.com/StackVista/sts-agent/blob/master/checks/metric_types.py).

#### `assertMetricTagPrefix(metric_name, tag_prefix, count=None, at_least=1)`

 Parameters:


 * **metric_name** (*string*) – The name of the metric.
 * **tag_prefix** (*string*) – Match metrics with tags that begin with this string.
 * **count** (*integer*) – The number of data points the assertion should test for.
 * **at_least** (*integer*) – The minimum number of data points the assertion should test for.

#### `assertMetricTag(metric_name, tag, count=None, at_least=1)`

 Parameters:


 * **metric_name** (*string*) – The name of the metric.
 * **tag** (*string*) – The tag associated with the metric.
 * **count** (*integer*) – The number of data points the assertion should test for.
 * **at_least** (*integer*) – The minimum number of data points the assertion should test for.

### Service Methods

#### `assertServiceMetadata(meta_keys, count=None, at_least=1)`

 Parameters:


 * **meta_keys** (*list of strings*) – A list of metadata keys.
 * **count** (*integer*) – The number of candidate metrics the assertion should test for. Typical values are:
   * `None`: will not test for the count
   * `1`: tests for exactly one metric
   * `0`: tests for no matches (works as a negation)
 * **at_least** (*integer*) – The minimum number of candidate metrics the assertion should test for.

##### `assertServiceCheck(service_check_name, status=None, tags=None, count=None, at_least=1)`

##### `assertServiceCheckOK(service_check_name, tags=None, count=None, at_least=1)`

##### `assertServiceCheckWarning(service_check_name, tags=None, count=None, at_least=1)`

##### `assertServiceCheckCritical(service_check_name, tags=None, count=None, at_least=1)`

##### `assertServiceCheckUnknown(service_check_name, tags=None, count=None, at_least=1)`

 Parameters:


 * **service_check_name** (*string*) – The name of the service check.
 * **tags** (*list of strings*) – The tags associated with the service check.
 * **count** (*integer*) – The number of data points the assertion should test for.
 * **at_least** (*integer*) – The minimum number of data points the assertion should test for.


### Event Method

#### `assertEvent(msg_text, count=None, at_least=1, exact_match=True, tags=None, **kwargs)`

 Parameters:


 * **msg_text** (*string*) – The event message text.
 * **count** (*integer*) – The number of candidate metrics the assertion should test for. Typical values are:
   * `None`: will not test for the count
   * `1`: tests for exactly one metric
   * `0`: tests for no matches (works as a negation)
 * **at_least** (*integer*) – The minimum number of candidate metrics the assertion should test for.
 * **exact_match** (*boolean*) – When true, the event message text must equal `msg_text`. When false, the event message text must contain `msg_text`.
 * **tags** (*list of strings*) – The tags associated with the event.
 * **kwargs** – Keyword arguments can be used to match additional event attributes.

### Warning Method

#### `assertWarning(warning, count=None, at_least=1, exact_match=True)`

 Parameters:


 * **warning** (*string*) – The warning message text.
 * **count** (*integer*) – The number of candidate warnings the assertion should test for. Typical values are:
   * `None`: will not test for the count
   * `1`: tests for exactly one warning
   * `0`: tests for no matches (works as a negation)
 * **at_least** (*integer*) – The minimum number of candidate warnings the assertion should test for.
 * **exact_match** (*boolean*) – When true, the warning message text must equal `warning`. When false, the event message text must contain `warning`.

### Helper Methods

 The `AgentCheckTest` class provides some useful test methods that are not specifically related to StackState metrics and events.

#### `assertIn(first, second)`

#### `assertNotIn(first, second)`

 These methods test if the first argument is contained in the second argument using Python's `in` operator.

 Parameters:

 * **first** (*multiple types*) – The "needle" data.
 * **second** (*multiple types*) – The "haystack" data.

## Examples

### StackState Integrations

 For further examples of testing StackState integrations, you can view the test files for [core integrations](https://github.com/StackVista/sts-agent-integrations-core) such as the [`test_mysql.py` file](https://github.com/StackVista/sts-agent-integrations-core/blob/master/mysql/test_mysql.py) for the MySQL integration.

### StackState Agent Checks

 For examples of Agent Check tests, you can view the test files for agent checks such as [`test_http_check.py` file](https://github.com/StackVista/sts-agent-integrations-core/blob/master/http_check/test_http_check.py).
