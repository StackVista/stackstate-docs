# Connect an Agent check to StackState

## Overview

The recommended way to connect your Agent check and visualize the data within StackState is to install the **Custom Synchronization** StackPack. Note that the Custom Synchronization StackPack only supports a single instance, to synchronize multiple instances you will need to create a multi-tenant StackPack.

## Install

Install the Custom Synchronization StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Instance type \(source identifier\)** - `TopologyInstance`
* **Instance URL**

These are directly mapped to the `TopologyInstance` supplied in the `get_instance_key` function of your agent check.

In the example Agent check below StackState, the Custom Synchronization StackPack **Instance type** would be `example` and the **Instance URL** would be `instance_url`.

```text
    def get_instance_key(self, instance):
        if 'url' not in instance:
            raise ConfigurationError('Missing url in topology instance configuration.')

        instance_url = instance['url']
        return TopologyInstance("example", instance_url)
```

When the StackPack has been installed, the Custom Synchronization should become enabled and you should start to see the topology coming in for your Agent Check.

## See also

* [Agent check API](agent-check-api.md)
* [How to develop Agent checks](how_to_develop_agent_checks.md)
* [Developer guide - Custom Synchronization StackPack](../custom_synchronization_stackpack/)

