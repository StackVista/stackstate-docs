---
title: StackPack
kind: Documentation
---

StackPacks are an easy way to ship and manage the lifecycle of your integration.

### When to create a StackPack

As a rule of thumb each integration should have a StackPack. Without configuration StackState does not process incoming topology, telemetry or trace data. Such data will be accepted by StackState, but will not automatically reflect on the 4T data model. The best way to bundle configuration is through a StackPack. StackState can also be configured via the CLI, UI or directly via the API, but then your configuration will not be protected from user changes, can not easily be upgraded and can not easily be used for configuring multiple instances of an integration.

### How to create a StackPack

Refer to:

 * [Prepare a StackPack package](/develop/stackpack/prepare_package/)
 * [How to customize a StackPack](/develop/stackpack/how_to_customize_a_stackpack/)
 * [How to get a template file](/develop/stackpack/how_to_get_a_template_file/)
 * [Prepare a StackPack provisioning script](/develop/stackpack/prepare_stackpack_provisioning_script/)
 * [How to pack and upload a StackPack](/develop/stackpack/how_to_pack_and_upload_stackpack/)
 * [How to make a multi-instance StackPack](/develop/stackpack/how_to_make_a_multi-instance_stackpack/)
