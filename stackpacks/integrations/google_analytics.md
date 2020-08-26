---
title: Google Analytics StackPack
kind: documentation
---

# Google Analytics

## What is the Google Analytics StackPack?

The Google Analytics StackPack contains everything you need to import metrics from Google Analytics into StackState. The StackPack supports both the Google Analytics Core Reporting and Real Time Reporting APIs.

## Prerequisites

* An API Integration Agent must be installed which can connect to Google Analytics and StackState. \(See the [API Integration StackPack](api-integration.md) for more details\)
* The Google Analytics project must be visible at [https://console.developers.google.com](https://console.developers.google.com) and must have the Google Analytics API enabled
* The StackPack requires credentials \(JSON format\) for a Service Account that has access to read Google Analytics \(see [https://analytics.google.com](https://analytics.google.com)\)

**NOTE**: The Google Analytics StackPack is compatible with version 3 of the Google Analytics reporting API.

## Configuring Google Analytics integration

Configuration of the Google Analytics integration is different for the Core Reporting and Real Time Reporting APIs.

The integration determines the API to use based on the metric name. If the metric has the prefix `rt:` it is considered a real-time metric for which the Real Time Reporting API will be used. If the metric does not have this prefix, the Core Reporting API is used.

Multiple instances can be configured in the YAML file to facilitate multiple metric streams.

### Common configuration

The global configuration is defined in the `init_config` section.

| **min\_collection\_interval** | integer | The interval at which the integrations run, overriding the StackState Agent's default of 15 seconds. |
| :--- | :--- | :--- |
| **key\_file\_location** | string | Path to exported Service Account key JSON file |

### Configuring the Core Reporting API

| Name | Type | Required | Summary |
| :--- | :--- | :--- | :--- |
| **profile** | string | yes | Profile/Table identifier to use, can be obtained from [https://analytics.google.com](https://analytics.google.com). Example profile id: `ga:12345678` |
| **metrics** | list of strings | yes | Google Analytics metrics to retrieve. Example: `ga:pageviews`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/core/v3/reference#metrics) |
| **dimensions** | list of strings | no | Google Analytics dimensions to include. Example: `ga:pagePath`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/core/v3/reference#dimensions) |
| **filters** | list of strings | no | Google Analytics filters to apply. Example: `ga:pagePath==/foo/bar`. Multiple `filters` use `AND` logic by default. It is possible to apply `OR` logic by separating two filters by a comma, for example; `ga:pagePath==/foo/bar,ga:pagePath==/foo/baz`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/core/v3/reference#filters). |
| **start\_time** | string | yes | Start date for fetching Analytics data. Example: `2daysAgo`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/core/v3/reference#startDate). Keep in mind that the integration is run periodically. |
| **end\_time** | string | yes | End date for fetching Analytics data. Example: `1daysAgo`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/core/v3/reference#endDate). Keep in mind that the integration is run periodically. |
| **tags** | list of strings | no | Tags to include in the collected data in StackState. Format `key:value` |

### Configuring the Real-time Reporting API

| Name | Type | Required | Summary |
| :--- | :--- | :--- | :--- |
| **profile** | string | yes | Profile/Table identifier to use, can be obtained from [https://analytics.google.com](https://analytics.google.com). Example profile id: `ga:12345678` |
| **metrics** | list of strings | yes | Google Analytics metrics to retrieve. Example: `rt:activeUsers`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/realtime/dimsmets/) |
| **dimensions** | list of strings | no | Google Analytics dimensions to include. Example: `rt:minutesAgo`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/realtime/dimsmets/). When including the `rt:minutesAgo` dimension, the integration will ignore values other that the value of last minute, this gives a more consistent metric. |
| **filters** | list of strings | no | Google Analytics filters to apply. Example: `rt:pagePath==/foo/bar`. Multiple `filters` use `AND` logic by default. It is possible to apply `OR` logic by separating two filters by a comma, for example; `rt:pagePath==/foo/bar,rt:pagePath==/foo/baz`. Reference: [Google Analytics API documentation](https://developers.google.com/analytics/devguides/reporting/realtime/v3/reference/data/realtime/get) |
| **tags** | list of strings | no | Tags to include in the collected data in StackState. Format `key:value`. |

## Configuration example

* [YAML configuration example](https://github.com/StackVista/sts-agent-integrations-core/blob/master/google_analytics/conf.yaml.example)

## Enabling Google Analytics integration

To enable the Google Analytics integration:

Edit the `conf.d/google_analytics.yaml` file in your agent configuration directory.

To publish the configuration changes, restart the StackState Agent\(s\) using below command.

```text
sudo /etc/init.d/stackstate-agent restart
```

Once the Agent is restarted, wait for the Agent to collect the data and send it to StackState.

