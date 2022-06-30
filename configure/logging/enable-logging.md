---
description: StackState Self-hosted v5.0.x 
---

# Enable logging for functions

## Overview

{% hint style="info" %}
Only available for Linux installations of StackState.
{% endhint %}

For debugging purposes, it may be helpful to enable logging for a StackState function. You can add logging statements to functions and then use the StackState CLI to set the logging level for individual instances of a check function, event handler function, propagation function or view state configuration function. Log messages will be added to the StackState log file `stackstate.log`. It is not currently possible to enable logging for other function types.

## Set the logging level for a function instance

To enable logging for an instance of a function, use its ID to set a logging level in the `stac` CLI. Note that the function itself will have an ID and each instance of the function relating to a component or view in StackState will have a separate ID.

{% hint style="info" %}
* The logging level should be set using the ID for an instance of a function, not the ID of the function itself.
* The [`stac` CLI](/setup/cli/cli-stac.md) is required to set the logging level. It is not possible to set the logging level of a function instance using the new `sts` CLI.
* It is only possible to enable logging for functions running on a Linux installation of StackState.
{% endhint %}

1. Find the ID for the instance of the function that you want to enable logging for:
   * [Check IDs](enable-logging.md#check-and-propagation-ids)
   * [Event handler IDs](enable-logging.md#event-handler-ids)
   * [Propagation IDs](enable-logging.md#check-and-propagation-ids)
   * [View health state configuration IDs](enable-logging.md#view-health-state-configuration-ids)
2. Use the [`stac` CLI](/setup/cli/cli-stac.md) to set the logging level for the ID, for example:

   ```text
   stac serverlog setlevel <id> DEBUG
   ```
   

## Monitor logging for a function


After logging has been enabled for the function instance, monitor the `stackstate.log` using the function instance ID.

```text
tail -f stackstate.log | grep <id>
```


## Add logging statements to a function

Logging statements can be added to StackState functions and monitored in the `stackstate.log` file. This is useful for debug purposes.

1. Add a log statement in the function's code. For example:
   * `log.info("message")`
   * `log.info(variable.toString())`
2. [Set a logging level](enable-logging.md#set-the-logging-level-for-a-function-instance) to enable logging for an instance of the function.

## Find the ID for a function instance

Retrieve the ID for a specific instance of a function:

* [Check IDs](enable-logging.md#check-and-propagation-ids)
* [Event handler IDs](enable-logging.md#event-handler-ids)
* [Propagation IDs](enable-logging.md#check-and-propagation-ids)
* [View health state configuration IDs](enable-logging.md#view-health-state-configuration-ids)

### StackState CLI

#### Event handler IDs

The ID for an event handler can be found using the [StackState CLI](../../setup/cli/README.md). This is the ID for an instance of an event handler function.

* To list all event handlers, run the StackState CLI command below.
* Use the `id` from the command output to [enable logging](enable-logging.md#set-the-logging-level-for-a-function-instance) for a specific event handler.

{% tabs %}
{% tab title="CLI: stac" %}
```text
stac graph list EventHandler

             id  type          name          description    owned by    manual    last updated
---------------  ------------  ------------  -------------  ----------  --------  ------------------------
114118706410878  EventHandler  demo_handler                             True      Fri Nov 13 11:32:29 2020
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% tab title="CLI: sts (new)" %}

```text
sts settings list --type EventHandler
```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}
{% endtabs %}

#### View health state configuration IDs

The ID for a view health state configuration can be found using the [StackState CLI](../../setup/cli/README.md). This is the ID for a view's instance of a view health state configuration function.

* Run the two StackState CLI commands below:
  1. To return the IDs of all StackState views.
  2. To retrieve the JSON for a specific view ID.
* Use the `viewHealthStateConfiguration` ID from the retrieved view JSON to [enable logging](enable-logging.md#set-the-logging-level-for-a-function-instance) for this instance of the view health state configuration function. In the example below, this would be `39710412772194`.

{% tabs %}
{% tab title="CLI: stac" %}
```text
# get IDs of all views
stac graph list QueryView

             id  type       name                       description    owned by                      manual    last updated
---------------  ---------  -------------------------  -------------  ----------------------------  --------  ------------------------
  9161801377514  QueryView  Demo - Customer A          -              urn:stackpack:demo-stackpack  False     Fri Nov 13 16:24:38 2020
199988472830315  QueryView  Demo - Customer B          -              urn:stackpack:demo-stackpack  False     Fri Nov 13 16:24:38 2020
278537340600843  QueryView  Demo - Business Dashboard  -              urn:stackpack:demo-stackpack  False     Fri Nov 13 16:24:38 2020


# get the ID of the specified view's "viewHealthStateConfiguration"
# stac graph show-node <VIEW_ID>

sts graph show-node 9161801377514

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
      ...
```

**Not running the `stac` CLI yet?**

➡️ [Upgrade the old `sts` CLI to `stac`](/setup/cli/cli-stac.md#upgrade)
{% endtab %}
{% tab title="CLI: sts (new)" %}

```commandline
# get IDs of all views
sts settings list --type QueryView

TYPE      | ID              | IDENTIFIER | NAME                      | OWNED BY | LAST UPDATED                                          
QueryView | 165313710240823 |            | Demo - Customer A         |          | Tue Jun 21 13:44:12 2022 CEST
QueryView | 26281716816873  |            | Demo - Customer B         |          | Tue Jun 21 13:44:12 2022 CEST
QueryView | 184368967764989 |            | Demo - Customer D         |          | Tue Jun 21 13:44:12 2022 CEST


# get the ID of the specified view's "viewHealthStateConfiguration"

sts settings describe --ids <VIEW_ID>

```

➡️ [Which version of the `sts` CLI am I running?](/setup/cli/cli-comparison.md#which-version-of-the-cli-am-i-running)
{% endtab %}

{% endtabs %}

### StackState UI

#### Check and propagation IDs

The ID for a check or propagation on a specific component can be found in the StackState UI. These are the IDs for the component's instance of a check function or propagation function.

1. Select a component to open detailed information about it in the right panel **Selection details** tab.
2. Click on **...** and select **Show JSON**.
3. Find the section for `"checks"` or `"propagation"`.
4. Find the check or propagation that you want to enable logging for and copy the value from the field `id`.

![Show JSON](../../.gitbook/assets/v50_show-json.png)

* Use the ID to [enable logging](enable-logging.md#set-the-logging-level-for-a-function-instance) for the component's check or propagation functions.

## See also

* [StackState CLI](../../setup/cli/README.md)
* [Check functions](../../develop/developer-guides/custom-functions/check-functions.md)
* [Event handler functions](../../develop/developer-guides/custom-functions/event-handler-functions.md)
* [State propagation and propagation functions](../../develop/developer-guides/custom-functions/propagation-functions.md)
* [View state configuration functions](../../develop/developer-guides/custom-functions/view-health-state-configuration-functions.md)

