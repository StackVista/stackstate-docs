---
title: How to make a multi-instance StackPack
kind: Documentation
---

# How to make a multi-instance StackPack

This documentation set explains how to make a StackPack that can be installed as multiple instances in StackState. Below you can find the introduction to this topic and the steps to get a multi-instance StackPack. This

StackPacks can be developed to support multiple instances of the same StackPack. This approach is useful in situations when there is a need to monitor more than one environment within the same technology. Multi-instance support can be achieved by splitting template files of your StackPack and tweaking the provisioning script in a way that supports multiple instances by keeping information that is shared between StackPacks separated from the instance-specific template.

Multi-instance StackPack package looks a little different from a standard StackPack, as there are more than one template files:

```text
<your-stackpack>
    ├── provisioning
    │   ├── icons
    │   |   └── icon.png
    │   ├── scripts
    │   │     └── ExampleProvision.groovy
    │   └── templates
    │       ├── instance template.json.handlebar
  │       ├── shared template.json.handlebar
    │       └── application template.json.handlebar
    ├── resources
    │   ├── logo.png
    │   └── overview.md
    └── stackpack.conf
```

Steps to get a multi-instance StackPack:

1. [Prepare a shared template file](prepare_shared_template.md)
2. [Prepare an instance template file](prepare_instance_template_file.md)
3. [Prepare a multi-instance provisioning script](prepare_multi-instance_provisioning_script.md)
4. [Pack and upload a StackPack](how_to_pack_and_upload_stackpack.md)

