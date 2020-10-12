---
description: Receive ServiceNow data in StackState
---

# ServiceNow

## What is the ServiceNow StackPack?

The ServiceNow StackPack enables near real time synchronization between ServiceNow and StackState. ServiceNow configuration items (CIs) and their dependencies are available in StackState as components and relations.

![Diagram](/.gitbook/assets/stackpack-servicenow.png)

- StackState Agent v2 connects to the configured ServiceNow API to retrieve CIs and their dependencies.
- Retrieved data are pushed to StackState as components and relations.

### Required ServiceNow REST API endpoints

The ServiceNow user configured in StackState Agent V2 must have access to read the ServiceNow API `TABLE`. The specific table names and endpoints used in the StackState integration are described in the table below. All the REST API endpoints use HTTPS protocol for communication.

| Table Name | Table API Endpoint | Description |
|:---|:---|:---|
| **cmdb_ci**  |  `/api/now/table/cmdb_ci` | |
| **cmdb_rel_type**  |  `/api/now/table/cmdb_rel_type` | |
| **cmdb_rel_ci**  |  `/api/now/table/cmdb_rel_ci` | |

## Install

### Pre-requisites

To set up the StackState ServiceNow integration, you will need to have:

- [StackState Agent V2](/stackpacks/integrations/agent.md) installed on a machine that can connect to both ServiceNow (via HTTPS) and StackState.
- A running ServiceNow instance.
- A ServiceNow user with access to the [required ServiceNow API endopints](#required-servicenow-rest-api-endpoints). Refer to the ServiceNow product documentation to find out [how to configure a ServiceNow user and assign roles \(servicenow.com\)](https://docs.servicenow.com/bundle/geneva-servicenow-platform/page/administer/users_and_groups/task/t_CreateAUser.html.

### Enable ServiceNow integration

To enable the ServiceNow check and begin collecting data from your ServiceNow instance:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/servicenow.d/conf.yaml` to include details of your ServiceNow instance:
    - **url** - the REST API url, uses HTTPS protocol for communication.
    - **user** - a ServiceNow user with access to the [required ServiceNow API endopints](#required-servicenow-rest-api-endpoints)
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
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

## Troubleshooting

Describe any common issues/misunderstandings or troubleshooting steps here. Note that known issues should also be covered in the StackState support site.

## Uninstall

If the uninstall includes manual or extra steps these should be included here. If it is a standard 'click to uninstall', also describe that here - don't leave the reader to guess.

## See also

- [StackState Agent V2](/stackpacks/integrations/agent.md) 
- [Secrets management](/configure/security/secrets_management.md)
- [How to configure a ServiceNow user and assign roles \(servicenow.com\)](https://docs.servicenow.com/bundle/geneva-servicenow-platform/page/administer/users_and_groups/task/t_CreateAUser.html)
