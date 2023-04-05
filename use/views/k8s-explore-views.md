---
description: StackState for Kubernetes troubleshooting
---

# Explore views

## Overview

In general, the concept of a _view_ in StackState allows you to monitor an area of your IT landscape that you had previously saved. But, often times when you need to investigate a subset of a particular view, you don't want to lose the scope of that view. This is where the **explore views** come into play.

To keep the scope of a particular view (e.g. 'my view') intact, all the investigative actions applied to a topology element or selection of elements (e.g. components, relations, groups) will automatically open in an **explore view**, under the view you have previously started from (e.g. 'my view / explore').

Examples of investigative actions that will automatically be opened in an **explore view**:
- The **+** button was clicked on a component in the _topology perspective_ to show the hidden neighbours of that component
- A quick action was executed on a component
- A topology element (component, relation, group) was double-clicked in the _topology perspective_ to investigate it
- The 'Explore...' button was clicked on a topology element (component, relation, group) to investigate it

**Explore views** can be saved as _custom views_, thus they inherit the same _filters_ and the same _perspectives_. 

If you don't want to save an **explore view**, simply move away from it and go back to the view you started from by using the breadcrumbs on the top navigation bar.

![](../../.gitbook/assets/k8s/k8s-menu.png)


## Filters

**Explore views** have the same _filters_ as _custom views_

![](../../.gitbook/assets/k8s/k8s-menu.png)


## Perspectives

**Explore views** have the same _perspectives_ as _custom views_

![](../../.gitbook/assets/k8s/k8s-menu.png)
