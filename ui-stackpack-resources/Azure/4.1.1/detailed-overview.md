### Prerequisites

To set up the Rancher Observability Azure integration, you need to have:

- PowerShell version >= 5.0 or Bash.
- The [Azure CLI](https://l.stackstate.com/ui-azure-cli).
- A Resource Group where the Rancher Observability resources can be deployed. We recommend that you create a separate resource group for all the resources related to Rancher Observability.
- An Azure Service Principal (SPN) for the Rancher Observability Azure Agent with the following permissions:
    - `Contributor` role for the StackPack Resource Group to deploy and delete resources.
    - `Reader` role for each of the subscriptions the StackPack instance will monitor.

### Data retrieved

#### Events

The Azure integration doesn't retrieve any Events data.

#### Metrics

Metrics data is pulled on demand directly from Azure by the Rancher Observability Azure plugin, for example when a component is viewed in the Rancher Observability UI or when a health check is run on the telemetry stream. Retrieved metrics are mapped onto the associated topology component.

#### Topology

Each Azure integration retrieves topology data for resources associated with the associated Azure Service Principal.

| Data | Description |
|:---|:---|
| Components | Components retrieved from Azure are tagged with the associated Azure `instance_name`, `resource_group` and `subscription_name`. |
| Relations |  | 

#### Traces

The Azure integration doesn't retrieve any Traces data.

### REST API endpoints

For details of the Azure REST API endpoints used by the Azure integration uses the following, see the [Azure StackPack docs](https://l.stackstate.com/ui-azure-api-endpoints).


### Rancher Observability Azure functions

There are a number of methods in the `TopologyDurableFunction` class:

| Function | Description | 
|:---|:---|
| `TimedStart` | Timed trigger to start the MainOrchestrator. |
| `HttpStart` | HTTP trigger to start the MainOrchestrator manually for testing or after a first deployment from the StackPack. |
| `MainOrchestrator` | The orchestrator containing the main workflow: GetSubscriptions -> HandleSubscription (for each subscription) -> SendToRancher Observability. |
| `GetSubscriptions` | Fetches all subscriptions that the service principle has access to. |
| `HandleSubscription` | Sub-orchestrator, contains the workflow: GetResourcesToInclude -> ConvertResourcesToRancher ObservabilityData (for each set of resources, grouped by type) |
| `GetResourcesToInclude` | Fetches all resources in a subscription and filters out those that are ignored. |
| `ConvertResourcesToRancher ObservabilityData` | Receives a group of resources and calls the ResourceTypeConverter class in the Core project. |
| `ConvertResourcesToRancher ObservabilityDataInner` | Regular method containing the actual implementation of ConvertResourcesToRancher ObservabilityData. Result is an instance of the class Synchronization. |
| `SendToRancher Observability` |Receives a Synchronization object and sends it to Rancher Observability. |
| `PurgeHistory` | Durable functions store their state and history in Azure Blob Storage. This Azure Function does a daily cleanup of the data from the currentdate -2 months to the currentdate -1 month. |

### Azure views in Rancher Observability

When the Azure integration is enabled, a view will be created in Rancher Observability for each instance of the StackPack. Each view shows components filtered by the Azure `instance_name` tag and is named **Azure_\[instance_name\]**.

