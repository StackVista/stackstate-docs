# Integrations and the StackPack SDK

StackState was specifically designed to integrate third-party data sources into a single real-time and time-traveling data model. This allows StackState users and StackState's AI to operate on the entire environment, independent of where the data originates from.

Developing an integration for StackState typically involves three steps:

### 1. Develop the integration's coupling

The first thing to do is to develop some code or some way of sending data to the StackState API from the source system.

The easiest way to get started developing an integration is by [developing an agent check](agent_check/how_to_develop_agent_checks.md). Agent checks are scripts that are executed periodically by an agent to pull data \(topology, telemetry or traces\) from the system you are integrating with and push it to StackState.

In addition to pushing data, telemetry can also be pulled by StackState. This is known as [mirroring](mirroring.md). Mirrored telemetry is not stored by StackState, but retrieved whenever StackState requires telemetry from that datasource.

### 2. Configure StackState to process the incoming data

StackState does not automatically process incoming data into the 4T data model, but must be configured to do so. Without configuration any incoming data will just sit in StackState's topics. Decoupling between the data format and its representation in the 4T data model allows for greater flexibility in fine-tuning the 4T data model for specific situations.

For topology integrations use the [Custom Synchronization StackPack](../stackpacks/integrations/customsync.md) to test the topology in StackState. Also, take care that your topology is able to merge with other topologies \(see section below\).

### 3. Create a StackPack to manage the installation and lifecycle of the integration

[Create a StackPack](stackpack/) to easily ship all necessary code, documentation and configuration for your integration. Users can install your integration through the StackPack UI, CLI or API.

Each StackPack is versioned and has a managed lifecycle. If you make any changes to your code and/or configuration you can push out a new version of your StackPack to a StackState instance and the upgrade process will be taken care of by StackState, either fully automatically or semi-automatically \(in conjunction with the user\). Configuration made by a StackPack in StackState is automatically protected from changes by the user to ensure the upgrade process remains under complete control of the StackPack developer.

## Merging topology with other topology sources

StackState automatically merges topology from different data sources into a single topology. It does this by finding common identifiers on topological components. If any [synchronization](synchronizations_and_templated_files.md) creates a component that has one or more overlapping identifiers with existing components then that component is merged using the merge strategy of the originating two or more synchronizations.

In the topology each component has an `identifiers` field. This field is populated by the component template that is used by the synchronization. Identifiers are text strings that do not need to follow any format, unlike the `identifier` field of configurable nodes that are provided by the StackPacks \(e.g. Sync, CheckFunction, Layer, etc.\) which need to be valid URNs.

Care has to be taken in choosing the identifiers when building a topology integration that should merge with existing topology integrations. If a component is known to AWS, make sure it has an ARN, if it is known to Azure, make sure it has a ObjectId, etc. You should make sure the identifiers match exactly, i.e. case sensitive. Consult the code of the StackPack you wish to integrate with in order to make sure you get it right.

Once two or more components are merged you will see the combined checks, telemetry, labels and identifiers of both multiple components on a single component. This is taken care of fully automatically.
