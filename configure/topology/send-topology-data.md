---
description: StackState Self-hosted v5.1.x 
---

# Topology synchronization

## Overview

StackState can synchronize topology information from different sources, including your own sources.

The easiest way to connect StackState to one of your data sources is to use a **StackPack**. StackPacks are standard integrations that configure StackState to consume data from a particular data source or platform.

You can also create a **custom topology synchronization** and send topology data to StackState in JSON format. Received JSON files pass through a number of processing steps. At the end of this synchronization pipeline, the incoming data is stored as components and relations in the StackState topology. 

## StackState Receiver API

The StackState Receiver API accepts topology, metrics, events and health data in a common JSON object. By default, the receiver API is hosted at the `<STACKSTATE_RECEIVER_API_ADDRESS>` this is constructed using the `<STACKSTATE_BASE_URL>` and <`STACKSTATE_RECEIVER_API_KEY>`.

{% tabs %}
{% tab title="Kubernetes" %}
The `<STACKSTATE_RECEIVER_API_ADDRESS>` for StackState deployed on Kubernetes or OpenShift is:

```text
https://<STACKSTATE_BASE_URL>/receiver/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and `<STACKSTATE_RECEIVER_API_KEY>` are set during StackState installation, for details see [Kubernetes install - configuration parameters](/setup/install-stackstate/kubernetes_openshift/kubernetes_install.md#generate-values-yaml).
{% endtab %}

{% tab title="Linux" %}

The `<STACKSTATE_RECEIVER_API_ADDRESS>` for StackState deployed on Linux is:

```text
https://<STACKSTATE_BASE_URL>:<STACKSTATE_RECEIVER_PORT>/stsAgent/intake?api_key=<STACKSTATE_RECEIVER_API_KEY>
```

The `<STACKSTATE_BASE_URL>` and <STACKSTATE_RECEIVER_API_KEY>` are set during StackState installation, for details see [Linux install - configuration parameters](/setup/install-stackstate/linux/install_stackstate.md#configuration-options-required-during-install).
{% endtab %}
{% endtabs %}

## Common JSON object

Topology, telemetry and health data are sent to the receiver API via HTTP POST. There is a common JSON object used for all messages.

{% code lineNumbers="true" %}
```javascript
{
  "collection_timestamp": 1548855554, // the epoch timestamp for the collection
  "events": {}, // used for sending events data
  "internalHostname": "localdocker.test", // the host that is sending this data
  "metrics": [], // used for sending metrics data
  "service_checks": [],
  "topologies": [], // used for sending topology data
  "health": // used for sending health data
}
```
{% endcode %}

## JSON property: "topologies" 

StackState accepts topology information in the following JSON format:

{% code lineNumbers="true" %}
```text
{
   "apiKey":"your api key",
   "collection_timestamp":1585818978,
   "internalHostname":"lnx-343242.srv.stackstate.com",
   "events":{},
   "metrics":[],
   "service_checks":[],
   "health":[],
   "topologies":[
      {
         "start_snapshot": false,
         "stop_snapshot": false,
         "instance":{
            "type":"mesos",
            "url":"http://localhost:5050"
         },
         "delete_ids": ["nginx4.3ff3a4d2-fa7e-4b11-b74c-acad9d4f5ea0"],
         "components":[
            {
               "externalId":"nginx3.e5dda204-d1b2-11e6-a015-0242ac110005",
               "type":{
                  "name":"docker"
                  },
               "data":{
                  "ip_addresses":[
                     "172.17.0.8"
                  ],
                  "labels":["label1", "category:label2"],
                  "framework_id":"fc998b77-e2d1-4be5-b15c-1af7cddabfed-0000",
                  "task_name":"nginx3",
                  "slave_id":"fc998b77-e2d1-4be5-b15c-1af7cddabfed-S0"
                  },
               "sourceProperties":{
                 "docker":{
                    "image":"nginx",
                    "network":"BRIDGE",
                    "port_mappings":[
                       {
                          "container_port":31945,
                          "host_port":31945,
                          "protocol":"tcp"
                       }
                    ],
                    "privileged":false
                    }
                  }
               }
            ],
         "relations":[
            {
               "externalId":"nginx3.e5dda204-d1b2-11e6-a015-0242ac110005->nginx5.0df4bc1e-c695-4793-8aae-a30eba54c9d6",
               "type":{
                  "name":"uses_service"
               },
               "sourceId":"nginx3.e5dda204-d1b2-11e6-a015-0242ac110005",
               "targetId":"nginx5.0df4bc1e-c695-4793-8aae-a30eba54c9d6",
               "data":{

               }
            }
         ]
      }
   ]
}
```
{% endcode %}

The JSON contains the following fields:

* **apiKey**: The key that StackState provided for your installation.
* **collection_timestamp**: Collection timestamp in Epoch seconds. Depending on your StackState configuration, topology that is to old may be ignored.
* **internalHostname**: The hostname of the collector \(which sends your custom topology data\).
* **topologies**: A list of one or more instance types. Instance types are described by the following fields:
  * **start_snapshot**: Boolean \(true/false\). When set to "true" this message is handled as the beginning of a snapshot. This enables StackState to diff snapshots with the previous one to delete components / relations which are not in the snapshot anymore.
  * **stop_snapshot**: Boolean \(true/false\). When set to "true" this message is handled as the end of a snapshot.
  * **delete_ids**: List of external ids. List of components or relations that should be deleted. All components and relations that are not repeated in a snapshot will be deleted automatically, thus this field is only necessary when _not_ sending a snapshot.
* **instance**: Describes the type and unique ID \(URL format\) of the topology data.
  * **type**: A type name for the topology data.
  * **URL**: Unique identifier for the source of this topology. This is used to generate a unique Kafka topic name for the topology data.
* **components**: A list of components. Each component has the following fields:
  * **externalId**: A unique ID for this component. This has to be unique for this instance.
  * **type**: A named parameter for this type.
  * **data**: A JSON blob of arbitrary data.
  * **sourceProperties**: Optional. A JSON blob of arbitrary data. When populated, the contents of this field will be displayed in the StackState UI component properties in place of the `data` field. The `data` field will still be accessible in templates and the various functions that make use of this data
* **relations**: A list of relations. Each relation has the following fields:
  * **externalId**: A unique ID for this relation. This has to be unique for this instance.
  * **type**: A named parameter for this type.
  * **data**: A JSON blob of arbitrary data. 
  * **sourceId**: The source component externalId.
  * **targetId**: The target component externalId.

## Get started with custom topology

The [push-integration tutorial](../../develop/tutorials/push_integration_tutorial.md) is a good way to get started sending your own topology into StackState.

## See also

* [Send health data over HTTP](/configure/health/send-health-data/send-health-data.md)
* [Send telemetry data over HTTP](/configure/telemetry/send_metrics.md)
* [Debug topology synchronization](/configure/topology/debug-topology-synchronization.md)
