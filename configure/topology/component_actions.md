# Component actions

{% hint style="warning" %}
This page describes StackState version 4.1.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Component Actions in StackState provide an ability to act based on various events and inputs provided by StackState monitoring capabilities. This functionality provides users with configurable Actions that can be executed from the component context menu in the Topology View.

![Component Actions](/.gitbook/assets/quick_component_actions.png)

Component Actions can be configured within StackState Settings or can be predefined in a StackPack.

## What is a Component Action?

A Component Action is a script that can be executed for components bound to that script with an [STQL query](/develop/reference/stql_reference.md). A Component Action consists of a unique name that is case-sensitive, an STQL bind that selects components, and a script that determines the action's behavior. There are also optional fields for providing a description and an Identifier.

## Component Actions in use

Component Actions allow for a wide range of operations on components, for example:

* Repair actions - restart AWS EC2 instance when StackState reports that instance crashed.
* Navigation actions - Navigate to the AWS Management Console of a component showing erratic behavior.
* Reporting actions - Show a report that predicts the next 24 hours of CPU usage of a Kubernetes pod.

## How to get Component Actions?

There are two ways of getting Component Actions in StackState:

1. Import of Actions predefined in a StackPack
2. Configuring a new Action in the Settings page

In the case of importing Components Actions with a StackPack, these Actions appear as locked items on the Settings page. Editing them unlocks the Component Action, but it may prevent the StackPack from correct upgrades in the future. It is possible to restore the locked status of a Component Action by reinstalling the StackPack that contains the definition of the unlocked Component Action.

When configuring a new Component Action in the Settings page, follow the instructions from [How to configure Component Actions](/configure/topology/how_to_configure_component_actions.md) page.
