---
title: ServiceNow StackPack
kind: documentation
---

# ServiceNow

## What is the ServiceNow StackPack?

The ServiceNow StackPack is used to create a near real-time synchronization of CI's and their dependencies from ServiceNow to StackState.

To install this StackPack we need to know the instance id of your ServiceNow account.

### CI Filtering

We list a subset of supported CIs\(Configuration Items\) inside the integration. This feature can be enabled by uncommenting `include_resource_types`  parameter and the different supported CIs in the configuration YAML of ServiceNow integration. This integration sends all different CIs available in the ServiceNow by default.

* **Note -** Currently we list a subset of CIs in the configuration file, but you can add your own supported valid CI from ServiceNow and that will be also considered for filtering but in the view, the components will be shown on Uncategorized layer.

## Prerequisites

* StackState Agent V2 must be installed on a single machine which can connect to ServiceNow and StackState. \(See the [StackState Agent V2 StackPack](agent.md) for more details\)
* A ServiceNow instance must be running.

## Enabling ServiceNow integration

To enable the ServiceNow check which collects the data from ServiceNow:

* Edit the `servicenow.yaml` file in your agent’s `conf.d` directory, replacing `<instance_ID>`, `<instance_username>` and `<instance_password>` with the information from your ServiceNow instance.
* It is possible to filter CIs from ServiceNow by using the `include_resource_types` parameter and the supported `sys_class_name` values. You can also add your own supported valid CI from ServiceNow for filtering.

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

To enable the ServiceNow check restart the StackState Agent\(s\) using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, Wait for the Agent to collect the data and send it to StackState.

