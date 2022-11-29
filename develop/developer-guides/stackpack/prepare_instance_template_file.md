---
description: StackState Self-hosted v5.1.x 
---

# Prepare instance template files

When preparing an instance specific template file, keep in mind that you will use some identifiers that point to the shared template file. It is highly recommended to [prepare your shared template first](prepare_shared_template.md).

In this file you need to provide configuration blocks for the DataSource used by this instance, Topology information, QueryViews, etc. You can identify them in your export `.stj` file by identifier with `instance` entry, for example `"urn:stackpack:{{StackPackName}}:instance:{{instanceId}}:sync:test"`. However, this file also requires pointers to functions, Component templates, and Relation templates from the shared template file as in the below example:

Also, in this file you need to provide mapping functions called `componentActions` from the shared-template file to execute on the instance nodes:

### Synchronizations and `componentActions` mappings

```javascript
{
"_type": "Sync",
"name": "Test",
"identifier": "urn:stackpack:{{StackPackName}}:instance:{{instanceId}}:sync:test",
"relationActions": [],
"extTopology": -142, 
"topologyDataQuery": 
    {
        "_type": "Sts.StsTopologyElementsQuery", 
        "relationIdExtractorFunction": {{get "urn:stackpack:{{StackPack name}}:shared:idextractor-function:test-relation-id-extractor"}},
        "componentIdExtractorFunction": {{get "urn:stackpack:{{StackPack name}}:shared:idextractor-function:test-component-id-extractor"}},
        "id": -191,
        "consumerOffsetStartAtEarliest": false
    },
"componentActions":
    [
        {
            "_type": "SyncActionCreateComponent",
            "templateFunction": {{get "urn:stackpack:{{StackPackName}}:shared:component-template-function:exchange-service-template"}},
            "id": -190,
            "mergeStrategy": "MergePreferTheirs",
            "type": "exchange_service"
        }
    ],
"id": -2,
"defaultComponentAction":
    {
        "_type": "SyncActionCreateComponent",
        "templateFunction": {{get "urn:stackpack:{{StackPackName}}:shared:component-template-function:exchange-component-template"}},
        "id": -1,
        "mergeStrategy": "MergePreferTheirs",
        "type": "default_component_mapping"
    },
"defaultRelationAction":
    {
        "_type": "SyncActionCreateRelation",
        "templateFunction": {{get "urn:stackpack:{{StackPackName}}:shared:relation-template-function:test-relation-template"}},
        "id": -188,
        "mergeStrategy": "MergePreferTheirs",
        "type": "default_relation_mapping"
    }
},
```

After getting Synchronizations and Mappings from the shared-template into your instance-specific file, you can start looking for instance-specific blocks in the STJ export and copy them to your instance-specific template. You can identify instance specific blocks, as their Identifier contains `instance:{{instanceId}}` segment.

### DataSources

```javascript
  {
    "_type": "DataSource",
    "name": "test",
    "identifier": "urn:stackpack:{{StackPackName}}:instance:{{instanceId}}:data-source:test",
    "pluginId": "Sts",
    "config": {
      "expireElementsAfter": 172800000,
      "_type": "Sts.StsTopologyDataSourceConfig",
      "autoExpireElements": false,
      "id": -143,
      "supportedWindowingMethods": [],
      "integrationType": "test",
      "supportedDataTypes": ["TOPOLOGY_ELEMENTS"],
      "topic": "{{ topicName }}"
    },
    "id": -140,
    "uiRequestTimeout": 15000
  },
```

### Topology Information

```javascript
  "extTopology": {
    "_type": "ExtTopology",
    "dataSource": -140,
    "id": -142,
    "settings": {
      "_type": "TopologySyncSettings",
      "cleanupInterval": 3600000,
      "maxBatchesPerSecond": 5,
      "id": -141,
      "maxBatchSize": 200,
      "cleanupExpiredElements": false
    }
  },
```

### QueryViews

```javascript
{
  "_type": "QueryView",
  "name": "TEST - {{instance_url}}",
  "query": "(domain IN (\"TEST\"))",
  "minimumGroupSize": 8,
  "groupedByDomains": true,
  "id": -72,
  "identifier": "urn:stackpack:{{StackPackName}}:instance:{{instanceId}}:query-view:test",
  "groupedByLayers": true,
  "showIndirectRelations": false,
  "groupingEnabled": true,
  "queryVersion": "0.0.1"
}
```

## Example of an instance template file:

```javascript
{
"nodes":
    [
        {
            "_type": "Sync",
            "name": "sync-Name",
            "identifier": "urn:stackpack:{{StackPack Name}}:instance:{{instanceId}}:sync:{{sync-name}}",
            "relationActions": [],
            "extTopology": -142,
            "topologyDataQuery":
                {
                    "_type": "Sts.StsTopologyElementsQuery",
                    "relationIdExtractorFunction": {{get "urn:stackpack:{{StackPack Name}}:shared:idextractor-function:relation-id-extractor"}},
                    "componentIdExtractorFunction": {{get "urn:stackpack:{{StackPack Name}}:shared:idextractor-function:component-id-extractor"}},
                    "id": -191,
                    "consumerOffsetStartAtEarliest": false
                },
            "componentActions":
                [
                    {
                        "_type": "SyncActionCreateComponent",
                        "templateFunction": {{get "urn:stackpack:{{StackPack Name}}:shared:component-template-function:exchange-service-template"}},
                        "id": -190,
                        "mergeStrategy": "MergePreferTheirs",
                        "type": "exchange_service"
                    }
                ],
            "id": -2,
            "defaultComponentAction":
                {
                    "_type": "SyncActionCreateComponent",
                    "templateFunction": {{get "urn:stackpack:{{StackPack Name}}:shared:component-template-function:exchange-component-template"}},
                    "id": -1,
                    "mergeStrategy": "MergePreferTheirs",
                    "type": "default_component_mapping"
                },
            "defaultRelationAction":
                {
                    "_type": "SyncActionCreateRelation",
                    "templateFunction": {{get "urn:stackpack:{{StackPack Name}}:shared:relation-template-function:relation-template"}},
                    "id": -188,
                    "mergeStrategy": "MergePreferTheirs",
                    "type": "default_relation_mapping"
                }
        },
        {
            "_type": "DataSource",
            "name": "datasource",
            "identifier": "urn:stackpack:{{StackPack Name}}:instance:{{instanceId}}:data-source:{{datasource}}",
            "pluginId": "Sts",
            "config":
                {
                    "expireElementsAfter": 172800000,
                    "_type": "Sts.StsTopologyDataSourceConfig",
                    "autoExpireElements": false,
                    "id": -143,
                    "supportedWindowingMethods": [],
                    "integrationType": "{type}",
                    "supportedDataTypes": ["TOPOLOGY_ELEMENTS"],
                    "topic": "{{ topicName }}"
                },
            "extTopology":
                {
                    "_type": "ExtTopology",
                    "dataSource": -140,
                    "id": -142,
                    "settings":
                        {
                            "_type": "TopologySyncSettings",
                            "cleanupInterval": 3600000,
                            "maxBatchesPerSecond": 5,
                            "id": -141,
                            "maxBatchSize": 200,
                            "cleanupExpiredElements": false
                        }
                },
            "id": -140,
            "uiRequestTimeout": 15000
        },
        {
            "_type": "QueryView",
            "name": "ViewName - {{instance_url}}", "query": "(domain IN (\"TEST\"))",
            "minimumGroupSize": 8,
            "groupedByDomains": true,
            "id": -72,
            "identifier": "urn:stackpack:{{StackPack Name}}:instance:{{instanceId}}:query-view:test",
            "groupedByLayers": true,
            "showIndirectRelations": false,
            "groupingEnabled": true,
            "queryVersion": "0.0.1"
        }
    ],
    "timestamp": "2019-05-31T18:03:38Z",
    "version": "0.1"
}
```

The next step is: [Prepare a multi-instance provisioning script](prepare_multi-instance_provisioning_script.md)

