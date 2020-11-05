---
description: Report the health state for a complete view
---

# Configure the view health

Reacting to each event in an environment can cause a lot of noise. This may be both undesirable and unnecessary. For example, if one or multiple components have an impact on a service, it can be sufficient to report on changes to the problem itself and not on each related state change.

In StackState this is done by looking at the health of a **view**. The health of a view is determined by the combined health of the components and relations in the view. When a view changes its health state, this triggers an view state event that can in turn trigger an alert or automated action.

## Configure a view health state

1. Select a view.
2. On the top bread crumb next to the name of the view click on the drop down arrow.
3. In the drop down menu click on `Edit`.
4. Make sure `view health state` is enabled. A `edit query view` dialog appears.
5. Select an configuration function. Each configuration function determines the health of the view in its own way based on the components and relations that are visible within the view. Some may count the number of components that have a certain health state, others may lend some special status to a certain component, etc. If you want to know what an view health state configuration function does exactly or want to create your own view health state configuration function then you can find a full listing of all view health state configuration functions under the `settings / view health state configuration functions` page.
6. Each configuration function has different arguments that need to be supplied. These arguments determine the behavior of the view health state configuration function.
7. Click `Update` to save the new configuration to the view. The view health updates immediately.

## React to view state changes