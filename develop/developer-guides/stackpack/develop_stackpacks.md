---
description: StackState Self-hosted v5.1.x 
---

# How to create a StackPack

## When to create a StackPack

As a rule of thumb each integration should have a StackPack. Without configuration StackState does not process incoming topology, telemetry or trace data. Such data will be accepted by StackState, but won't automatically reflect on the 4T data model. The best way to bundle configuration is through a StackPack. StackState can also be configured using the CLI, UI or directly via the API, but then your configuration won't be protected from user changes, cannot easily be upgraded and cannot easily be used for configuring multiple instances of an integration.

## How to create a StackPack

Refer to:

* [Prepare a StackPack package](prepare_package.md)
* [How to customize a StackPack](how_to_customize_a_stackpack.md)
* [How to get a template file](how_to_get_a_template_file.md)
* [Prepare a StackPack provisioning script](prepare_stackpack_provisioning_script.md)
* [How to pack and upload a StackPack](how_to_pack_and_upload_stackpack.md)
* [How to make a multi-instance StackPack](how_to_make_a_multi-instance_stackpack.md)

