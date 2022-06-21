## The Azure StackPack is waiting for your action

To enable the Azure integration and begin collecting data from Azure, you will need to deploy the StackState Azure Agent to your Azure instance. The StackState Azure agent is a collection of Azure functions that connect to Azure REST API endpoints. You can deploy one or more StackState Azure Agents, each will collect data from resources related to the configured `Reader` roles in the Azure Service Principle.

1. Download the [manual installation zip file](/api/stackpack/azure/resources/{{configurationVersion}}/stackstate-azure-manual-installation.zip).

2. Make sure you have created a resource group in one of your subscriptions where the StackState Azure Agent can be deployed.

3. Run one of the install scripts below (bash or PowerShell), specifying the `Client Id` and `Client Secret` - these are the `appId` and `password` from the Service Principal that you created before installing the Azure StackPack.

### bash install script
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

### PowerShell install script

```
az login
./stackstate.monitor.ps1 `
-tenantId <Azure tenantId> `
-stsApiUrl {{config.baseUrl}} `
-stsApiKey {{config.apiKey}} `
-subscriptionId <Azure subscriptionId> `
-servicePrincipalId <Azure clientId> `
-servicePrincipalSecret <Azure clientSecret> `
-resourceGroupName <Azure resourceGroupName>
```

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState Azure StackPack](https://l.stackstate.com/ui-azure-support-troubleshooting).
