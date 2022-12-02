---
description: StackState Self-hosted v5.1.x 
---

# Component actions

## Overview

A Component Action is a script bound to specific components in the topology with an [STQL query](../../develop/reference/stql_reference.md). Each Component Action consists of a unique, case-sensitive name, an STQL query, and a script determining the action's behavior. There are also optional fields to provide a description and an identifier.

## Component Actions in use

Component Actions open the possibility for a wide range of operations on components, for example:

* Repair actions - restart AWS EC2 instance when StackState reports that instance crashed.
* Navigation actions - Navigate to the AWS Management Console of a component showing erratic behavior.
* Reporting actions - Show a report that predicts the next 24 hours of CPU usage of a Kubernetes pod.

You will find the Component Actions that can be executed for a component under **Actions** in the component context menu (when you hover over the component) and in the right panel details tab when the component is selected - **Component details**. Note that Component Actions are only available for execution on components that match the defined STQL query. 

![Component Actions](../../.gitbook/assets/v51_actions.png)

## How to get Component Actions

There are two ways to get Component Actions in StackState:

1. Import of Actions predefined in a StackPack
2. Configure a new custom Action in the Settings page

Component Actions imported with a StackPack appear as locked items in the StackState UI page **Settings** &gt; **Actions** &gt; **Component Actions**. 

Editing a locked Component Action will unlock it, which may prevent the StackPack from correct upgrades in the future. To restore the locked status of a Component Action, reinstall the StackPack that imported it.

Find out [how to configure Component Actions](../../develop/developer-guides/custom-functions/component-actions.md).

