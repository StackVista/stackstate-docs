# Topology filtering limits

## Overview

To optimize performance, a limit is placed on the amount of elements that can be loaded to produce a topology visualization. The filtering limit has a default value of 10000 elements.

If a [topology filter](/use/stackstate-ui/filters.md) loads more components than specified in the filtering limit, a message will be displayed on screen and no topology visualization will be displayed.

{% hint style="info" %}
The filtering limit is applied to the total amount of elements that need to be **loaded** and not the amount of elements that will be displayed.
{% endhint %}

## Configure default filtering limit

If required, the default filtering limit can be manually configured. 

{% tabs %}
{% tab title="Kubernetes" %}
To set a custom filtering limit, add the following to the `values.yaml` file used to deploy StackState:
```yaml
stackstate:
  components:
    api:
      config: |
         stackstate.webUIConfig.maxStackElementCount = <newvalue>

stackstate:
  components:
    view-health:
      config: |
         stackstate.webUIConfig.maxStackElementCount = <newvalue>
```
{% endtab %}
{% tab title="Linux" %}
Set a custom filtering limit in `etc/application_stackstate.conf` using the parameter `stackstate.webUIConfig.maxStackElementCount` `stackstate.topologyQueryService.maxStackElementsPerQuery`.
{% endtab %}
{% endtabs %}
