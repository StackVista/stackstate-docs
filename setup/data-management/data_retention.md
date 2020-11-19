---
description: Configuring data retention parameters.
---

# Data retention

StackState imposes data retention limits to save storage space and improve performance. You can configure the data retention period to provide a balance between the amount of data stored, StackState performance, and data availability.

## Retention of topology graph data

By default topology graph data will be retained for 8 days. This works in a way that the latest state of topology graph will always be retained; only history older than 8 days will be removed. You can check and alter the configured retention period this using the StackState CLI.

```text
# Check the current retention period
sts graph retention get-window
```

In some cases, it may be useful to keep historical data for more than eight days.

```text
# Set the configured retention period to 10 days
sts graph retention set-window --window 864000000
```

\(note that time value is provided in milliseconds - 10 days equals 864000000 milliseconds\)

Please note that by adding more time to the data retention period, the amount of data stored is also going to grow and need more storage space. This may also affect the performance of the Views.

After the new retention window is applied, you can schedule a new removal with this command:

```text
# Schedule a new removal
sts graph retention set-window --schedule-removal
```

After changing the retention period to a smaller window, you may end up with some data that is already expired and will wait there until the next scheduled cleanup. To schedule an additional removal of expired data, use the following command:

Please note that this may take some time to have an effect.

```text
# Schedule removal of expired data
sts graph retention remove-expired-data
```

However, if you would like to perform data deletion without having to wait for an additional scheduled cleanup, you can use `--immediately` argument:

```text
# Remove expired data immediately
sts graph retention remove-expired-data --immediately
```

## Retention of metrics/events

### StackState metrics and events data store

If you are using the metric/event store provided with StackState, your data will by default be retained for 30 days. In most cases, the default settings will be sufficient to store all indices for this amount of time. 

In some circumstances it may be necessary to adjust the disk space available to ElasticSearch and how it is allocated to each index, for example if you anticipate a lot of data to arrive for a specific index. The settings can be adjusted in the file `/opt/stackstate/etc/kafka-to-es/application.conf` using the parameters described below.

| Parameter | Default | Description | 
|:---|:---|:---|
| `elasticsearchDiskSpaceMB` | 500000 | The total disk space assigned to ElasticSearch in MB. The default setting is the recommended disk space for a StackState production setup (500GB). |
| `splittingStrategy` | "days" | The frequency of creating new indices. Can be one of "none", "hours", "days", "months" or "years". If "none" is specified, only one index will be used. |
| `maxIndicesRetained` | 30 | The number of indices that will be retained. Together with the `splittingStrategy` governs how long historical data will be kept in ElasticSearch.  |
| `diskSpaceWeight` | 0 | Defines the share of disk space an index will get based on the total `elasticsearchDiskSpaceMB`.  |
| `maxIndexSizeBytes` | - | Optional. When set, will overrule the configured `diskSpaceWeight` and make the specified disk space available to the index. Remaining disk space will be shared between other indices according to their configured `diskSpaceWeight`. | 

For example:

```
stackstate {
  ...

  // Total size of disk assigned to ElasticSearch in MB
  elasticsearchDiskSpaceMB = 500000

  ...

  // sts_metrics index
  kafkaMetricsToES {
    ...
    elasticsearch {
        index {
          splittingStrategy = "days"
          maxIndicesRetained = 30
          refreshInterval = 1s
          replicas = 0 // Default setup is single node
          diskSpaceWeight = 0
        }
      ...
      }
    }

  // sts_multi_metrics index
  kafkaMultiMetricsToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 0
      }
    ...
    }
  }

  // sts_generic_events index
  kafkaGenericEventsToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 0
      }
    ...
    }
  }

  // sts_topology_events index
  kafkaTopologyEventsToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 0
      }
    ...
    }
  }

  // sts_state_events index
  kafkaStateEventsToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 0
      }
    ...
    }
  }

  // sts_events index
  kafkaStsEventsToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 0
      }
    ...
    }
  }

  // sts_trace_events index
  kafkaTraceToES {
    ...
    elasticsearch {
      index {
        splittingStrategy = "days"
        maxIndicesRetained = 30
        refreshInterval = 1s
        replicas = 0 // Default setup is single node
        diskSpaceWeight = 0
      }
    ...
    }
  }
}

``` 

### External metrics and events data store

If you have configured your own data source to be accessed by StackState, the retention policy is determined by the metric/event store you connected.