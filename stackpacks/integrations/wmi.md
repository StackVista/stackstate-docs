---
description: StackState curated integration
---

# WMI

## Overview

Collect telemetry information with Windows Management Instrumentation \(WMI\) from Windows applications and servers.

## Functionality

StackState Agent for Windows collects telemetry information from Windows by querying WMI. Metrics obtained from the defined WMI queries are collected periodically. Multiple WMI queries can be defined. Collected WMI metrics are sent to StackState and can be used as metric streams.

## Setup

### Installation

After installing the StackState Agent for Windows, the integration can be configured. The integration is included in the StackState Agent for Windows, no additional installation steps are required. The WMI integration has to be configured.

### Configuration

The WMI integration can be enabled and configured via the StackState Agent Manager. Opening the StackState Agent Manager can be done by, in PowerShell:

```text
PS> & 'C:\Program Files\StackState\StackState Agent\embedded\agent.exe' launch-gui
```

The integration can be enabled via the StackState Agent Manager:

1. open `Checks`, `Manage checks`, 
2. select in the drop-down `Add a check`,
3. add `wmi_check`.

After the integration is enabled WMI queries can be defined in the integrations configuration yaml file, i.e. `wmi_check.d/conf.yaml`. Multiple WMI queries can be configured. In the configuration file, an instance can be configured which represents a WMI query. An instance is defined by the following fields:

| Field | Required | Description |
| :--- | :--- | :--- |
| `class` | Yes | The WMI class to use in the query. |
| `metrics` | Yes | The metrics that need to be collected. This is in format `[WMI property name, metric name, metric type]`. The `WMI property name` is the property to be collected, `metric name` is the metric name reported to StackState, and `metric type` is the metric's type. |
| `tag_by` | No | Adds the properties value as tag to the metric that is send to StackState. |
| `tags` | No | Add customer tags to the metric that is send to StackState. |
| `filters` | No | WMI query filter to reduce the amount of metrics returned. |
| `collection_interval` | No | Periodicity of executing the WMI query, in seconds. Default is once per 15 seconds. |

Example instance:

```text
  - # min_collection_interval: 120 # use in place of collection_interval for Agent v2.14.x or earlier 
    collection_interval: 120
    class: Win32_PerfRawData_MSSQLSERVER_SQLServerDatabases
    metrics:
      - [ActiveTransactions, sql.server.connections.active, gauge]
    tag_by: Name
    tags: 
      - "database:test_db"
    filters:
      - Name: test_db
```

Restart the StackState Agent after making changes to the WMI integration's configuration.

Reference: the integration's configuration file is located at `C:\ProgramData\StackState\conf.d\wmi_check.d\`.

### Troubleshooting

The `Status` page in the StackState Agent Manager provides insight into the operational status of the configurated WMI queries/instances.

It is possible to invoke the WMI integration to verify whether the configured WMI queries/instances telemetry is being retrieved and collected by the StackState Agent for Windows. To invoke, in PowerShell:

```text
PS> & 'C:\Program Files\StackState\StackState Agent\embedded\agent.exe' check wmi_check
```

Refer to the log file for more information. The log file is located at `C:\ProgramData\StackState\logs\agent.log`.

