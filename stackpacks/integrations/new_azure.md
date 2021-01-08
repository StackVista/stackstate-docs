---
description: In-depth monitoring of Azure resource types
---

# Azure

## Overview

Microsoft Azure is a cloud computing service created by Microsoft for building, testing, deploying, and managing applications and services. This StackPack enables in-depth monitoring of the following Azure resource types:

| | | |
|:---|:---|:---|
| Azure Kubernetes Service (AKS) | Function Apps | SQL Servers |
| Application Gateways | Key Vault storage | Storage Accounts |
| Application Insights | Load Balancers | Virtual Machines |
| App Service Plans| Network Interfaces | Virtual Networks |
| Availability Sets | Network Security Groups | Web Apps |
| Compute Disks | Operations Management | |
| Event Hubs | Public IP Addresses| |

![Data flow](/.gitbook/assets/stackpack-azure.png)

- StackState Azure functions connect to the [Azure APIs](#rest-api-endpoints) every 2 hours to collect information about available resources.
- The Azure function `SendToStackState` pushes [retrieved data](#data-retrieved) to StackState.
- StackState translates incoming data into topology components and relations.
- The StackState Azure plugin pulls telemetry data on demand from Azure.
- StackState maps retrieved telemetry onto the associated Azure components and relations.

## Setup

### Pre-requisites

To set up the StackState Azure integration, you need to have:

- PowerShell version >= 5.0 or Bash.
- The [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).
- A Resource Group where the StackState resources can be deployed. We recommend that you create a new resource group for StackState.
- An Azure Service Principal (SPN) for the StackState Azure Agent.

### Install StackPack

Install the Azure StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Azure instance name** - 
* **Client Id** - the client id of the Azure Service Principal.
* **Client Secret** - the client secret used to authenticate the client.
* **Tenant Id** - the Id of the Azure Tenant / Active Directory.

### Deploy Azure Agent

To enable the Azure integration and begin collecting data from Azure you will need to deploy the StackState Azure Agent to your Azure instance. You can deploy one or more StackState Azure Agents, each will collect data from resources related to its configured Azure Service Principle.


### Status

To check the status of the Azure integration,

## Integration details

### Data retrieved

#### Events



#### Metrics



#### Topology



| Data | Description |
|:---|:---|
|  |  |
|  |  | 

#### Traces



### REST API endpoints


### Open source


## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=DynaTrace).

## Uninstall


## Release notes


## See also