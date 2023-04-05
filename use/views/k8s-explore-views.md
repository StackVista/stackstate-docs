---
description: StackState for Kubernetes troubleshooting
---

# Explore views

## Overview

In general, the concept of a _view_ in StackState allows you to monitor or easily go back to a particular area of your IT landscape that you had previously saved. But, often times when you need to investigate a subset of a particular view, you don't want to lose the scope of that view. This is where the **explore views** come into play.

To keep the scope of a particular view intact (e.g. 'my view'), all the investigative actions applied to a topology element (e.g. a component or a relation) or to a selection of topology elements (e.g. a group of components or a group of relations) will automatically open in an **explore view**, under the view you have started from (e.g. 'my view / explore').

Examples of investigative actions that will automatically be opened in an **explore view**:
- The **+** button was clicked on a component in the _topology perspective_ to show the hidden neighbours of that component
- A quick action was executed on a component
- A topology element (component, relation, group) was double-clicked in the _topology perspective_ to investigate it
- The 'Explore...' button was clicked on a topology element (component, relation, group) to investigate it

![](../../.gitbook/assets/k8s/k8s-menu.png)

**Explore views** can be saved as _custom views_, thus they will inherit the same _filters_ and the same _perspectives_ as _regular views_.

If you don't want to save an **explore view**, simply close it and go back to the originating view you started from by using the breadcrumbs on the top navigation bar.


## Filters

**Explore views** have the same _filters_ as _regular views_

![](../../.gitbook/assets/k8s/k8s-menu.png)


## Perspectives

**Explore views** have the same _perspectives_ as _regular views_

![](../../.gitbook/assets/k8s/k8s-menu.png)

All other Kubernetes resources are recognized and visualized in the topology views.
