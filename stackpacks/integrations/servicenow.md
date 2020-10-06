# ServiceNow

## What is the ServiceNow StackPack?

The ServiceNow StackPack is used to create a near real time synchronization of CI's and their dependencies from ServiceNow to StackState.

To install this StackPack we need to know the instance id of your servicenow account.

## Prerequisites

* StackState Agent V2 must be installed on a single machine which can connect to ServiceNow and StackState. See the [StackState Agent V2 StackPack](/stackpacks/integrations/agent.md) for more details.
* A ServiceNow instance must be running.

## Enabling ServiceNow integration

To enable the ServiceNow check which collects the data from ServiceNow:

Edit the `servicenow.yaml` file in the agent `conf.d` directory, replacing `<instance_ID>`, `<instance_username>` and `<instance_password>` with the information from your ServiceNow instance.

{% hint style="info" %}
If you don't want to include a password directly in the configuration file, you can use [secrets management](/configure/security/secrets_management.md).
{% endhint %}

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
    batch_size: 100
```

To publish the configuration changes, [restart the StackState Agent\(s\)](/stackpacks/integrations/agent.md#start-stop-restart-the-stackstate-agent).

Once the Agent is restarted, Wait for the Agent to collect the data and send it to StackState.

