---
Configure topology sources in StackState
---

# Topology sources

## Overview

Topology sources are used to get data from the Kafka bus, which receives the data from the StackState topology API. They can be configured by power users and StackState administrators in the StackState UI page:

**Settings** > **Topology Synchronization** > **Sts sources**

From this screen you can:

* Test Connection: Verify that the target Kafka server is reachable.
* Refresh: Refresh the lists of integration types and topics.
* Create: Create the data source.
* Cancel: Cancel creation of the data source.

## Add new topology data source

To add a new topology data source, click **ADD STS DATA SOURCE** from the screen **Settings** > **Topology Synchronization** > **Sts sources** and enter the required configuration.

![ADD STS DATA SOURCE screen](../../.gitbook/assets/v42_add_sts_data_source.png)

The screen contains the following fields:

| Field | Description |
| :--- | :--- |
| **Name** | The name of the data source. |
| **Description** | A description of the data source. | 
| **Use StackState's default Kafka** | Use the default Kafka bus on the StackState server or a separate Kafka instance. | 
| **Kafka host(s)** | |
| **Instance type** | The integration type. Select from the dropdown list. | 
| **Topic** | The Kafka topic to retrieve data from. Select from the dropdown list, which is populated based on the selected `instance type`. | 
| **Maximum batch size** | The maximum number of components from a JSON file that are processed in a single batch. Used for rate limiting. | 
| **Expire elements** | When enabled, topology elements will be set to **expired** if they do not appear in this data source for a configured amount of time. | 
| **Identifier** | |

{% hint style="info" %}
 **snapshot mode**
Expiry of elements is not necessary when the topology data is sent in snapshot mode. Each snapshot represents a complete landscape instance and elements missing from the snapshot will be automatically deleted. 

See the JSON format description.
{% endhint %}



## See also

- 






--------
Old content

The following advanced settings are also available:

* `Maximum # of batches/second`: Specifies the maximum number of batches processed per second. Used for rate limiting.

* `Cleanup expired elements`: Remove _expired_ topology elements from StackState if they have been expired for a configured amount of time.


The screen contains the following buttons:

* `Test Connection`: Verify that the target Kafka server is reachable.
* `Refresh`: Refresh the lists of integration types and topics.
* `Create`: Create the data source.
* `Cancel`: Cancel creation of the data source.

