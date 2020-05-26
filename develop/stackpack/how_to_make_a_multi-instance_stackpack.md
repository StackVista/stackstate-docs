---
title: How to make a multi-instance StackPack
kind: Documentation
---

# how\_to\_make\_a\_multi-instance\_stackpack

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

1. [Prepare a shared template file](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/prepare_shared_template/README.md)
2. [Prepare an instance template file](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/prepare_instance_template_file/README.md)
3. [Prepare a multi-instance provisioning script](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/prepare_multi-instance_provisioning_script/README.md)
4. [Pack and upload a StackPack](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/develop/stackpack/how_to_make_a_multi-instance_stackpack/README.md)

