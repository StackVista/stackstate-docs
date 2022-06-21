#### Prerequisites

The following prerequisites need to be met:

* StackState Agent V2 must be installed on a single machine which can connect to Cloudera Manager and StackState. (See the [StackState Agent V2 StackPack](/#/stackpacks/stackstate-agent-v2/) for more details)
* A Cloudera instance must be running.

**NOTE**:- We support Cloudera version 5.11.

## Enable Cloudera integration

To enable the Cloudera check and begin collecting data from your Cloudera instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/cloudera.d/conf.yaml` to include details of your Cloudera instance:
   * **url**
   * **username** 
   * **password** - use [secrets management](https://l.stackstate.com/ui-stackpack-secrets-management) to store passwords outside of the configuration file.

     ```text
     # Section used for global Cloudera check config
     init_config:

     instances:
     # mandatory
     - url: <url>
       # SSL verification
       verify_ssl: false    

       # Read-only credentials to connect to cloudera
       # mandatory
       username: <username> # Admin
       password: <password> # cloudera

       # Cloudra API version
       # mandatory
       api_version: <api_version> # v18
     ```
2. [Restart the StackState Agent\(s\)](https://l.stackstate.com/ui-stackpack-restart-agent) to publish the configuration changes.
3. Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.
