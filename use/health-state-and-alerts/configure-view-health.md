---
description:
---

# Configure the view health

Often it is not desirable to react to each event, because that can cause a lot of noise. If one or multiple components cause some impact on a service than we do not want to report on each state change, but only on the changes to the problem itself. In StackState this is done through the health of the view. The health of a view is determined by the health of the components and relations in the view. Whenever a view changes its health state this triggers an view state state event that can be handled with an event handler on the view.

Each view in StackState has a health state, just like component and relations have a health state. The health of a view is determined by the view health configuration. To configure the health of a view:

1. Select a view.
2. On the top bread crumb next to the name of the view click on the drop down arrow.
3. In the drop down menu click on `Edit`.
4. Make sure `view health state` is enabled. A `edit query view` dialog appears.
5. Select an configuration function. Each configuration function determines the health of the view in its own way based on the components and relations that are visible within the view. Some may count the number of components that have a certain health state, others may lend some special status to a certain component, etc. If you want to know what an view health state configuration function does exactly or want to create your own view health state configuration function then you can find a full listing of all view health state configuration functions under the `settings / view health state configuration functions` page.
6. Each configuration function has different arguments that need to be supplied. These arguments determine the behavior of the view health state configuration function.
7. Click `Update` to save the new configuration to the view. The view health updates immediately.