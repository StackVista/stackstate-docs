# Topology synchronization

{% hint style="warning" %}
**This page describes StackState v4.4.x.**

The StackState 4.4 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.4 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/configure/topology/topology_synchronization).
{% endhint %}

## Overview

StackState can synchronize topology information from different sources, including your own sources. StackState enables you to create a model of your complete landscape.

## StackPack topology synchronization

The easiest way to connect StackState to one of your data sources is to use a _StackPacks_. StackPacks are standard integrations that configure StackState to consume data from a particular data source or platform.

## Custom topology synchronization

StackState accepts topology data in JSON format. JSON files received pass through a number of processing steps. At the end of the synchronization pipeline, StackState stores the incoming data as part of it's topology, consisting of components and relations.

The entire process can be represented visually as follows:

![](../../.gitbook/assets/topology_synchronization.png)

### Topology JSON format

StackState accepts topology information in the following JSON format:

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
                  "labels":["label1", "category:"label2"],
                  "framework_id":"fc998b77-e2d1-4be5-b15c-1af7cddabfed-0000",
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
                  },
                  "task_name":"nginx3",
                  "slave_id":"fc998b77-e2d1-4be5-b15c-1af7cddabfed-S0"
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

The JSON contains the following fields:

* `apiKey`: The key that StackState provided for your installation.
* `collection_timestamp`: Collection timestamp in Epoch seconds. Depending on your StackState configuration, topology that is to old may be ignored.
* `internalHostname`: The hostname of the collector \(which sends your custom topology data\).
* `topologies`: A list of one or more instance types. Instance types are described by the following fields:
  * `start_snapshot`: Boolean \(true/false\). When set to "true" this message is handled as the beginning of a snapshot. This enables StackState to diff snapshots with the previous one to delete components / relations which are not in the snapshot anymore.
  * `stop_snapshot`: Boolean \(true/false\). When set to "true" this message is handled as the end of a snapshot.
  * `delete_ids`: List of external ids. List of components or relations that should be deleted. All components and relations that are not repeated in a snapshot will be deleted automatically, thus this field is only necessary when _not_ sending a snapshot.
* `instance`: Describes the type and unique ID \(URL format\) of the topology data.
  * `type`: A type name for the topology data.
  * `URL`: Unique identifier for the source of this topology. This is used to generate a unique Kafka topic name for the topology data.
* `components`: A list of components. Per component you have the following fields:
  * `externalId`: A unique ID for this component. This has to be unique for this instance.
  * `type`: A named parameter for this type.
  * `data`: A JSON blob of arbitrary data.
* `relations`: A list of relations. Per relation you have the following fields:
  * `externalId`: A unique ID for this relation. This has to be unique for this instance.
  * `type`: A named parameter for this type.
  * `data`: A JSON blob of arbitrary data.  
  * `sourceId`: This refers to the source component externalId.
  * `targetId`: This refers to the target component externalId.

The following fields are mandatory, but can be left empty as seen in the example above. Refer to the links below for details on how to use them:

* [events](../telemetry/send_telemetry.md#events)
* [metrics](../telemetry/send_telemetry.md#metrics)
* `service_checks`

### Getting started with custom topology

The [push-integration tutorial](../../develop/tutorials/push_integration_tutorial.md) is a good way to get started sending your own topology into StackState.

