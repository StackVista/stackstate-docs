---
description: StackState Self-hosted v4.5.x
---

# StackState Common Layer

{% hint style="warning" %}
**This page describes StackState version 4.5.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/developer-guides/stackpack/stackstate-common-layer).
{% endhint %}

A Layer is a specific term in the StackState where all the Components from different integrations lie within. It is used for the horizontal ordering of the topology. Since StackState supports multiple integrations, there are some common layers defined in the product. Layers are ordered in terms of proximity to the end-user. Merging preference is given to the component in the layer which is closer to the end-user. Below is the list of common layers used in the StackState and their identifiers that can be referenced in a StackPack.

| Layer Name | Identifier |
| :--- | :--- |
| Blueprints | urn:stackpack:common:layer:blueprints |
| Users | urn:stackpack:common:layer:users |
| Business Processes | urn:stackpack:common:layer:business-processes |
| Applications | urn:stackpack:common:layer:applications |
| Application Load Balancers | urn:stackpack:common:layer:application-load-balancers |
| Uncategorized | urn:stackpack:common:layer:uncategorized |
| Services | urn:stackpack:common:layer:services |
| Serverless | urn:stackpack:common:layer:serverless |
| Containers | urn:stackpack:common:layer:containers |
| Processes | urn:stackpack:common:layer:processes |
| Messaging | urn:stackpack:common:layer:messaging |
| Databases | urn:stackpack:common:layer:databases |
| Machines | urn:stackpack:common:layer:machines |
| Storage | urn:stackpack:common:layer:storage |
| Networking | urn:stackpack:common:layer:networking |
| Hardware | urn:stackpack:common:layer:hardware |
| Locations | urn:stackpack:common:layer:locations |

The above layer list will be shown on the StackState Integration View from top to bottom. It means `Blueprints` layer will be on top and `Locations` layer will be at the bottom.

