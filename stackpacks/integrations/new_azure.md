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

### Install

### Configure


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