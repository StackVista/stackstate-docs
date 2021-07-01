# Create and edit views

## Create a view

{% hint style="info" %}
By default all views are visible to everybody. You can star a view to add it to your personal main menu for easy access. For securing/hiding views please refer to the [RBAC documentation](../../../configure/security/rbac/role_based_access_control.md).
{% endhint %}

To create a new view, navigate to **Explore Mode** via the hamburger menu or use another view as a starting point. Whenever you change any of the [View filters](../filters.md), a **Save View** button will appear at the top of the screen. Click this button to save your current selection to a view. To create a new view from the current view use the dropdown menu next to the button and select **Save View As**.

In the dialog the following options appear:

| Field Name | Description |
| :--- | :--- |
| View name | The name of the view. |
| View health state enabled | Whether the view has a health state. If this is disabled, thes health state, depicted by the colored circle next to the view name, will always be gray. When disabled, the StackState backend will not need to spend resources calculating a view health state each time the view changes. |
| Configuration function | When view health state is enabled, you can choose a [view state configuration function](../../../develop/developer-guides/custom-functions/view-health-state-configuration-functions.md#view-health-state-configuration-function-minimum-health-states) that is used to calculate the view health state whenever there are changes in the view. The default choice is **minimum health states**. |
| Arguments | The required arguments will vary depending on the chosen configuration function. |
| Identifier | \(Optional\) this field can be used to give the view a unique [identifier](../../../configure/identifiers.md). This makes the view uniquely referencable from exported configuration, like the exported configuration in a StackPack. |

## Delete or edit a view

{% hint style="info" %}
It is not recommended to delete or edit views created by StackPacks. When doing so, you will get a warning that the view is locked. If you proceed anyway the issue needs to be resolved when upgrading the StackPack that created the view.
{% endhint %}

To delete or edit a view:

1. Go to the list of views by clicking **Views** in the .
2. In the View Details pane on the right-hand side of the screen, select the context menu next \(accessed through the triple dots\) to the right of the view name.
3. Select the **Delete** or **Edit** menu item.