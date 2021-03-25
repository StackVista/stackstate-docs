---
old-description: In-depth monitoring of Azure resource types
---

# Azure

{% hint style="warning" %}

This page describes StackState version 4.2.<br />Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

Microsoft Azure is a cloud computing service created by Microsoft for building, testing, deploying, and managing applications and services. This StackPack enables in-depth monitoring of the following Azure resource types:

| | | 
|:---|:---|:---|
| Azure Kubernetes Service (AKS) | Function Apps | SQL Servers |
| Application Gateways | Key Vault storage | Storage Accounts |
| Application Insights | Load Balancers | Virtual Machines |
| App Service Plans| Network Interfaces | Virtual Networks |
| Availability Sets | Network Security Groups | Web Apps |
| Compute Disks | Operations Management | |
| Event Hubs | Public IP Addresses| |

![Data flow](/.gitbook/assets/stackpack-azure.png)

- The StackState Azure Agent is [a collection of Azure functions](#stackstate-azure-functions) that connect to the [Azure APIs](#rest-api-endpoints) at a configured interval to collect information about available resources.
- The StackState Azure function `SendToStackState` pushes [retrieved data](#data-retrieved) to StackState.
- StackState translates incoming data into topology components and relations.
- The StackState Azure plugin pulls available telemetry data per resource on demand from Azure, for example when a component is viewed in the StackState UI or when a health check is run on the telemetry stream.
- StackState maps retrieved telemetry (metrics) onto the associated Azure components and relations.

## Setup

### Prerequisites

To set up the StackState Azure integration, you need to have:

- PowerShell version >= 5.0 or Bash.
- The [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).
- A Resource Group where the StackState resources can be deployed. We recommend that you create a separate resource group for all the resources related to StackState.
- An Azure Service Principal (SPN) for the StackState Azure Agent with the following permissions:
    - `Contributor` role for the StackPack Resource Group to deploy and delete resources.
    - `Reader` role for each of the subscriptions the StackPack instance will monitor.

### Install StackPack

Install the Azure StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Azure instance name** - the user-defined name of the Azure instance shown in configurations such as views.
* **Client Id** - the client id of the Azure Service Principal.
* **Client Secret** - the client secret used to authenticate the client.
* **Tenant Id** - the Id of the Azure Tenant / Active Directory.

### Deploy Azure Agent

To enable the Azure integration and begin collecting data from Azure, you will need to deploy the StackState Azure Agent to your Azure instance. The StackState Azure agent is a collection of [Azure functions](#stackstate-azure-functions) that connect to [Azure REST API endpoints](#rest-api-endpoints). You can deploy one or more StackState Azure Agents, each will collect data from resources related to the configured `Reader` roles in the Azure Service Principle.

1. Download the manual installation zip file. This is included in the Azure StackPack and can be accessed at the link provided in StackState after you install the Azure StackPack.

2. Make sure you have created a resource group in one of your subscriptions where the StackState Azure Agent can be deployed.

3. Run one of the install scripts below, specifying the `Client Id` and `Client Secret` - these are the `appId` and `password` from the Service Principal you created before installing the Azure StackPack.

{% tabs %}
{% tab title="Bash" %}
```
./stackstate.monitor.sh \
    <Azure tenantId> \
    {{config.baseUrl}} \
    {{config.apiKey}} \
    <Azure subscriptionId> \
    <Azure clientId> \
    <Azure clientSecret> \
    <Azure resourceGroupName>
```
{% endtab %}
{% tab title="Powershell" %}
```
az login
az login
./stackstate.monitor.ps1 `
-tenantId <your tenantId> `
-stsApiUrl {{config.baseUrl} `
-stsApiKey {{config.apiKey}} `
-subscriptionId <azure subscriptionId> `
-servicePrincipalId <Client Id> `
-servicePrincipalSecret <Client Secret> `
-resourceGroupName <Resource GroupName to deploy to>
```
{% endtab %}
{% endtabs %}

### Status

You can check the status of the Azure integration in Azure resource group. Open the **FunctionApp** and check the available metrics or the full list of **Functions** from the left menu. The status of all functions should be **Enabled**.

![Azure FunctionApp](/.gitbook/assets/azure_functionApp.png)

![StackState Azure functions](/.gitbook/assets/azure_all_functions.png)

### Upgrade

When a new version of the Azure StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **Azure**. For a quick overview of recent StackPack updates, check the [StackPack versions](../../setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

For considerations and instructions on upgrading a minor or patch release of a StackPack, see [how to upgrade a StackPack](/stackpacks/about-stackpacks.md#upgrade-a-stackpack).

To upgrade to a new major release of the Azure StackPack:

1. Completely remove the StackState Azure resources, either in Azure directly or using the provided deprovisioning script, and uninstall the current StackPack. For details see [uninstall the Azure StackPack](#uninstall).
2. Install the new version from the page **StackPacks** &gt; **Integrations** &gt; **Azure**.
3. Install the new StackState Azure resources using the install script, see [deploy the StackState Azure agent](#deploy-azure-agent).


## Integration details

### Data retrieved

#### Events

The Azure integration does not retrieve any Events data.

#### Metrics

Metrics data is pulled on demand directly from Azure by the StackState Azure plugin, for example when a component is viewed in the StackState UI or when a health check is run on the telemetry stream. Retrieved metrics are mapped onto the associated topology component.

#### Topology

Each Azure integration retrieves topology data for resources associated with the associated Azure Service Principal.

| Data | Description |
|:---|:---|
| Components | Components retrieved from Azure are tagged with the associated Azure `instance_name`, `resource_group` and `subscription_name`. |
| Relations |  | 

#### Traces

The Azure integration does not retrieve any Traces data.

### REST API endpoints

The Azure integration uses the following Azure REST API endpoints, scroll right for the SDK details:

| Resource | Endpoint | SDK (Version) |
| ----------- | ----------- | ----------- |
|  AKS Managed Cluster     | resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters?api-version=2018-03-31       | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0)   |
|  Availability Sets     | resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets?api-version=2018-06-01       | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0)   |
|  ApplicationGateways     | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways?api-version=2018-04-01       | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0)   |
|  ApplicationInsights     | providers/Microsoft.Insights/components?api-version=2015-05-01       | Microsoft.Azure.Management.ApplicationInsights (0.2.0-preview)   |
|  Classic Storage Account     | resourceGroups/{resourceGroupName}/providers/Microsoft.ClassicStorage/storageAccounts?api-version=2016-11-01       | None |
|  Classic Storage Account Keys | resourceGroups/{resourceGroupName}/providers/Microsoft.ClassicStorage/storageAccounts/{accountName}/listKeys?api-version=2016-11-01       | None |
|  Classic Cloud Services     | resourceGroups/{resourceGroupName}/providers/Microsoft.ClassicCompute/domainNames?api-version=2018-06-01       | None |
|  Classic Cloud Services Deployment Slots | resourceGroups/{resourceGroupName}/providers/Microsoft.ClassicCompute/domainNames/{cloudServiceName}/deploymentSlots/{stage}?$expand=roles/instances?api-version=2018-06-01       | None |
|  Compute Disks | resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/disks?api-version=2018-04-01       | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Eventhub Namespaces | resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces?api-version=2017-04-01       | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  KeyVault | resources?$filter=resourceType eq 'Microsoft.KeyVault/vaults'&api-version=2015-11-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) | 
|  LoadBalancers | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  NetworkInterfaces | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  NetworkSecurityGroups | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  PublicIPAddresses | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  RouteTables | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  ServerFarms | resourceGroups/{resourceGroupName}/providers/Microsoft.Web/serverfarms?api-version=2018-02-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  SQL Servers | resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers?api-version=2015-05-01-preview   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) | 
|  SQL Server ElasticPools | resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/elasticPools?api-version=2014-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  SQL Server Databases | resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases?api-version=2014-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Storage Accounts | resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts?api-version=2017-10-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Storage Account Keys | resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/listKeys?api-version=2017-10-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Traffic Manager Profiles | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficmanagerprofiles?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Virtual Machine | resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines?api-version=2018-06-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Virtual Networks | resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks?api-version=2018-04-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |
|  Web Apps | resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites?api-version=2017-10-01   | Microsoft.Azure.Management.ResourceManager.Fluent (1.18.0) |

### StackState Azure functions

There are a number of methods in the `TopologyDurableFunction` class:

| Function | Descrtipion | 
|:---|:---|
| `TimedStart` | Timed trigger to start the MainOrchestrator. |
| `HttpStart` | HTTP trigger to start the MainOrchestrator manually for testing or after a first deployment from the StackPack. |
| `MainOrchestrator` | The orchestrator containing the main workflow:<br />GetSubscriptions -><br >HandleSubscription (for each subscription) -><br />SendToStackState. |
| `GetSubscriptions` | Fetches all subscriptions that the service principle has access to. |
| `HandleSubscription` | Sub-orchestrator, contains the workflow:<br />GetResourcesToInclude -><br />ConvertResourcesToStackStateData (for each set of resources, grouped by type) |
| `GetResourcesToInclude` | Fetches all resources in a subscription and filters out those that are ignored. |
| `ConvertResourcesToStackStateData` | Receives a group of resources and calls the ResourceTypeConverter class in the Core project. |
| `ConvertResourcesToStackStateDataInner` | Regular method containing the actual implementation of ConvertResourcesToStackStateData. Result is an instance of the class Synchronization. |
| `SendToStackState` |Receives a Synchronization object and sends it to StackState. |
| `PurgeHistory` | Durable functions store their state and history in Azure Blob Storage. This Azure Function does a daily cleanup of the data from the currentdate -2 months to the currentdate -1 month. |

### Azure views in StackState

When the Azure integration is enabled, a [view](/use/views/README.md) will be created in StackState for each instance of the StackPack. Each view shows components filtered by the Azure `instance_name` tag and is named **Azure_\[instance_name\]**.

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState Azure StackPack](https://support.stackstate.com/hc/en-us/articles/360016450300-Troubleshooting-StackState-Azure-StackPack).

## Uninstall

The Azure StackPack can be uninstalled by clicking the *Uninstall* button from the StackState UI **StackPacks** &gt; **Integrations**  &gt; **Azure** screen. This will remove all Azure specific configuration in StackState. You can also stop and delete the created resources (within the resource group specified when running the manual installation). They have been labeled with the tag `StackState`.

To do so, you can use the scripts in the manual installation zip file you downloaded when installing the StackState Azure agent. You can download this file again at anytime from the StackState UI **StackPacks** &gt; **Integrations**  &gt; **Azure** screen.

{% tabs %}
{% tab title="Bash" %}
```bash
./stackstate.monitor.deprovisioning.sh \
    <your TENANT_ID> \
    {{config.baseUrl}}
```
{% endtab %}
{% tab title="Powershell" %}
```powershell
./stackstate.monitor.deprovisioning.ps1 `
-tenantId <your TENANT_ID> `
-stsApiUrl {{config.baseUrl}}
```
{% endtab %}
{% endtabs %}

## Release notes

**Azure StackPack 4.0.1 (2020-08-18)**

- Feature: Introduced the Release notes pop up for customer

**Azure StackPack 4.0.0 (2020-08-04)**

- Bugfix: Fix and make Component mapping function per instance to support multi-instance properly.
- Improvement: Deprecated stackpack specific layers and introduced a new common layer structure.

**Azure StackPack 3.0.1 (2020-06-10)**

- Improvement: Added urn:host based identifiers for Azure VM's

**Azure StackPack 3.0.0 (2020-05-19)**

- Feature: Added multi-instance support for the Azure StackPack


## See also

- [Troubleshooting the Azure StackPack](https://support.stackstate.com/hc/en-us/articles/360016450300-Troubleshooting-StackState-Azure-StackPack)
- [Service principals in Azure \(microsoft.com\)](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object)
