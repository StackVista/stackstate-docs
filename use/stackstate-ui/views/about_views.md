---
description: Bookmark and monitor parts of your IT landscape with views
---

# Views

## Overview

The full topology available in StackState is likely much larger than you need to be concerned with at any given point in time. StackState allows you to create a filter to select a specific set of components from your topology and save it as a view. Each stored view includes:

* [View filters](../filters.md):
  * Topology filters are used to add elements \(components and relations\) to the view.
  * Events and Traces filters refine the traces and events displayed.
* Topology [visualization settings](/use/stackstate-ui/views/visualization_settings.md).
* Configuration to calculate the [view health state](about_views.md#view-health-state).

Generally speaking, views serve two major purposes:

1. Views are a type of bookmark. They help you to find your way back to a part of your topology that is of particular interest to you or your team. They may also serve as a starting point for defining new views.
2. Views can be used for [event notifications and automation](../../metrics-events/send-event-notifications.md). Whenever a change within the view requires your attention, an event handler can send out a notification, create an incident in an ITSM system or trigger automation.

## Access a view

{% hint style="info" %}
Not all views are manually created. Many [StackPacks](../../../stackpacks/about-stackpacks.md) generate views after installation. It is recommended to use these views only as starting points for creating your own views.
{% endhint %}

Views marked with a star will be included directly in the main menu for easy access. Starred views are a personal preference that is stored in your account.

To access a list of all views, click **Views** from the main menu.

## The View Details pane

When you first open a view, the View Details pane will be visible on the right side of the StackState UI. This shows the following information:

* **View properties** - the view health state, query and last updated timestamp.
* **Components** - a summary of the number of components in the view.
* **Problems** -- any [problems](../../problem-analysis/problems.md) in the view.
* **Events** -- the most recent events that occurred for components in the view. Click **View all** to open the [Events Perspective](../perspectives/events_perspective.md).

## View health state

A view is also a tool to define a clear selection of components for which you want to receive a event notifications. Typically, these are services that provide business value to a team's \(internal\) customers. StackState can define a single health state for any given set of components stored as a view - the [view health state](/use/health-state/health-state-in-stackstate.md#view-health-state). The view health state reflects the health state of components and relations within the view. It can be calculated based on a simple count, but it could also be something more complex, for example:

* Report view health state `CLEAR` if service A and service B are working fine.
* Report view health `DEVIATING` if service A has a problem.
* Report view health `CRITICAL` if service B does not have health state `CLEAR`.

### Enable or disable view health state

* To enable view health state, set `View Health State Enabled` to **on** when you create or edit a view. 
* To disable a view health state, [edit the view](about_views.md#delete-or-edit-a-view) and set `View Health State Enabled` to **off**.

Read more about how to [configure the view health state](/use/health-state/configure-view-health.md).

### Event notifications for view health state changes

A `ViewStateChangedEvent` event is triggered whenever a view changes its health state. This event can be used in event handlers to, for example, to send an e-mail or Slack message or to trigger automation. See how to [send event notifications](../../metrics-events/send-event-notifications.md).

## Secure views with RBAC

Through a combination of configuration of [permissions](../../../configure/security/rbac/rbac_permissions.md) and [scope](../../../configure/security/rbac/rbac_scopes.md), it is possible to give specific users:

* access to a specific subset of the topology \(a so-called scope\) and allow them to create their own views
* access to specific views and disallow them to create, modify or delete views

For further details, see the [RBAC documentation](../../../configure/security/rbac/role_based_access_control.md).

## See also

* [Create and edit views](/use/stackstate-ui/views/create_edit_views.md)
* [Health state for a view](/use/health-state/health-state-in-stackstate.md#view-health-state)  
* [Visualization settings](/use/stackstate-ui/views/visualization_settings.md)
* [Send event notifications for view health state changes](/use/metrics-events/send-event-notifications.md)