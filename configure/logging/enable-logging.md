---
description: Enable logging for StackState checks, event handlers and functions
---

# Enable logging

## Overview

For debugging purposes, it may be helpful to enable logging for a StackState check, event handler or function. You can use the StackState CLI to set a logging level and then track messages in the file `stackstate.log`.  Logging can be enabled for checks, event handlers, propagation functions and view state configuration functions. Note that it is not currently possible to enable logging for other function types.

## Enable logging for a check, event handler or function instance

The logging level can be set in the StackState CLI using the ID of the check, event handler or function. 

{% hint style="info" %}
Note that logging will be enabled for an instance of a check, event handler or function, not for the function itself.
{% endhint %}

1. Find the ID for the check, event handler or function you want to enable logging for:
    - StackState CLI:
        - [Event handlers](#event-handlers)
        - [View health state configuration functions](#view-health-state-configuration-functions)
    - StackState UI:
        - [Checks](#checks-and-propagation-functions)
        - [Propagation functions](#checks-and-propagation-functions)

2. Use the [StackState CLI](/setup/installation/cli-install.md) to set the logging level for the ID, for example:
```
sts serverlog setlevel <id> DEBUG
```

3. Monitor the `stackstate.log` using the ID.
```
tail -f stackstate.log | grep <id>
```

## Add logging to a StackState function

Logging statements can be added to StackState functions and monitored in the `stackstate.log`. This is useful for debug purposes.

1. Add a log statement in the function's code. For example:
    - `log.info("message")`
    - `log.info(variable.toString())`
    
2. [Enable logging](#enable-logging-for-a-check-event-handler-or-function-instance) for the function.


## Find the ID for a check, event handler or function

Retrieve the ID for a specific check, event handler or function instance:
    - [Checks](#checks-and-propagation-functions)
    - [Event handlers](#event-handlers)
    - [Propagation functions](#checks-and-propagation-functions)
    - [View health state configuration functions](#view-health-state-configuration-functions)

### StackState CLI

#### Event handlers

- Run the [StackState CLI](/setup/installation/cli-install.md) command below to list all event handlers.
- Use the `id` from the command output to [enable logging](#enable-logging-for-a-check-event-handler-or-function-instance) for a specific event handler.

{% tabs %}
{% tab title="CLI command" %}
```
sts graph list EventHandler
```
{% endtab %}
{% tab title="Example result" %}
```
             id  type          name              description    owned by    manual    last updated
---------------  ------------  ----------------  -------------  ----------  --------  ------------------------
114118706410878  EventHandler  my_event_handler                             True      Fri Nov 13 11:32:29 2020
```
{% endtab %}
{% endtabs %}

#### View health state configuration functions

- Run the [StackState CLI](/setup/installation/cli-install.md) commands below to return the IDs of all StackState views and then retrieve the JSON for a specific view ID.
- Use the `viewHealthStateConfiguration` ID from the retrieved JSON to [enable logging](#enable-logging-for-a-check-event-handler-or-function-instance) for this instance of the view health state configuration function. In the example below, this would be `39710412772194`.

{% tabs %}
{% tab title="CLI command" %}
```
# get ID of the view
sts graph list QueryView

# get the ID of the view's "viewHealthStateConfiguration"
sts graph show-node <VIEW_ID>

```
{% endtab %}
{% tab title="Example result" %}
```
$ sts graph list QueryView                           
             id  type       name                       description    owned by                      manual    last updated
---------------  ---------  -------------------------  -------------  ----------------------------  --------  ------------------------
  9161801377514  QueryView  Demo - Customer A          -              urn:stackpack:demo-stackpack  False     Fri Nov 13 16:24:38 2020
199988472830315  QueryView  Demo - Customer B          -              urn:stackpack:demo-stackpack  False     Fri Nov 13 16:24:38 2020
278537340600843  QueryView  Demo - Business Dashboard  -              urn:stackpack:demo-stackpack  False     Fri Nov 13 16:24:38 2020


$ sts graph show-node 9161801377514

{
   "id":9161801377514,
   "lastUpdateTimestamp":1605284678082,
   "name":"Demo - Customer A",
   "groupedByDomains":true,
   "groupedByLayers":true,
   "groupedByRelations":true,
   "showIndirectRelations":true,
   "showCause":"NONE",
   "state":{
      "id":212230744931364,
      "lastUpdateTimestamp":1605284689666,
      "state":"CLEAR",
      "_type":"ViewHealthState"
   },
   "viewHealthStateConfiguration":{
      "id":39710412772194,
      "lastUpdateTimestamp":1605284678082,
      "function":28286436254116,
      "enabled":true,
      "arguments":[
         {
            "id":128484527572993,
            "lastUpdateTimestamp":1605284678082,
            "parameter":184761614904259,
            "value":1,
            "_type":"ArgumentLongVal"
         },
         {
            "id":229304367255010,
            "lastUpdateTimestamp":1605284678082,
            "parameter":178411912509267,
            "value":1,
            "_type":"ArgumentLongVal"
         }
      ],
      "_type":"ViewHealthStateConfiguration"
   },
   "groupingEnabled":true,
   "minimumGroupSize":4,
   "query":"(domain IN (\"customer E\") AND layer IN (\"API\", \"applications\", \"business application\", \"hypervisor\", \"databases\", \"k8s_proc\", \"lambda\", \"network devices\", \"location\", \"rack\", \"row\", \"servers\", \"services\", \"storage\"))",
   "queryVersion":"0.0.1",
   "identifier":"urn:stackpack:demo-stackpack:query-view:demo-customer-e",
   "ownedBy":"urn:stackpack:demo-stackpack",
   "eventTypes":[
      
   ],
   "tags":[
      
   ],
   "spanTypes":[
      
   ],
   "_type":"QueryView"
}
```
{% endtab %}
{% endtabs %}

### StackState UI

#### Checks and propagation functions

You can find the check or propagation ID for a specific component in the StackState UI.

1. Click on a component to open the component details.
2. Click on **...** and select **Show JSON**.
3. Find the section for `"checks"` or `"propagation"`.
4. Find the check or propagation that you want to enable logging for and copy the value from the field `id`.

![Show JSON](/.gitbook/assets/v41_show-json.png)

- Use the ID to [enable logging](#enable-logging-for-a-check-event-handler-or-function-instance) for the check or propagation function.

## See also

- [StackState CLI](/setup/installation/cli-install.md)
- [StackState UI Analytics environment](/develop/reference/scripting#running-scripts)