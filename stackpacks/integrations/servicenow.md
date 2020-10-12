---
description: Receive ServiceNow data in StackState
---

# ServiceNow

## What is the ServiceNow StackPack?

The ServiceNow StackPack creates near real time synchronization between ServiceNow and StackState. When enabled, ServiceNow configuration items (CIs) and their dependencies will be visible in StackState as components and relations.

![](/.gitbook/assets/stackpack-servicenow.png)

- Agent V2 connects to the configured [ServiceNow API](#servicenow-rest-api-endpoints) to retrieve CIs and their dependencies.
- Agent V2 pushes the retrieved data to StackState.
- StackState translates incoming CIs and dependencies into components and relations. 

### ServiceNow REST API endpoints

The ServiceNow user configured in StackState Agent V2 must have access to read the ServiceNow `TABLE` API. The specific table names and endpoints used in the StackState integration are described below. All named REST API endpoints use HTTPS protocol for communication.

| Table Name | REST API Endpoint | Description |
|:---|:---|:---|
| **cmdb_ci**  |  `/api/now/table/cmdb_ci` | |
| **cmdb_rel_type**  |  `/api/now/table/cmdb_rel_type` | |
| **cmdb_rel_ci**  |  `/api/now/table/cmdb_rel_ci` | |

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

### Enable ServiceNow integration

To enable the ServiceNow check and begin collecting data from your ServiceNow instance:

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
2.  [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
3. Once the Agent has restarted, wait for the Agent to collect the data and send it to StackState.

## Uninstall

To uninstall the ServiceNow StackPack and disable the ServiceNow check:

1. Go to the StackState UI StackPacks > Integrations > ServiceNow screen and click **UNINSTALL**
    - All ServiceNow specific configuration in StackState will be removed.
2. Rename the Agent integration configuration file:
    ```
    mv servicenow.d/conf.yaml servicenow.d/conf.yaml.example
    ```
3. [Restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.

## See also

- [StackState Agent V2](/stackpacks/integrations/agent.md) 
- [Secrets management](/configure/security/secrets_management.md)
- [How to configure a ServiceNow user and assign roles \(servicenow.com\)](https://docs.servicenow.com/bundle/geneva-servicenow-platform/page/administer/users_and_groups/task/t_CreateAUser.html)
