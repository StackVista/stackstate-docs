---
title: Azure StackPack
kind: documentation
---

# Azure

{% hint style="warning" %}
This page describes StackState version 4.1.  
Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## What is the Azure StackPack?

Microsoft Azure is a cloud computing service created by Microsoft for building, testing, deploying, and managing applications and services. This StackPack enables in-depth monitoring of the following Azure resource types:

* Azure Kubernetes Service \(AKS\)
* Application Gateways
* Application Insights
* App Service Plans
* Availability Sets
* Compute Disks
* Event Hubs
* Key Vault storage
* Load Balancers
* Network Interfaces
* Network Security Groups
* Operations Management
* Public IP Addresses
* SQL Servers
* Storage Accounts
* Virtual Machines
* Virtual Networks
* Web Apps
* Function Apps

_Do note_ that all resources in the subscriptions will be visible inside of StackState.

StackState maps Azure telemetry information as telemetry onto your Azure components, monitoring their health and alerting you to issues when necessary.

## Prerequisites

The Azure StackPack has the following prerequisites:

* A Service Principal, to create this read the documentation [here](https://docs.microsoft.com/en-us/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac). Store the secret that is created: you cannot retrieve it later on.
* PowerShell version &gt;= 5.0 or Bash
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* A Resource Group where the StackState resources can be deployed. \(We propose to create a new resource group for StackState\)
* An Azure Service Principal \(SPN\) for the StackState lightweight agent.

## Installation

The Azure StackPack requires the following parameters:

* Client Id -- the client id of the Azure Service Principal.
* Client Secret -- the client secret used to authenticate the client.
* Tenant Id -- the Id of the Azure Tenant / Active Directory.

### Azure Service Principal

Use the Service Principal you created before installing the StackPack and use its `appId` and `password` as `Client Id` and `Client Secret` in the scripts below.

### Setting up your Azure environment for the StackState Agent

_Azure Resource Group_

To install the Azure StackPack, we suggest that you create a separate resource group where you can deploy all the StackState related resources.

### Manually deploy the StackState Agent

1. Download the **manual installation zip file** from the Azure StackPack configuration page in your StackState instance and extract it.
2. Create a resource group in one of your subscriptions where StackState can be deployed.
3. Run:

{% tabs %}
{% tab title="bash" %}
```bash
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
```text
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

## Advanced setup

This section is intended for advanced users who need more control over the Service Principal and its rights.

### Azure Service Principal \(SPN\)

To install the Azure StackPack, a Service Principal is needed that has these permissions:

* `Contributor` role for the StackPack resource group to deploy and delete resources.
* `Reader` role for each of the subscriptions you want to monitor.

