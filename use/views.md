---
title: Views
kind: Documentation
aliases:
  - /usage/views/
listorder: 2
---

# Views

The topology in StackState is likely much bigger than what you care about at any given point in time. StackState allows you to filter the topology in a **view** so you can locate the part of the topology you are interested in.

## Accessing views

Views can be accessed by clicking on the Views link in the top navigation bar or using the hamburger menu in the top left corner. When you select a view, StackState will show the components in the view and restrict all further information \(telemetry, problems, events\) to only those components.

## Creating views

To create a new view, navigate to **Explore Mode** via the hamburger menu. Explore Mode shows you all components in StackState. If your IT landscape is too big, StackState will encourage you to narrow your search by [filtering topology](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/use/browsing_topology/README.md) in the view.

When a view is modified or you created a new view starting from Explore Mode, a **Save As View** button will appear at the top of the screen. Click this button to save \(the changes to\) your view.

## View health state

Every individual/team has a different definition of when the part of the environment they are watching over is in danger. View health state can be used to indicate when the whole, as defined in a view, is in danger. The view can be in three states:

* Green - `CLEAR` - There is nothing to worry about.
* Orange - `DEVIATING` - Something may require your attention.
* Red - `CRITICAL` - Attention is needed right now, because something is broken.

To enable view health state set switch `View Health State Enabled` to on. This can be done in the dialog when saving a new view or editing an existing one. This is also where the [view health state function](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/view_state_configuration/README.md) is configured, which determines how to . Often this will be the number of components to be deviating or critical before the view health state changes.

## Alerting on view health state

An activity event is triggered when a view changes its health state. This event can be used in event handlers to, for example, trigger an e-mail or Slack message. Please refer to [alerting](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/use/alerting/README.md) to understand how to set that up.

## Deleting views

Views can be deleted by selecting the **delete** menu option from the view context menu \(accessed either via the view name or the main hamburger menu\).

## Editing view settings

View settings can be edited by selecting the **edit** menu option from either the view context menu \(accessed either via the view name or the main hamburger menu\).

## Securing views \(RBAC\)

Through a combination of configuration of [permissions](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/permissions/README.md) and [scope](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/configure/scopes_in_rbac/README.md), it is possible to give specific users:

* access to a specific subset of the topology \(a so-called scope\) and allowing them to create their own views
* access to specific views and disallowing them to create, modify or delete views

Please refer to the [RBAC documentation](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/concepts/role_based_access_control/README.md).

