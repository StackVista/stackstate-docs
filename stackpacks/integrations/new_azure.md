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

![Data flow](/.gitbook/assets/stackpack-azure2.png)

- The StackState Azure Agent - a collection of Azure functions - connects to the [Azure APIs](#rest-api-endpoints) every 2 hours to collect information about available resources.
- The StackState Azure Agent function `SendToStackState` pushes [retrieved data](#data-retrieved) to StackState.
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



## Integration details

### Data retrieved

#### Events

The Azure integration does not retrieve any Events data.

#### Metrics

The Azure integration does not retrieve any Metrics data.

#### Topology

Each Azure integration retrieves topology data for resources associated with the associated Azure Service Principal.

| Data | Description |
|:---|:---|
| Components |  |
| Relations |  | 

#### Traces

The Azure integration does not retrieve any Traces data.

### REST API endpoints

| Table Name | REST API Endpoint |
| :--- | :--- |
| change\_request | `/api/now/table/change_request` |
| cmdb\_ci | `/api/now/table/cmdb_ci` |
| cmdb\_rel\_type | `/api/now/table/cmdb_rel_type` |
| cmdb\_rel\_ci | `/api/now/table/cmdb_rel_ci` |

## Troubleshooting

Troubleshooting steps can be found in the StackState support Knowledge base guide to [troubleshoot the StackState Azure StackPack](https://support.stackstate.com/hc/en-us/articles/360016450300-Troubleshooting-StackState-Azure-StackPack).

## Uninstall


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

- 