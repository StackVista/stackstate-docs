---
description: Report the health state for a complete view.
---

# Configure the view health

## Overview

Reacting to each event in an environment can cause a lot of noise. This may be both undesirable and unnecessary. For example, if one or multiple components have an impact on a service, it can be sufficient to report on changes to the problem itself and not each related state change. 

StackState can reduce this noise by looking at the overall health state of a **view** rather than that of individual elements. The view health state is determined by the combined health of its elements. When a view changes its health state, a view state change event is triggered and that can in turn trigger an alert or automated action.

![Views list with view health state](/.gitbook/assets/v41_views_list.png)

## Configure a view health state

View health state is calculated by a **view state configuration function**.  To configure a view to report its health state:

1. In the StackState UI, go to the **Views** list.
2. Click on the pencil icon next to a view name to edit the view.
3. Set **View Health State Enabled** to **On**.
4. Select a **Configuration function** to use to calculate the view health. 
    - You can use the standard view state configuration function or [create your own](/configure/view_state_configuration.md).
    - For details of the available configuration functions, go to Settings > Functions > View Health State Configuration Functions.
6. Provide any required configuration function arguments. These arguments determine the behavior of the view health state configuration function and will vary according to the function selected.
7. Click **UPDATE** to save the new configuration to the view. 
    - The view health will update immediately.
    
![Edit query view](/.gitbook/assets/v41_edit_query_view.png)

## React to view state changes

You can [set up alerting](/use/health-state-and-alerts/set-up-alerting.md) to trigger alerts and actions whenever a view state changes.

## See also

- [View state configuration](/configure/view_state_configuration.md)
- [Add a health check](/use/health-state-and-alerts/add-a-health-check.md)
- [Set up alerting](/use/health-state-and-alerts/set-up-alerting.md)