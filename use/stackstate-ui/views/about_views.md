---
description: Bookmark and monitor parts of your IT landscape with views
---

# About views

## Overview

The full topology available in StackState is likely much larger than you need to be concerned with at any given point in time. StackState allows you to create a filter to select a specific set of components from your topology and save it as a view. Each stored view includes:

* [Filters](../filters.md):
  * Topology filters - add elements \(components and relations\) to the view.
  * Events and Traces filters - refine the traces and events displayed.
* [Visualization settings](visualization_settings.md) – customize how elements \(components and relations\) are displayed within the view.
* [View health state configuration](about_views.md#view-health-state) – reports the health state of the view.
* Event handlers - respond to events generated in the view and send [event notifications](../../metrics-and-events/event-notifications.md).

Generally speaking, views serve two major purposes:

1. Views are a type of bookmark. They help you to find your way back to a part of your topology that is of particular interest to you or your team. They may also serve as a starting point for defining new views.
2. Views can be used for [event notifications and automation](/use/stackstate-ui/views/manage-event-handlers.md). Whenever a change within the view requires your attention, an event handler can send out a notification, create an incident in an ITSM system or trigger automation.

Not all views are manually created. Many [StackPacks](../../../stackpacks/about-stackpacks.md) generate views after installation.

## Access a view

Every view that a user has permission to access is listed on the **all views** screen in the StackState UI. To open this screen, click **all views** from the main menu or **Views** in the top bar breadcrumbs. Views marked with a star are listed directly in the main menu for easy access.

Click on a view name to open the topology perspective for that view.

## Starred views

You can add a star to a view you use frequently to add it to your personal main menu for easy access. View star settings are a personal preference stored in your user account. You can recognize starred views by the yellow star icon next to their name.

To add or remove a star:

* For the current view: Click the star icon to the right of its name in the top bar to add or remove the star.
* For any view: Click **all views** from the main menu to open a list of all views. Click the star icon to the right of a view name to add or remove its star.

## The View Details pane

When you first open a view, the View Details pane will be visible on the right-hand side of the StackState UI. This shows the following information:

* **View properties** - The view health state, query and last updated timestamp.
* **Components** - A summary of the number of components in the view.
* **Problems** - Any [problems](../../problem-analysis/about-problems.md) in the view.
* **Events** - The most recent events that occurred for components in the view. Click **View all** to open the [Events Perspective](../perspectives/events_perspective.md).

## View health state

A view is also a tool to define a clear selection of components for which you want to receive a event notifications. Typically, these are services that provide business value to a team's \(internal\) customers. StackState can define a single health state for any given set of components stored as a view - the [view health state](../../health-state/health-state-in-stackstate.md#view-health-state). The view health state reflects the health state of components and relations within the view. It can be calculated based on a simple count, but it could also be something more complex, for example:

* Report view health state `CLEAR` if service A and service B are working fine.
* Report view health `DEVIATING` if service A has a problem.
* Report view health `CRITICAL` if service B does not have health state `CLEAR`.

### Enable or disable view health state

* To enable view health state, set `View Health State Enabled` to **on** when you [create or edit a view](create_edit_views.md).
* To disable a view health state, [edit the view](about_views.md#delete-or-edit-a-view) and set `View Health State Enabled` to **off**.

➡️ [Learn more about how to configure the view health state](../../health-state/configure-view-health.md).

### Event notifications for view health state changes

A `ViewStateChangedEvent` event is triggered whenever a view changes its health state. This event can be used in event handlers to, for example, to send an e-mail or Slack message or to trigger automation. See how to [send event notifications](/use/stackstate-ui/views/manage-event-handlers.md).

## Secure views with RBAC

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the StackState Self-Hosted product:

    
Through a combination of configuration of permissions and scope, it is possible control access for specific users:

* Give access to a specific subset of the topology \(a so-called scope\) and allow them to create their own views.
* Give access to specific views and disallow them to create, modify or delete views.

{% endhint %}

## See also

* [Create and edit views](create_edit_views.md)
* [Health state for a view](../../health-state/health-state-in-stackstate.md#view-health-state)  
* [Visualization settings](visualization_settings.md)
* [Send event notifications for view health state changes](/use/stackstate-ui/views/manage-event-handlers.md)
