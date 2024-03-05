---
description: StackState SaaS
---

# About views

## Overview

The full topology available in StackState is likely much larger than you need to be concerned with at any given point in time. StackState allows you to create a filter to select a specific set of components from your topology and save it as a view. Each stored view includes:

* [Filters](../filters.md) - Topology filters add elements \(components and relations\) to the view. Events and Traces filters refine the traces and events displayed for the filtered topology.
* [Visualization settings](visualization_settings.md) – customize how elements \(components and relations\) are displayed within the view.
* [View health state configuration](about_views.md#view-health-state) – reports the health state of the view.
* [Event handlers](/use/events/event-notifications.md) - respond to events generated in the view and send event notifications.

Generally speaking, views serve two major purposes:

1. Views are a type of bookmark. They help you find your way back to a part of your topology that's of particular interest to you or your team. They may also serve as a starting point for defining new views.
2. Views can be used for [event notifications and automation](/use/events/manage-event-handlers.md). Whenever a change within the view requires your attention, an event handler can send out a notification, create an incident in an ITSM system or trigger automation.

Not all views are manually created. Many [StackPacks](../../../stackpacks/about-stackpacks.md) generate views after installation.

## Access a view

Every view that a user has permission to access is listed on the **all views** screen in the StackState UI. To open this screen, click **all views** from the main menu or **Views** in the top bar breadcrumbs. Views marked with a star are listed directly in the main menu for easy access.

Click a view name to open the topology perspective for that view.

## Starred views

You can add a star to a view that you often use to add it to your personal main menu for easy access. View star settings are a personal preference stored in your user account. You can recognize starred views by the yellow star icon next to their name.

To add or remove a star:

* For the current view: Click the star icon to the right of its name in the top bar to add or remove the star.
* For any view: Click **all views** from the main menu to open a list of all views. Click the star icon to the right of a view name to add or remove its star.

## View summary

When you first open a view, the **View summary** will be visible in the right panel. This shows the following information:

* **View properties** - the view health state, query, last updated timestamp and a summary of the number of components in the view.
* **Event handlers** - lists all event handlers configured for the view.
* **Problems** - any [problems](../../problem-analysis/about-problems.md) identified in the view.
* **Events** - the most recent events 
* that occurred for components in the view. Click **View all** to open the [Events Perspective](../perspectives/events_perspective.md).

![View summary tab](/.gitbook/assets/v51_view_summary.png)

## View health state

A view is also a tool to define a clear selection of components for which you want to receive an event notifications. Typically, these are services that provide business value to a team's \(internal\) customers. StackState can define a single health state for any given set of components stored as a view - the [view health state](../../concepts/health-state.md#view-health-state). The view health state reflects the health state of components and relations within the view. It can be calculated based on a simple count, but it could also be something more complex, for example:

* Report view health state `CLEAR` if service A and service B are working fine.
* Report view health `DEVIATING` if service A has a problem.
* Report view health `CRITICAL` if service B doesn't have health state `CLEAR`.

### Enable or disable view health state

To enable view health state, set **View Health State Enabled** to **on** when you [create or edit a view](create_edit_views.md). 

To disable a view health state, [edit the view](/use/stackstate-ui/views/create_edit_views.md) and set `View Health State Enabled` to **off**.

➡️ [Learn more the view health state](configure-view-health.md).

### Event notifications for view health state changes

A `ViewStateChangedEvent` event is triggered whenever a view changes its health state. This event can be used in event handlers to, for example, to send an e-mail or Slack message or to trigger automation. See how to [send event notifications](/use/events/manage-event-handlers.md).

## Secure views with RBAC

{% hint style="success" "self-hosted info" %}

**StackState Self-Hosted**

Extra information for the [StackState Self-Hosted product](https://docs.stackstate.com/):

    
Through a combination of configuration of permissions and scope, it's possible control access for a specific user. This can be done in the following ways:

* Grant the user access to a subset of the topology \(a so-called scope\) and allow them to create their own views from the topology available to them.
* Grant the user access to specific, existing views only and deny them permission to create, modify or delete views.

{% endhint %}

## Subview

### What is a subview?

A subview is a temporary StackState view that can be used to aid investigation. While views use stored filters to select a specific set of topology, subviews are generated on demand and can't be saved. Within a subview, you can investigate the element, group or problem across all perspectives and at any point in time. 


Whenever a subview is opened in the StackState UI, topology filters are constructed to focus directly on the chosen area of the StackState topology. You can open a subview by:

* double-clicking an element in the topology visualizer
* clicking **INVESTIGATE IN SUBVIEW** on a topology element or problem
* selecting **VIEW ALL** under **Events** in a right panel details tab - **Component details** or **Relation details**

There are two types of subview:

* **[Problem subviews](/use/problem-analysis/problem_investigation.md#problem-subview)** zoom in on the time window and components related to the root cause and contributing causes of a problem identified in the StackState topology. 
* **Selection subviews** zoom in on a specific component, relation or group.

### Working with subviews

You can open a subview in any of the following ways:

* Select a component, relation, group or problem in the StackState UI and then click **INVESTIGATE IN SUBVIEW** in the right panel details tab. The view filters will be updated to focus on the selected element, group or problem, and the **View summary** tab in the right panel will be replaced by a **Subview summary** tab.
* Double-click on a component, relation or group in the topology visualizer.
* Use the [Actions](/use/stackstate-ui/perspectives/topology-perspective.md#actions) list in the component context menu or right panel details tab to open a selection subview for a component.

Subviews can be shared with other StackState users as a link, this will include any modifications that you have made to the subview. It isn't possible to save a subview.

To exit a subview and return to the previous view or explore mode, click the view name in the top bar of the StackState UI.

![Breadcrumbs with view name](/.gitbook/assets/v51_problem_subview_breadcrumb.png)

## See also

* [Create and edit views](create_edit_views.md)
* [Health state for a view](../../concepts/health-state.md#view-health-state)  
* [Visualization settings](visualization_settings.md)
* [Send event notifications for view health state changes](/use/events/manage-event-handlers.md)
