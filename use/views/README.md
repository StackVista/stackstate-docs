---
description: Bookmark and monitor parts of the 4T data model with views
---

# Views

The 4T data model in StackState is likely much bigger than what you care about at any given point in time. StackState allows you to filter the 4T data model and store it as a view. A view saves:

* The topology filter you have selected.
* Topology visualization settings.
* Configuration about how to calculate the view health state \(see the section on "View health state" below\).

Generally speaking, views serve two major purposes:

1. Views are a type of bookmark. They help you to find your way back to a part of the 4T data model that is of particular interest to you or your team. They may also serve as a starting point for defining new views.
2. Views can be used for [alerting](../health-state-and-alerts/configure-alerts.md) and automation. Whenever a change within the view requires your attention an event handler can send out a notification, create an incident in an ITSM system or trigger automation.

## Accessing views

{% hint style="info" %}
Not all views are manually created. Many [StackPacks](/stackpacks/about-stackpacks.md) generate views after installation. It is recommended to use these views only as starting points for creating your own views.
{% endhint %}

Views can be accessed by clicking on the **Views** menu item on the main menu. Views that you have starred will be presented directly in the main menu for easy access. Starred views are a personal preference that is stored onto your account.

## View details panel

{% hint style="info" %}
To reopen the view details panel at any time, simply click on the white background in the topology visualization.
{% endhint %}

Whenever you first open a view you see a view details panel on the right side of the screen. This panel shows the following information.

* **View properties** -- shows the view query and last updated timestamp.
* **Components** -- shows a summary of the number of components in the view.
* **Problem Clusters** -- shows the problem clusters for any problems in the view.
* **Events** -- shows the 5 most recent events that occurred for components in the view. Click **View all** to show the [Events Perspective](events_perspective.md).

## View health state

Every person or team has a different definition of when a part of the environment they are watching over is in danger. View health state can be used to indicate when the whole, as defined in a view, is in danger. The view can be in the following states:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.
* Gray - `UNKNOWN` - The view does not have a view health state.

To enable view health state put the `View Health State Enabled` to on when creating or editing the view.

## Creating views

{% hint style="info" %}
By default all views are visible to everybody. You can star a view to add it to your personal main menu for easy access. For securing/hiding views please refer to the [RBAC documentation](/configure/security/rbac/role_based_access_control.md).
{% endhint %}

To create a new view, navigate to **Explore Mode** via the hamburger menu or use another view as a starting point. Whenever you change any of the topology filtering settings a **Save View** button will appear at the top of the screen. Click this button to save your current selection to a view. To create a new view from the current view use the dropdown menu next to the button and select **Save View As**.

In the dialog the following options appear:

| Field Name | Description |
| :--- | :--- |
| View name | The name of your view. |
| View health state enabled | Whether your view has a health state. If you disable this option your view's health state, depicted by the colored circle next to the view, will always color gray. The main reason for disabling is the fact that StackState's backend needs to spend resources on calculating the view health state each time the view changes. |
| Configuration function | When view health state is enabled you can choose a [view state configuration function](/configure/view_state_configuration.md) that is used to calculate the view health state whenever there are changes in the view. The default choice is **minimum health states** |
| Arguments | Arguments are dependent on the chosen function. See "Function: minimum health states" below. |
| Identifier | \(Optional\) this field can be used to give an unique [identifier](/configure/identifiers.md) to the view. This makes the view uniquely referenceable from exported configuration, like the exported configuration in a StackPack. |

## Function: minimum health states

The minimum health states function calculates the health state of the view as follows:

* When more than `minCriticalHealthStates` components inside the view have a `CRITICAL` health state then the view becomes `CRITICAL`. This does not count propagated health states.
* When more than `minDeviatingHealthStates` components inside the view have a `DEVIATING` health state then the view becomes `DEVIATING`. This does not count propagated health states.
* Otherwise the view will get the `CLEAR` health state.

## Alerting on view health state

An activity event is triggered when a view changes its health state. This event can be used in event handlers to, for example, to send an e-mail or Slack message or to trigger automation. Please refer to [alerting](../health-state-and-alerts/configure-alerts.md) to understand how to set that up.

## Deleting or editing views

{% hint style="info" %}
It is not recommended to delete or edit views created by StackPacks. When doing so, you will get a warning that the view is locked. If you proceed anyway the issue needs to be resolved when upgrading the StackPack that created the view.
{% endhint %}

To delete or edit a view:

* Open the view.
* In the view details panel on the right side of the screen, select the context menu next \(accessed through the triple dots\) to the right of the view name.
* Select the **Delete** or **Edit** menu item.

## Securing views \(RBAC\)

Through a combination of configuration of [permissions](/configure/security/rbac/rbac_permissions.md) and [scope](/configure/security/rbac/rbac_scopes.md), it is possible to give specific users:

* access to a specific subset of the topology \(a so-called scope\) and allowing them to create their own views
* access to specific views and disallowing them to create, modify or delete views

Please refer to the [RBAC documentation](/configure/security/rbac/role_based_access_control.md).

