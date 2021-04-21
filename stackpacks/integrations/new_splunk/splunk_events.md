# Splunk events Agent check

## Overview

The StackState Splunk integration collects events from Splunk by executing Splunk saved searches that have been specified in the StackState Agent V1 Splunk events check configuration. This means that in order to receive Splunk events data in StackState, you will need to add configuration to both Splunk and the StackState Agent V1.

* [In Splunk](#splunk-saved-search), there should be a saved search that generates the events data you want to retrieve.
* [In StackState Agent V1](#agent-v1-splunk-events-check-configuration), a Splunk events check should be configured to execute the relevant Splunk saved search and filter data as required.

The StackState Agent V1 Splunk events check will execute the saved searches periodically, retrieving data from the last received event timestamp up until now. 

## Splunk saved search

StackState Agent V1 expects the results of a saved search to follow the format described below. 

| Field | Type | Description |
| :--- | :--- | :--- |
| **\_time** | long | Required. The data collection timestamp, milliseconds since epoch. |
| **event\_type** | string | Event type, for example `server_created`. |
| **msg\_title** | string | Message title. |
| **msg\_text** | string | Message text. |
| **source\_type\_name** | string | Source type name. |
| All other fields | - | [Default Splunk fields \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) other than `_time` will be filtered out of the result.<br />Any other fields present in the result will be mapped to tags in the format `field`:`value`. |




## Agent V1 Splunk events check configuration



## See also

* [StackState Splunk integration details](/stackpacks/integrations/new_splunk/splunk.md)