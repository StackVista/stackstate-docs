---
description: StackState SaaS
---

# Layers, Domains and Environments

## Layers

Layers are one of the ways to logically group components. Layers are represented as rows ordered from top to bottom in StackState Views. The order of layers can be configured in the **Settings** page under the **Layers** section by providing numeric values in the `Order` column. Should two layers have the same numeric value, then the alphabetic order of the layer names determines which layer has the higher position.

![Layers Settings](../../.gitbook/assets/layers.png)

## Domains

Domains are another way of grouping components logically. They're shown as columns ordered from left to right in StackState Views. The order of Domains can be configured in the **Settings** page under the **Domains** section by providing numeric values in the `Order` column. Should two domains have the same numeric value, then the alphabetic order of the domain names determines which domain has the position more to the left.

![Domains Settings](../../.gitbook/assets/domains.png)

## Environments

Environments are meant for grouping components using the DTAP model: Development, Testing, Acceptance, and Production. A component can belong to one **or multiple** environments. This can be useful when modeling, for example, a database used for both the development and testing environment. Environments share the same domains and layers. Typically, you need a view of a single environment at a time; however, it's possible to get a view of multiple environments at the same time.

![Environments](../../.gitbook/assets/environments.png)

Environments can also be used within StackState to do modeling work without affecting the rest of the stack - just by creating components and placing them in the temporary environments. Another way of using environments is to create separate spaces for different customers.

