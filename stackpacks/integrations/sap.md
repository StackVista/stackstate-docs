---
description: StackState Self-hosted v5.1.x 
---

# SAP

## Overview

The SAP StackPack is used to create a near real time synchronization with your SAP system and also pulls the metrics from it. The components supported are:

* SAP Host
* SAP Host instance
* SAP Process
* SAP Database
* SAP Database Component

SAP is a [community integration](/stackpacks/integrations/about_integrations.md#community-integrations).

## Setup

### Prerequisites

To set up the StackState SAP integration you need to have:

* [StackState Agent V2](../../setup/agent/about-stackstate-agent.md) installed on a single machine that can connect to both your SAP Instance and StackState.
* A running SAP instance.

### Networking requirements

The StackState SAP integration requires the following TCP ports:

* 1128 for HTTP 
* 1129 for HTTPS

### Install

Install the SAP StackPack from the StackState UI **StackPacks** > **Integrations** screen. You will need to enter the following details:

- **SAP Host Name** - the SAP host name from which topology and metrics need to be collected.

### Configure

To enable the SAP check and begin collecting data from your SAP host instance, add the following configuration to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/sap.d/conf.yaml`:
   * Include details of your SAP instance:
     * **host**
     * **url** - Use `http` for basic authentication \(user/pass\) and `https` for client certificate authentication.
     * **user**
     * **pass** - Use [secrets management](../../configure/security/secrets_management.md) to store passwords outside of the configuration file.
   * To authenticate with a client certificate and private key, add:

     * **verify** - Set to `False` to skip verification of the client certificate \(default `True`\).
     * **cert** - Path to the client side certificate.
     * **keyfile** - Path to the private key for certificate.

     ```text
     # Section used for global SAP check config
     init_config: {}

     instances:
       - host: TEST-01             # <sap_host_name>
         url: https://test-01      # <sap_host_url>   
         user: test                # <username>
         pass: test                # <password>
     # Extra parameters for client certificate authentication:
         verify: False             
         cert: /path/to/cert.pem   # <certificate_path>
         keyfile: /path/to/key.pem # <keyfile_path>
     ```
2. [Restart StackState Agent V2](../../setup/agent/about-stackstate-agent.md#deployment) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect data and send it to StackState.

## Integration details

### Data retrieved

The SAP integration collects the following data:

* [Topology](#topology)
* [Metrics](#metrics)
* [Events](#events)

#### Topology

The topology elements retrieved from SAP are described below, together with the associated metrics and events.

* **SAP Host**
  * Free Space in Paging Files
  * SAP host control state
  * Size stored in Paging Files
  * Total Swap space size
    
* **SAP Host instance**
  * Database connection status
  * Physical memory
  * Sap host instance state

* **SAP Process**
  * SAP process health state

* **SAP Database**
  * Backup exists
  * Delta Merges
  * Last Backup
  * License Expiring
  * Recent backup
  * SAP database state
  * System Backup
  * System Replication

* **SAP Database Component**
  * SAP Database component state

#### Metrics

The metrics described below are retrieved by the SAP integration.

* SAP_ITSAMDatabaseMetric
  * `sap.hdb.alert.license_expiring`
  * `sap.hdb.alert.backup.data.last`
  * `USED_DATA_AREA`
  * `USED_LOG_AREA`
  * `db.ora.tablespace.free`
  * `TimeToLicenseExpiry`

* SAP_ITSAMInstance/Parameter
  * `PHYS_MEMSIZE`

* GetComputerSystem
  * `FreeSpaceInPagingFiles`
  * `SizeStoredInPagingFiles`
  * `TotalSwapSpaceSize`

#### Events

The events described below are retrieved by the SAP integration.

* SAP_ITSAMInstance/Alert
  * `Oracle|Performance|Locks`
  * `R3Services|Dialog|ResponseTimeDialog`
  * `R3Services|Spool`
  * `R3Services|Spool|SpoolService|ErrorsInWpSPO`
  * `R3Services|Spool|SpoolService|ErrorFreqInWpSPO`
  * `Shortdumps Frequency`

* SAP_ITSAMDatabaseMetric
  * `db.ora.tablespace.status`

#### Traces

The SAP integration doesn't retrieve any traces.

### API endpoints

The specific endpoints queried by the StackState SAP integration are described below. All named REST API endpoints use the HTTPS protocol for communication.

* `SAP_ITSAMInstance/Process??Instancenumber=`
* `SAP_ITSAMInstance/WorkProcess??Instancenumber=`
* `SAP_ITSAMInstance/Parameter??Instancenumber=`

### Open-source

The SAP StackPack is open-source and can be found at [https://github.com/StackVista/stackpack-sap](https://github.com/StackVista/stackpack-sap).

## Release notes

The [SAP StackPack release notes](https://github.com/StackVista/stackpack-sap/blob/master/src/main/stackpack/resources/RELEASE.md) are available on GitHub.

