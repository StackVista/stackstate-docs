---
description: StackState Self-hosted v4.5.x
---

# How to create a StackPack

{% hint style="warning" %}
**This page describes StackState version 4.5.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/developer-guides/stackpack/develop_stackpacks).
{% endhint %}

## When to create a StackPack

As a rule of thumb each integration should have a StackPack. Without configuration StackState does not process incoming topology, telemetry or trace data. Such data will be accepted by StackState, but will not automatically reflect on the 4T data model. The best way to bundle configuration is through a StackPack. StackState can also be configured via the CLI, UI or directly via the API, but then your configuration will not be protected from user changes, can not easily be upgraded and can not easily be used for configuring multiple instances of an integration.

## How to create a StackPack

Refer to:

* [Prepare a StackPack package](prepare_package.md)
* [How to customize a StackPack](how_to_customize_a_stackpack.md)
* [How to get a template file](how_to_get_a_template_file.md)
* [Prepare a StackPack provisioning script](prepare_stackpack_provisioning_script.md)
* [How to pack and upload a StackPack](how_to_pack_and_upload_stackpack.md)
* [How to make a multi-instance StackPack](how_to_make_a_multi-instance_stackpack.md)

