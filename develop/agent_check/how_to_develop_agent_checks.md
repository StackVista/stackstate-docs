---
title: How to develop agent checks
kind: Documentation
---

This document covers how to create your first check with Agent v2 Check API. Following topics are covered in this document: the agent directory structure, configuring your check, writing your first check, sending topology, metrics, events, and service checks as well as how to add external python dependencies and putting it all together.

## Installing Agent v2 StackPack

To install this StackPack navigate to StackState’s StackPacks page using left menu pane and locate the “StackState Agent V2” section. Click on the Agent V2 icon and this opens the installation page. Click on "Install" button and follow installation instructions provided by the StackPack.

## Directory Structure

Before starting your first check it is worth understanding the checks directory structure. There are two places that you will need to add files for your check. The first is the `checks.d` folder, which lives in your Agent root.

For all Linux systems, you should find it at:

    /etc/stackstate-agent/checks.d/

For Windows Server >= 2008 you should find it at:

    C:\Program Files (x86)\StackState\StackState Agent\checks.d\

    OR

    C:\Program Files\StackState\StackState Agent\checks.d\


The configuration folder is `conf.d` which also lives in your Agent root.

For Linux, you should find it at:

    /etc/stackstate-agent/conf.d/

For Windows, you should find it at:

    C:\ProgramData\StackState\StackState Agent\conf.d\

    OR

    C:\Documents and Settings\All Users\Application Data\StackState\StackState Agent\conf.d\


You can also add additional checks to a single directory, and point to it in `StackState.yaml`:

    additional_checksd: /path/to/custom/checks.d/

For the remainder of this document these paths will be referred to as `checks.d` and `conf.d`.

## Check Configuration

Each check has a configuration directory and file that will be placed in the `conf.d` directory. Configuration is written using [YAML](http://www.yaml.org/). The folder name should match the name of the check (e.g.: `example.py` and `example.d` containing the `conf.yaml` configuration file). We will be using the StackState "Skeleton" / bare essentials check and configuration as a starting point.

The configuration file for the "Skeleton" check has the following structure:

```
init_config:
    min_collection_interval: 30 # the collection interval in seconds. This check will runs once every 30 seconds

instances:
  - url: "some_url"
    authentication:
      username:
      password:
```

<div class="alert alert-info">
YAML files must use spaces instead of tabs.
</div>

### init_config

The *init_config* section allows you to have an arbitrary number of global configuration options that will be available on every run of the check in `self.init_config`.

`min_collection_interval` can be added to the init_config section to help define how often the check should be run. If the value is set to 30, it means that this check will be scheduled for collection every 30 seconds. However due to the execution model of the StackState Agent, this is not a guarantee that the check will run every 30 seconds which is why it is referred to as being the minimum collection interval between two executions.

The default is `30`, if no `min_collection_interval` is specified.

### instances

The *instances* section is a list of instances that this check will be run against. Your `check(...)` method is run once per instance. This means that every check will support multiple instances out of the box. The check instance is an object that should contain all configuration items needed to monitor a specific instance. An instance is passed into the execution of the `check` function in the `instance` parameter.

To synchronize multiple instances in StackState you have to create a multi-tenant StackPack (documentation not yet available).

### Setting up your check configuration

You can now take the following configuration:

```
init_config:
    min_collection_interval: 30 # the collection interval in seconds. This check will runs once every 30 seconds

instances:
  - url: "some_url"
    authentication:
      username:
      password:
```
and place it in the `conf.d` directory. In `conf.d` create a directory named `{your_check_name}.d` and place the above configuration inside a file named: `conf.yaml`. Save that file in the `{your_check_name}.d` directory.

## First Check

Now you can start defining your first check. The following "Skeleton" check can be used as a good starting point:

```
from stackstate_checks.base import AgentCheck, ConfigurationError, TopologyInstance

class ExampleCheck(AgentCheck):
    def __init__(self, name, init_config, agentConfig, instances=None):
        AgentCheck.__init__(self, name, init_config, agentConfig, instances)

    def get_instance_key(self, instance):
        if 'url' not in instance:
            raise ConfigurationError('Missing url in topology instance configuration.')

        instance_url = instance['url']
        return TopologyInstance("example", instance_url)

    def check(self, instance):
        self.log.debug("starting check for instance: %s" % instance)
        self.start_snapshot()

        self.stop_snapshot()
        self.log.debug("successfully ran check for instance: %s" % instance)


```

### Setting up your check

You can now take the "Skeleton" Check snippet given above and save inside a file named: `{your_check_name}.py` in the `checks.d` directory.

### Load values from the instance config

Values can be loaded from the instance config object in the following ways:

```
# gets the value of the `url` property
url = instance['url']
# gets the value of the `default_timeout` property or defaults to 5
default_timeout = self.init_config.get('default_timeout', 5)
# gets the value of the `timeout` property or defaults `default_timeout` and casts it to a float data type
timeout = float(instance.get('timeout', default_timeout))
```

### StackState Snapshots

Components and relations can be sent as part of a snapshot. A snapshot represents the total state of some external topology. By putting components and relations in a snapshot, StackState will persist all the topology elements present in the snapshot, and remove everything else for the topology instance. Creating snapshots is facilitated by two functions:

Starting a snapshot can be done with `self.start_snapshot()`. Internally the `AgentCheck` interface uses the `get_instance_key` function to uniquely identify this topology instance.

Stopping a snapshot can be done with `self.stop_snapshot()`. This should be done at the end of the check, after all data has been submitted.

These are already in place in the StackState "Skeleton" check.

### Sending Topology

Topology data can be submitted using the `self.component()` and `self.relation()` functions in the `AgentCheck` interface. The example below shows how to submit two components with a relation between them:

```
self.component("urn:example/host:this_host", "Host", {
    "name": "this-host",
    "domain": "Webshop",
    "layer": "Hosts",
    "identifiers": ["another_identifier_for_this_host"],
    "labels": ["host:this_host", "region:eu-west-1"],
    "environment": "Production"
})

self.component("urn:example/application:some_application", "Application", {
    "name": "some-application",
    "domain": "Webshop",
    "layer": "Applications",
    "identifiers": ["another_identifier_for_some_application"],
    "labels": ["application:some_application", "region:eu-west-1", "hosted_on:this-host"],
    "environment": "Production",
    "version": "0.2.0"
})

self.relation("urn:example/application:some_application", "urn:example/host:this_host", "IS_HOSTED_ON", {})
```

This creates two components in StackState. One for the `this-host` and one for `some-application`. The `domain` value is used in the horizontal grouping of the components in StackState and `layer` is used for vertical grouping. The `labels` and `environment` add some metadata to the component and can also be used for filtering in StackState. The identifiers and the external identifier e.g. `urn:example/application:some_application` will be used as the StackState Id.


Note that identifiers are used within StackState to merge components across different checks, synchronizations and data sources. Components with a matching identifier will be merged within StackState.

Given the following example:

```
# check1.py
self.component("urn:check1/host:this_host", "Host", {
    "name": "this-host",
    "identifiers": ["urn:/host:this_host"],
})

# check2.py
self.component("urn:check2/host:this_host", "Host", {
    "name": "this-host",
    "identifiers": ["urn:/host:this_host"],
})

```

These two components will be merged into a single component called `this-host` containing data from both integrations.


Learn more about the Agent Check Topology API [here](/develop/agent_check/checks_in_agent_v2/)

### Sending Metrics

The StackState Agent Check interface supports various types of metrics.

Metric data can be submitted using i.e. the `self.gauge()` function, or the `self.count()` function in the `AgentCheck` interface. All metrics data is stored in the `StackSate Metrics` data source that can be mapped to a metric telemetry stream for a component/relation in StackState:

![Metrics](/images/metricstelemetrystream.png)

The example below submits a gauge metric `host.cpu.usage` for our previously submitted `this-host` component:

```
self.gauge("host.cpu.usage", 24.5, tags=["hostname:this-host"])
```

<div class="alert alert-info">
Note: It is important to have a tag or combination of tags that you can use to uniquely identify this metric and map it to the corresponding component within StackState.
</div>

Learn more about the Agent Check Metric API [here](/develop/agent_check/checks_in_agent_v2/)

### Sending Events

Events can be submitted using the `self.event()` function in the `AgentCheck` interface. Events data is stored in the `StackState Generic Events` data source that can be mapped to an event telemetry stream on a component in StackState:

![EventsStream](/images/genericevents.png)

The example below submits an event to StackState when a call to the instance that is monitored exceeds some configured timeout:

```
self.event({
    "timestamp": int(time.time()),
    "source_type_name": "HTTP_TIMEOUT",
    "msg_title": "URL timeout",
    "msg_text": "Http request to %s timed out after %s seconds." % (instance_url, timeout),
    "aggregation_key": "instance-request-%s" % instance_url
})
```

Learn more about the Agent Check Event API [here](/develop/agent_check/checks_in_agent_v2/)

### Sending Service Checks

Service checks can be submitted using the `self.service_check` function in the `AgentCheck` interface. Service check data is stored in the `StackState State Events` data source.

The example below submits a service check to StackState when it is verified that the check was configured correctly and it can communicate with the instance that is monitored:

```
# some logic here to test our connection and if successful:
self.service_check("example.can_connect", AgentCheck.OK, tags=["instance_url:%s" % instance_url])
```

The service check can produce the following states:

 * AgentCheck.OK
 * AgentCheck.WARNING
 * AgentCheck.CRITICAL
 * AgentCheck.UNKNOWN

Learn more about the Agent Check Service Check API [here](/develop/agent_check/checks_in_agent_v2/)

### Adding Python Dependencies

Sometimes your check may require some external dependencies. To solve this problem the StackState agent is shipped with python and pip embedded. When installing the dependencies needed by your custom check you should use the embedded pip to do so. This executable for pip can be found here:

For Linux, you should find it at:

    /opt/stackstate-agent/embedded/bin/pip

For Windows, you should find it at:

    C:\Program Files\StackState\StackState Agent\embedded\bin\pip.exe

### Testing your Check

Custom Agent checks need to be called by the agent. To test this, run:

For Linux:

    sudo -u stackstate-agent -- stackstate-agent check <CHECK_NAME>

For Windows:

    C:\Program Files\StackState\StackState Agent\embedded\agent.exe check <CHECK_NAME>

This executes your check once and displays the results.

Once you are happy with the result of your check, you can restart the StackState Agent service and your check will be scheduled alongside the other agent checks.

For Linux:

    sudo service stackstate-agent restart

For Windows:

    "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" restart-service

## Troubleshooting

To troubleshoot any issues in your custom check, you can run the following status command and find your check in the output:

For Linux:

    sudo -u stackstate-agent -- stackstate-agent status

For Windows:

    "C:\Program Files\StackState\StackState Agent\embedded\agent.exe" status

If your issue continues, please reach out to Support with the help page that lists the paths it installs.
