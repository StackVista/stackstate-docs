---
title: Views
kind: Documentation
aliases:
  - /usage/views/
listorder: 2
description: Bookmark and monitor parts of the 4T data model with views.
---

# Views


{% hint style="warning" %}
**This page describes StackState version 4.0.**

The StackState 4.0 version range is End of Life (EOL) and **no longer supported**. We encourage customers still running the 4.0 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

The topology in StackState is likely much bigger than what you care about at any given point in time. StackState allows you to filter the topology in a **view** so you can locate the part of the topology you are interested in.

## Accessing views

Views can be accessed by clicking on the Views link in the top navigation bar or using the hamburger menu in the top left corner. When you select a view, StackState will show the components in the view and restrict all further information \(telemetry, problems, events\) to only those components.

## View overview

The View Overview shows a compact summary of the information in the view and is shown when a view is first opened or by clicking on the grid \(white background\) of the graph.

The View Overview shows the following information:

* **View properties** -- shows the view query and last updated timestamp
* **Components** -- shows a summary of the number of components in the view
* **Problem Clusters** -- shows the problem clusters for any problems in the view
* **Events** -- shows the 5 most recent events that occurred for components in the view

## Creating views

To create a new view, navigate to **Explore Mode** via the hamburger menu. Explore Mode shows you all components in StackState. If your IT landscape is too big, StackState will encourage you to narrow your search by [filtering topology](views.md) in the view.

When a view is modified or you created a new view starting from Explore Mode, a **Save As View** button will appear at the top of the screen. Click this button to save \(the changes to\) your view.

## View health state

Every individual/team has a different definition of when the part of the environment they are watching over is in danger. View health state can be used to indicate when the whole, as defined in a view, is in danger. The view can be in three states:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.

To enable view health state set switch `View Health State Enabled` to on. This can be done in the dialog when saving a new view or editing an existing one. This is also where the [view health state function](../configure/view_state_configuration.md) is configured, which determines how to . Often this will be the number of components to be deviating or critical before the view health state changes.

## Alerting on view health state

An activity event is triggered when a view changes its health state. This event can be used in event handlers to, for example, trigger an e-mail or Slack message. Please refer to [alerting](alerting.md) to understand how to set that up.

## Deleting views

Views can be deleted by selecting the **delete** menu option from the view context menu \(accessed either via the view name or the main hamburger menu\).

## Editing view settings

View settings can be edited by selecting the **edit** menu option from either the view context menu \(accessed either via the view name or the main hamburger menu\).

## Securing views \(RBAC\)

Through a combination of configuration of [permissions](../configure/permissions.md) and [scope](../configure/scopes_in_rbac.md), it is possible to give specific users:

* access to a specific subset of the topology \(a so-called scope\) and allowing them to create their own views
* access to specific views and disallowing them to create, modify or delete views

Please refer to the [RBAC documentation](../concepts/role_based_access_control.md).

