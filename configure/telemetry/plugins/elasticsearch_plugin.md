---
description: How to receive and work with data from a custom Elasticsearch data source in StackState
---

# Elasticsearch plugin

## Overview

StackState can be configured to pull data from your own Elasticsearch instance. The collected metrics or events data can then be added as a telemetry stream directly to a component or included as part of an integration, topology synchronisation or component/relation template.

## Pull telemetry from a custom Elasticsearch instance

### prerequisites

To connect StackState to your Elasticsearch instance and retrieve telemetry data you will need to have:

- A running Elasticsearch instance reachable from StackState.
- An Elasticsearch index to retrieve.
- A time field with a timestamp in the Elasticsearch data.

### Add an Elasticsearch datasource to StackState

An Elasticsearch data source should be added in StackState for each Elasticsearch index that you want to work with. Default settings that should work with most instances of Elasticsearch are already included, so you will only need to add details of your Elasticsearch instance and the index to be retrieved.

To add an Elasticsearch data source:

1. In the StackState UI, go to **Settings** > **Telemetry Sources** > **Elasticsearch sources**.
2. Click on **ADD ELASTICSEARCH DATA SOURCE**.
3. Enter the required settings:
    - **Name** - the name to identify the Elasticsearch data source in StackState.
    - **Base URL** - the URL of the REST api of your Elasticsearch instance (default port 9200). Note that this must be reachable by StackState.
    - **Index pattern** - the Elasticsearch index to retrieve. It is possible to specify a pattern if the index is sliced by time.
    - **Time zone** - the timezone of the timestamps stored in the elasticsearch documents.  This is required to ensure data is correctly processed by StackState.
    - **Time field** - the field in the elasticsearch documents which contains the timestamp of the event/metric.
    - **Time field format** - the format of the value in the **Time field**.
    - The UI contains more settings that may be tweaked in non-standard use-cases. See [Advanced plugin settings](#advanced-plugin-settings)
4. Click **TEST CONNECTION** to confirm that StackState can connect to Elasticsearch at the configured Base URL.
5. Click **CREATE** to save the Elasticsearch data source settings.
    - The new Elasticsearch data source will be listed on the **Elasticsearch sources** page and available as a data source when adding telemetry to components and relations.

![Add Elasticsearch data source](/.gitbook/assets/v42_elasticsearch_data_source.png)    

### Work with Elasticsearch data in StackState

Elasticsearch data sources can be used to add telemetry streams to components and relations in StackState. This can be done manually by [adding a telemetry stream](/use/health-state-and-event-notifications/add-telemetry-to-element.md) directly to an element or as part of an integration or topology synhronization, for details see how to [add telemetry during topology synchronization](/configure/telemetry/telemetry_synchronized_topology.md).

### Advanced plugin settings

The timeout settings can be tweaked when dealing with excptionally large result sets or a slower Elasticsearch cluster:
- **Read timeout (seconds)** - Timeout when retrieving data directly from Elasticsearch
- **Request timeout ui (seconds)** - Timeout when retrieving ElasticSearch data through the StackState api

ElasticSearch can be accessed through kibana. To do this, use the api endpoint provided by kibana and set the kibana version:
- **Kibana verion** - Kibana version used when requesting data from kibana (this is required for XSS mitigation)

Wildcards can be slow in Elasticsearch. Tweaking the **Support wildcards in values** will tell StackState to either escape or not escape wildcards in telemetry query values (*, ?).

## See also

- [Add a telemetry stream to a component or relation](/use/health-state-and-event-notifications/add-telemetry-to-element.md)
- [Add telemetry during topology synchronization](/configure/telemetry/telemetry_synchronized_topology.md)
