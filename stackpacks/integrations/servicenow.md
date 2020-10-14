---
description: Receive ServiceNow data in StackState
---

# ServiceNow

## What is the ServiceNow StackPack?

The ServiceNow StackPack creates near real time synchronization between ServiceNow and StackState. When enabled, ServiceNow configuration items (CIs) and their dependencies will be visible in StackState as components and relations.

![Data flow](/.gitbook/assets/stackpack-servicenow_OPTIONS.png)

- Agent V2 connects to the configured [ServiceNow API](#servicenow-rest-api-endpoints).
- CIs and dependencies for the [configured CI types](##filter-retrieved-ci-types) are retrieved from the ServiceNow CMDB (default all).
- Agent V2 pushes retrieved data to StackState.
- StackState translates incoming CIs and dependencies into components and relations. 

### ServiceNow REST API endpoints

The ServiceNow user configured in StackState Agent V2 must have access to read the ServiceNow `TABLE` API. The specific table names and endpoints used in the StackState integration are described below. All named REST API endpoints use HTTPS protocol for communication.

| Table Name | REST API Endpoint | 
|:---|:---|
| **cmdb_ci**  |  `/api/now/table/cmdb_ci` |
| **cmdb_rel_type**  |  `/api/now/table/cmdb_rel_type` |
| **cmdb_rel_ci**  |  `/api/now/table/cmdb_rel_ci` |

{% hint style="info" %}
Refer to the ServiceNow product documentation for details on [how to configure a ServiceNow user and assign roles](https://docs.servicenow.com/bundle/geneva-servicenow-platform/page/administer/users_and_groups/task/t_CreateAUser.html).
{% endhint %}

## Installation

### Pre-requisites

To set up the StackState ServiceNow integration, you will need to have:

- [StackState Agent V2](/stackpacks/integrations/agent.md) installed on a machine that can connect to both ServiceNow (via HTTPS) and StackState.
- A running ServiceNow instance.
- A ServiceNow user with access to the required [ServiceNow API endopints](#servicenow-rest-api-endpoints).

### Install the ServiceNow StackPack

The ServiceNow StackPack can be installed from the StackState UI StackPacks > Integrations screen. To install the StackPack you will need to provide the following parameters:

- **Instance ID**: the ServiceNow instance ID from which topology will be collected. For example, if the ServiceNow Instance URL is `https://dev102222.service-now.com`, then `dev102222` is the instance ID.

After the StackPack has been installed, you can enable the ServiceNow integration.

### Configure the Agent ServiceNow integration

After the ServiceNow StackPack has been installed, the StackState Agent can be configured with details of your ServiceNow instance. This will enable the ServiceNow check and begin collecting data from ServiceNow.

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/servicenow.d/conf.yaml` to include details of your ServiceNow instance:
    - **url** - the REST API url, uses HTTPS protocol for communication.
    - **user** - a ServiceNow user with access to the required [ServiceNow API endopints](#servicenow-rest-api-endpoints)
    - **password** - use [secrets management](/configure/security/secrets_management.md) to store passwords outside of the configuration file.
    ```text
    init_config:
      # Any global configurable parameters should be added here
      default_timeout: 10
      min_collection_interval: 5
    
    instances:
      - url: "https://<instance_ID>.service-now.com"
        basic_auth:
           user: <instance_username>
           password: <instance_password>
        batch_size: 100    # the maximum number of records to be returned
    ```
2. Optional: Include a list of the [CI types that should be retrieved](#filter-retrieved-ci-types).
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.
3. Once the Agent has restarted, wait for the Agent to collect the data and send it to StackState.

### Filter retrieved CI types

By default, all available ServiceNow CI types will be sent to StackState. If you prefer to work with a specific set of resource types, you can configure the Agent integration to filter the CI types it retrieves:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/servicenow.d/conf.yaml`.
    - A subset of the available CI types is listed and commented out.
3. Uncomment the line `include_resource_types` and the CI types you would like to send to StackState.
    You can add any valid ServiceNow CI type to the **include_resource_types** list, however, components from resource types that you have added will appear on the **Uncategorized** layer of a StackState view. 

    ```
    instances:
      - url: "https://<instance_ID>.service-now.com"
        user: <instance_username>
        password: <instance_password>
        batch_size: 100
        #    include_resource_types: # optional and by default includes all resource types(sys Class Names)
        #        - cmdb_ci_netgear
        #        - cmdb_ci_ip_router
        #        - cmdb_ci_aix_server
        #        - cmdb_ci_storage_switch
        #        - cmdb_ci_win_cluster
        #        - cmdb_ci_email_server
        #        - cmdb_ci_web_server
        #        - cmdb_ci_app_server
        #        - cmdb_ci_printer
        #        - cmdb_ci_cluster
        #        - cmdb_ci_cluster_node
        #        - cmdb_ci_computer
        #        - cmdb_ci_msd
        #        - cmdb_ci
        #        - cmdb_ci_unix_server
        #        - cmdb_ci_win_cluster_node
        #        - cmdb_ci_datacenter
        #        - cmdb_ci_linux_server
        #        - cmdb_ci_db_ora_catalog
        #        - cmdb_ci_win_server
        #        - cmdb_ci_zone
        #        - cmdb_ci_appl
        #        - cmdb_ci_computer_room
        #        - cmdb_ci_ip_switch
        #        - service_offering
        #        - cmdb_ci_disk
        #        - cmdb_ci_peripheral
        #        - cmdb_ci_service_group
        #        - cmdb_ci_db_mysql_catalog
        #        - cmdb_ci_ups
        #        - cmdb_ci_service
        #        - cmdb_ci_app_server_java
        #        - cmdb_ci_spkg
        #        - cmdb_ci_database
        #        - cmdb_ci_rack
        #        - cmdb_ci_server
        #        - cmdb_ci_network_adapter
    ```
4. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## Uninstall

To uninstall the ServiceNow StackPack and disable the ServiceNow check:

1. Go to the StackState UI StackPacks > Integrations > ServiceNow screen and click **UNINSTALL**
    - All ServiceNow specific configuration will be removed from StackState .
2. Remove or rename the Agent integration configuration file, for example:
    ```
    mv servicenow.d/conf.yaml servicenow.d/conf.yaml.bak
    ```
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## See also

- [StackState Agent V2](/stackpacks/integrations/agent.md) 
- [Secrets management](/configure/security/secrets_management.md)
- [How to configure a ServiceNow user and assign roles \(servicenow.com\)](https://docs.servicenow.com/bundle/geneva-servicenow-platform/page/administer/users_and_groups/task/t_CreateAUser.html)
