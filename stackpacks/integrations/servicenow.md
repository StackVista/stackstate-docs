# ServiceNow

## What is the ServiceNow StackPack?

The ServiceNow StackPack is used to create a near real time synchronization of CI's and their dependencies from ServiceNow to StackState.

To install this StackPack we need to know the instance id of your servicenow account.

## Prerequisites

* [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md) must be installed on a single machine that can connect to ServiceNow and StackState.
* A ServiceNow instance must be running.

## Enable ServiceNow integration

To enable the ServiceNow check and begin collecting data from your ServiceNow instance:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/servicenow.d/conf.yaml` to include details of your ServiceNow instance:
    - **url**
    - **user**
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

