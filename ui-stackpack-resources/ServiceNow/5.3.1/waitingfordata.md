### The Rancher Observability ServiceNow StackPack is waiting for data

To begin collecting data from ServiceNow, add the following configuration to Rancher Observability Agent V2:

1. Edit the Agent integration configuration file `/etc/sts-agent/conf.d/servicenow.d/conf.yaml` to include details of your ServiceNow instance:
    - **url** - the REST API url, uses HTTPS protocol for communication.
    - **user** - a ServiceNow user with access to the required [ServiceNow API endopints](https://l.stackstate.com/ui-servicenow-rest-api-endpoints)
    - **password** - use [secrets management](https://l.stackstate.com/ui-stackpack-secrets-management) to store passwords outside of the configuration file.
    ```text
    init_config:
      # Any global configurable parameters should be added here
      default_timeout: 10
    
    instances:
      - url: "https://<instance_ID>.service-now.com"
        user: <instance_username>
        password: <instance_password>
        collection_interval: 5
        # batch_size: 1000  
        # change_request_bootstrap_days: 10
        # change_request_process_limit: 1000 
        # timeout: 20
        # verify_https: true
        # cert: /path/to/cert.pem
        # keyfile: /path/to/key.pem
    ```
2. You can also add optional configuration and filters:
   - **batch_size** - the maximum number of records to be returned (default `2500`, max `10000`).
   - **change_request_bootstrap_days** - On first start, all change requests that have been updated in last N days will be retrieved (default `100`).
   - **change_request_process_limit** - The maximum number of change requests that should be processed (default `1000`).
   - **timeout** - Timeout for requests to the ServiceNow API in seconds (default `20`).
   - **verify_https** - Verify the certificate when using https (default `true`).
   - **cert** - Path to the certificate file for https verification
   - **keyfile** - Path to the public key of certificate for https verification
   - Use queries to [filter change requests retrieved](#use-servicenow-queries-to-filter-retrieved-events-and-ci-types) from ServiceNow (default all).
   - Use queries to [filter the CI types retrieved](#use-servicenow-queries-to-filter-retrieved-events-and-ci-types) (default all).
   - [Specify the CI types](#specify-ci-types-to-retrieve) that should be retrieved (default all).
3. [Restart the Rancher Observability Agent\(s\)](https://l.stackstate.com/ui-stackpack-restart-agent) to apply the configuration changes.
3. Once the Agent has restarted, wait for the Agent to collect data from ServiceNow and send it to Rancher Observability.

#### Use ServiceNow queries to filter retrieved events and CI types

1. In ServiceNow, create and copy a filter for CI types or change requests. See the ServiceNow documentation for details on [filtering with sysparm_query parameters (servicenow.com)](https://l.stackstate.com/ui-servicenow-queries)
2. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/servicenow.d/conf.yaml`.
3. Uncomment the CI type or event that you would like to add a filter to:
    - `cmdb_ci_sysparm_query` - ServiceNow CMDB Configuration Items query
    - `cmdb_rel_ci_sysparm_query` - ServiceNow CMDB Configuration Items Relations query
    - `change_request_sysparm_query` - ServiceNow Change Request query
    - `custom_cmdb_ci_field` - ServiceNow CMDB Configuration Item custom field mapping
4. Add the filter you copied from ServiceNow. For example

   ```
   ... 
   # ServiceNow CMDB Configuration Items query. There is no default value.
   # cmdb_ci_sysparm_query: company.nameSTARTSWITHstackstate
   
   # ServiceNow CMDB Configuration Items Relations query. There is no default value.
   # cmdb_rel_ci_sysparm_query: parent.company.nameSTARTSWITHstackstate^ORchild.company.nameSTARTSWITHstackstate
   
   # ServiceNow Change Request query. There is no default value.
   # change_request_sysparm_query: company.nameSTARTSWITHstackstate
   
   # ServiceNow CMDB Configuration Item custom field mapping. The default value is cmdb_ci.
   # custom_cmdb_ci_field: u_configuration_item
   ...
   ```
3. [Restart the Rancher Observability Agent\(s\)](https://l.stackstate.com/ui-stackpack-restart-agent) to apply the configuration changes.

#### Specify CI types to retrieve

By default, all available ServiceNow CI types will be sent to Rancher Observability. If you prefer to work with a specific set of resource types, you can configure the Agent integration to filter the CI types it retrieves:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/servicenow.d/conf.yaml`.
    - A subset of the available CI types is listed and commented out.
2. Uncomment the line `include_resource_types` and the CI types you would like to send to Rancher Observability.
    You can add any valid ServiceNow CI type to the **include_resource_types** list, however, components from resource types that you have added will appear on the **Uncategorized** layer of a Rancher Observability view. 

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
4. [Restart the Rancher Observability Agent\(s\)](https://l.stackstate.com/ui-stackpack-restart-agent) to apply the configuration changes.

### Troubleshooting

Troubleshooting steps for any known issues can be found in the [Rancher Observability support Knowledge base](https://l.stackstate.com/ui-servicenow-support-kb).
