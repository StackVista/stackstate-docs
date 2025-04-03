---
description: SUSE Observability Self-hosted 
---

# Analytics page

Analytics page provides a powerful and flexible interface to query and analyze your observability data using [STQL queries](../develop/reference/k8sTs-stql_reference.md). 
This interactive environment empowers you to go beyond pre-built dashboards and gain deeper insights into the health, performance, and dependencies of your dynamic environment.

{% hint style="warning" %}
**The Analytics page is deprecated, but you can still enable it by configuring specific permissions. However, we strongly recommend leveraging StackPacks for enhanced observability and analysis, as they provide a more robust and actively supported alternative.**

Two permissions are required to enable Analytics Page:
- `access-analytics`
- `execute-scripts`

More details: [Permissions management](../setup/security/rbac/rbac_permissions.md)

{% endhint %}
