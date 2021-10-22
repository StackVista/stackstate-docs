---
title: How to connect your Agent Check to a StackState instance
kind: Documentation
---

# How to connect an agent check with StackState

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The recommended way to connect your agent check and visualize the data within StackState is to install the `Custom Synchronization` StackPack.

To install this StackPack go to StackState’s StackPacks page and locate the “Custom Synchronization” in Other StackPacks. During the installation process, you need to provide the following information:

* Instance type \(source identifier\)
* Instance URL

These are directly mapped to the `TopologyInstance` supplied in the `get_instance_key` function of your agent check.

Given the following implementation:

```text
    def get_instance_key(self, instance):
        if 'url' not in instance:
            raise ConfigurationError('Missing url in topology instance configuration.')

        instance_url = instance['url']
        return TopologyInstance("example", instance_url)
```

You should use `example` as the Instance Type and the value of `instance_url` as the Instance URL.

When the above information is provided click the “Install” button and you should start to see the topology coming in for your Agent Check and the “Custom Synchronization” should become enabled.

Note: The \`Custom Synchronization\` StackPack only supports a single instance, to synchronize multiple instances you'll have to create a multi-tenant StackPack.

