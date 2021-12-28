# How to configure a custom synchronization

## Overview

Synchronizations are defined by a data source and several mappings from the external system topology data into StackState topology elements using Component and Relation Mapping Functions, as well as Component and Relation Templates. `Custom Synchronization` StackPack delivers a Synchronization called `default auto synchronization`. You can [find more on Synchronizations](../synchronizations_and_templated_files.md) or proceed to edit `default auto synchronization` following the instructions below.

## Edit default auto synchronization

### Step 1

It is recommended that you change the `Synchronization Name` and add a `Description` if needed. There is no action required on `Plugin`, it uses the `Sts` plugin to synchronize data from the StackState Agent.

### Step 2

There is no action needed here. However, you can observe the data source, component, and relation identity extractor, as well as whether this synchronization processes historical data. The recommended setting here is to keep this setting off.

### Step 3

This is where the Component Mappings are defined. The `Custom Synchronization` StackPack defines a `default component mapping` which can be seen at the bottom of the wizard for all "Other Sources".

Here you can define all your own component mappings for different resources.

### Step 4

This is where the Relation Mappings are defined. The `Custom Synchronization` StackPack defines a `default relation mapping` which can be seen at the bottom of the wizard for all `Other Sources`.

Here you can define all your own relation mappings for different sources.

### Step 5

Verify all the changes and click "Save". On the popup dialog that appears right after saving click "Confirm" to unlock this synchronization from the `Custom Synchronizations` StackPacks.

