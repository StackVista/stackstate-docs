---
title: StackPack
kind: Documentation
---

# index

StackPacks are an easy way to ship and manage the lifecycle of your integration.

## When to create a StackPack

As a rule of thumb each integration should have a StackPack. Without configuration StackState does not process incoming topology, telemetry or trace data. Such data will be accepted by StackState, but will not automatically reflect on the 4T data model. The best way to bundle configuration is through a StackPack. StackState can also be configured via the CLI, UI or directly via the API, but then your configuration will not be protected from user changes, can not easily be upgraded and can not easily be used for configuring multiple instances of an integration.

## How to create a StackPack

Refer to:

* [Prepare a StackPack package](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/prepare_package/README.md)
* [How to customize a StackPack](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/how_to_customize_a_stackpack/README.md)
* [How to get a template file](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/how_to_get_a_template_file/README.md)
* [Prepare a StackPack provisioning script](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/prepare_stackpack_provisioning_script/README.md)
* [How to pack and upload a StackPack](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/how_to_pack_and_upload_stackpack/README.md)
* [How to make a multi-instance StackPack](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/how_to_make_a_multi-instance_stackpack/README.md)

