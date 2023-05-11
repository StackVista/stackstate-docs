---
description: StackState for Kubernetes troubleshooting
---

# Custom views

## Overview

Whilst a [kubernetes view](k8s-views.md) acts as a starting point to explore a specific part of your IT landscape, and an [explore view](k8s-explore-views) allows you to investigate a subset of a particular view, a **custom view** provides a way for you to get back to any of these views. 

In other words, you can create a custom view by saving a kubernetes view or an explore view with your own settings (filters, visualization options, view settings, timeline configuration) to bookmark a part of your topology that's of particular interest to you or your team.

By default, custom views will be visible to all users, these can be [secured by a StackState administrator](about_views.md#secure-views-with-rbac) if required. 

## Handling

### Create a view

To create a new custom view, click the "Save view as..." blue button on the top navigation bar when you're on a kubernetes view or an explore view. To create a new view from a modified custom view, use the dropdown menu next to the button and select **Save View As**.

In the **Save view as** dialog, the following options can be set:

| Field Name | Description |
| :--- | :--- |
| View name | The name of the view. |
| View health state enabled | Whether the view has a health state. If this is disabled, the health state, depicted by the colored circle next to the view name, will always be gray. When disabled, the StackState backend won't need to spend resources calculating a view health state each time the view changes. |
| Configuration function | When view health state is enabled, you can choose a function that's used to calculate the view health state whenever there are changes in the view. The default choice is **minimum health states**. |
| Arguments | The required arguments will vary depending on the chosen configuration function. |

{% hint style="success" "self-hosted info" %}

* You can build your own [view state configuration functions](../../../develop/developer-guides/custom-functions/view-health-state-configuration-functions.md#view-health-state-configuration-function-minimum-health-states) to customize how the view health state is calculated.
* Views can be given an optional identifier. [Identifiers](../../../configure/topology/identifiers.md) can be used to uniquely reference the view from exported configuration, such as the exported configuration in a StackPack.
* Views can be [secured by a StackState administrator](about_views.md#secure-views-with-rbac).

{% endhint %}

### Reset a view

When a custom view is created, all the filters, visualization options, view settings and the timeline configuration are saved on the view. This is helpful if you want to reset the custom view to its original state after you have made some changes to it.

### Delete or edit a view

{% hint style="info" %}
* It isn't recommended to delete or edit views created by StackPacks. When doing so, you will get a warning that the view is locked. If you proceed anyway the issue needs to be resolved when upgrading the StackPack that created the view.
* Note that changes made to a view will be applied for all users.
{% endhint %}

A saved view can be edited or deleted from either the **all views** screen, or the right panel **View summary** tab.

1. All views screen:
   * Click **Views** in the main menu to open the **all views** screen.
   * Hover over the view you would like to edit or delete.
   * Click the **Edit view** or **Delete view** button on the right.
2. Right panel **View summary** tab:
   * Open the view.
   * Open the triple dots menu (to the right of the view name in the right panel **View summary** tab).
   * Click **Edit** or **Delete**.

## Structure

The explore views have an identical structure to the [custom views](k8s-custom-views.md): they have the same [filters](k8s-view-structure.md#filters) and the same [perspectives](k8s-view-structure.md#perspectives).

![Explore views structure](../../.gitbook/assets/k8s/k8s-explore-views-structure.png)