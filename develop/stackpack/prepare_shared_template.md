---
title: Prepare a shared template file
kind: Documentation
---

Shared template file contains information that is going to be used across instances, like: Component Types, IdExtractor functions for components and relations, Component Template functions, Relation Template functions, or Layers. They can be derived from the exported `.stj` file, by exporting configuration nodes with `shared` in their identifiers, e.g. `"identifier": "urn:stackpack:{StackPackName}:shared:relation-template-function:test-relation-template",`.


Shared template file contains information that is going to be used across instances, like:

##### Component Types

Component Type in a template file contains an icon image that is coded in `png;base64` as in the example below:

<details>
  <summary>Click to expand the example</summary>

  ```json
  {
  "_type": "ComponentType",
  "name": "exchange_server",
  "id": -147,
  "identifier": "urn:stackpack:{{StackPackName}}:shared:component-type:exchange-server",
  "iconbase64": "{{ include "./icons/icon.png" "base64" }}"
},
```
</details>

##### Relation Types

Contains Relation name and direction.

```json
  {
  "_type": "RelationType",
  "name": "hosted_on",
  "id": -121,
  "identifier": "urn:stackpack:{{StackPackName}}:shared:relation-type:hosted_on",
  "dependencyDirection": "ONE_WAY"
  }
```


##### Component Template functions

```json
  {
  "_type": "ComponentTemplateFunction",
  "name": "Exchange component template",
  "identifier": "urn:stackpack:{{StackPackName}}:shared:component-template-function:exchange-component-template",
  "handlebarsTemplate": "{\n  \"_type\": \"Component\",\n  \"checks\": [],\n  \"streams\": [],\n  \"labels\": \{{#if element.data.labels\}}[\n    \{{# join element.data.labels \",\" \}}\n    {\n      \"_type\": \"Label\",\n      \"name\": \"\{{ this \}}\"\n    }\n    \{{/ join \}}\n  ]\{{else\}}[]\{{/if\}},\n  \"name\": \"\{{#if element.data.name\}}\{{ element.data.name \}}\{{else\}}\{{ element.externalId \}}\{{/if\}}\",\n\{{#if element.data.description\}}\"description\": \"\{{ element.data.description \}}\",\{{/if\}}\n\"type\" : \{{ getOrCreate \"ComponentType\" element.type.name \"Exchange component\" \}},\n  \"version\": \"\{{ element.data.version \}}\",\n  \"layer\": \{{ getOrCreate \"Layer\" element.data.layer \"Exchange Orgnization\" \}},\n  \"domain\": \{{ getOrCreate \"Domain\" element.data.domain \"TEST\" \}},\n  \"environments\": [\n    \{{ getOrCreate \"Environment\" element.data.environment \"Production\" \}}\n  ]\n}\n",
  "id": -185,
  "parameters": [{
    "_type": "Parameter",
    "name": "element",
    "system": false,
    "id": -184,
    "multiple": false,
    "type": "STRUCT_TYPE",
    "required": true
  }]
  },
```


##### Relation Template functions


```json
  {
    "_type": "RelationTemplateFunction",
    "handlebarsTemplate": "{\n  \"_type\": \"Relation\",\n  \"checks\": [],\n  \"streams\": [],\n  \"labels\": [],\n  \"name\": \"\{{ element.name \}}\",\n  \"description\": \"\{{ element.description \}}\",\n  \"type\": \{{ getOrCreate \"RelationType\" element.type.name \"test-generic-relation\" \}},\n  \"dependencyDirection\": \"ONE_WAY\",\n  \"source\": \{{ element.sourceId \}},\n  \"target\": \{{ element.targetId \}}\n}\n",
    "id": -17,
    "identifier": "urn:stackpack:{{StackPackName}}:shared:relation-template-function:relation-template",
    "name": "TEST Relation Template",
    "parameters": [
      {
        "_type": "Parameter",
        "id": -18,
        "multiple": false,
        "name": "element",
        "required": true,
        "system": false,
        "type": "STRUCT_TYPE"
      }
    ]
  },
```


##### Component IdExtractor functions


```json
  {
    "_type": "IdExtractorFunction",
    "description": "A generic component id extractor function for topology component elements.",
    "groovyScript": "element = topologyElement.asReadonlyMap()\n\nexternalId = element[\"externalId\"]\ntype = element[\"typeName\"].toLowerCase()\ndata = element[\"data\"]\n\nidentifiers = new HashSet()\n\nidentifiers.add(externalId)\n\nif(data.containsKey(\"identifiers\") && data[\"identifiers\"] instanceof List<String>) {\n    data[\"identifiers\"].each{ id ->\n        identifiers.add(id)\n    }\n}\n\nreturn Sts.createId(externalId, identifiers, type)\n",
    "id": -12,
    "identifier": "urn:stackpack:{{StackPackName}}:shared:idextractor-function:component-id-extractor",
    "name": "TEST component id extractor",
    "parameters": [
      {
        "_type": "Parameter",
        "id": -13,
        "multiple": false,
        "name": "topologyElement",
        "required": true,
        "system": true,
        "type": "STRUCT_TYPE"
      }
    ]
  },
  ```


##### Relation IdExtractor functions

```json
  {
    "_type": "IdExtractorFunction",
    "description": "A generic relation id extractor function for topology relation elements.",
    "groovyScript": "element = topologyElement.asReadonlyMap()\n\nexternalId = element[\"externalId\"]\ntype = element[\"typeName\"].toLowerCase()\n\nreturn Sts.createId(externalId, new HashSet(), type)\n",
    "id": -14,
    "identifier": "urn:stackpack:{{StackPackName}}:shared:idextractor-function:relation-id-extractor",
    "name": "TEST relation id extractor",
    "parameters": [
      {
        "_type": "Parameter",
        "id": -15,
        "multiple": false,
        "name": "topologyElement",
        "required": true,
        "system": true,
        "type": "STRUCT_TYPE"
      }
    ]
  },
```



##### Layers

```json
  {
      "_type": "Layer",
      "name": "Management Pack",
      "id": -114,
     "identifier": "urn:stackpack:{{StackPackName}}:shared:layer:management_pack",
      "order": 703.0
    },
```

##### Domains

```json
  {
      "_type": "Domain",
      "name": "Management Pack",
      "id": -114,
     "identifier": "urn:stackpack:{{StackPackName}}:shared:domain:management_pack",
      "order": 703.0
    },
```


##### Environments

```json
  {
      "_type": "Environment",
      "name": "Test",
      "id": -114,
     "identifier": "urn:stackpack:{{StackPackName}}:shared:environment:test",
      "order": 703.0
    },
```



#### Example of a shared template file:
<details>
  <summary>Click to expand</summary>

  ```json
  {
    "nodes": [
    {
      "_type": "IdExtractorFunction",
      "description": "A generic component id extractor function for topology component elements.",
      "groovyScript": "element = topologyElement.asReadonlyMap()\n\nexternalId = element[\"externalId\"]\ntype = element[\"typeName\"].toLowerCase()\ndata = element[\"data\"]\n\nidentifiers = new HashSet()\n\nidentifiers.add(externalId)\n\nif(data.containsKey(\"identifiers\") && data[\"identifiers\"] instanceof List<String>) {\n    data[\"identifiers\"].each{ id ->\n        identifiers.add(id)\n    }\n}\n\nreturn Sts.createId(externalId, identifiers, type)\n",
      "id": -12,
      "identifier": "urn:stackpack:{{StackPackName}}:shared:idextractor-function:component-id-extractor",
      "name": "TEST component id extractor",
      "parameters": [
        {
          "_type": "Parameter",
          "id": -13,
          "multiple": false,
          "name": "topologyElement",
          "required": true,
          "system": true,
          "type": "STRUCT_TYPE"
        }
      ]
    },
  {
    "_type": "IdExtractorFunction",
    "description": "A generic relation id extractor function for topology relation elements.",
    "groovyScript": "element = topologyElement.asReadonlyMap()\n\nexternalId = element[\"externalId\"]\ntype = element[\"typeName\"].toLowerCase()\n\nreturn Sts.createId(externalId, new HashSet(), type)\n",
    "id": -14,
    "identifier": "urn:stackpack:{{StackPackName}}:shared:idextractor-function:relation-id-extractor",
    "name": "TEST relation id extractor",
    "parameters": [
      {
        "_type": "Parameter",
        "id": -15,
        "multiple": false,
        "name": "topologyElement",
        "required": true,
        "system": true,
        "type": "STRUCT_TYPE"
      }
    ]
  },
    {
        "_type": "CheckFunction",
        "name": "test Health check",
        "returnTypes": ["HEALTH_STATE"],
        "id": -26,
        "identifier": "urn:stackpack:{{StackPackName}}:shared:check-function:test-health-check",
        "script": "def event = events[events.size() - 1]\n\n\ndef tags = event.point.getStructOrEmpty(\"tags\")\nOptional<Integer> healthStateOpt = tags.getString(\"status\")\n\nhealthState = healthStateOpt\n    .map { state -> switch(state.toLowerCase()) {\n        case \"healthy\": return CLEAR\n        case \"deviating\": return DEVIATING\n        case \"error\": return CRITICAL\n        default: return UNKNOWN\n    \}}\n\n\nreturn healthState",
        "parameters": [{
          "_type": "Parameter",
          "name": "events",
          "system": false,
          "id": -24,
          "multiple": false,
          "type": "EVENT_STREAM",
          "required": true
        }]
      },
      {
      "_type": "ComponentTemplateFunction",
      "name": "Exchange component template",
      "identifier": "urn:stackpack:{{StackPackName}}:shared:component-template-function:exchange-component-template",
      "handlebarsTemplate": "{\n  \"_type\": \"Component\",\n  \"checks\": [],\n  \"streams\": [],\n  \"labels\": \{{#if element.data.labels\}}[\n    \{{# join element.data.labels \",\" \}}\n    {\n      \"_type\": \"Label\",\n      \"name\": \"\{{ this \}}\"\n    }\n    \{{/ join \}}\n  ]\{{else\}}[]\{{/if\}},\n  \"name\": \"\{{#if element.data.name\}}\{{ element.data.name \}}\{{else\}}\{{ element.externalId \}}\{{/if\}}\",\n\{{#if element.data.description\}}\"description\": \"\{{ element.data.description \}}\",\{{/if\}}\n\"type\" : \{{ getOrCreate \"ComponentType\" element.type.name \"Exchange component\" \}},\n  \"version\": \"\{{ element.data.version \}}\",\n  \"layer\": \{{ getOrCreate \"Layer\" element.data.layer \"Exchange Orgnization\" \}},\n  \"domain\": \{{ getOrCreate \"Domain\" element.data.domain \"TEST\" \}},\n  \"environments\": [\n    \{{ getOrCreate \"Environment\" element.data.environment \"Production\" \}}\n  ]\n}\n",
      "id": -185,
      "parameters": [{
        "_type": "Parameter",
        "name": "element",
        "system": false,
        "id": -184,
        "multiple": false,
        "type": "STRUCT_TYPE",
        "required": true
      }]
    },
    {
        "_type": "ComponentTemplateFunction",
        "name": "Exchange service template",
        "handlebarsTemplate": "{\n  \"_type\": \"Component\",\n  \"checks\": [{\n    \"_type\": \"Check\",\n    \"name\": \"Health\",\n    \"syncCreated\": false,\n    \"id\": -22,\n    \"function\": \{{ resolve \"CheckFunction\" \"test Health check\" \}},\n    \"arguments\": [{\n      \"_type\": \"ArgumentEventStreamRef\",\n      \"parameter\": \{{ resolve \"CheckFunction\" \"test Health check\" \"Parameter\" \"events\" \}},\n      \"id\": -25,\n      \"stream\": -21\n    }]\n  }],\n  \"streams\": [{\n    \"_type\": \"EventStream\",\n    \"name\": \"Health\",\n    \"query\": {\n      \"id\": -19,\n      \"conditions\": [{\n        \"key\": \"host\",\n        \"value\": \"\{{element.data.name\}}\"\n      }],\n      \"_type\": \"EventTelemetryQuery\"\n    },\n    \"dataSource\": \{{ get \"urn:stackpack:common:data-source:stackstate-generic-events\"  \}},\n    \"syncCreated\": false,\n    \"id\": -21,\n    \"dataType\": \"EVENTS\"\n  }],\n  \"labels\": \{{#if element.data.labels\}}[\n    \{{# join element.data.labels \",\" \}}\n    {\n      \"_type\": \"Label\",\n      \"name\": \"\{{ this \}}\"\n    }\n    \{{/ join \}}\n  ]\{{else\}}[]\{{/if\}},\n  \"name\": \"\{{#if element.data.name\}}\{{ element.data.name \}}\{{else\}}\{{ element.externalId \}}\{{/if\}}\",\n\{{#if element.data.description\}}\"description\": \"\{{ element.data.description \}}\",\{{/if\}}\n\"type\" : \{{ getOrCreate \"ComponentType\" element.type.name \"Exchange component\" \}},\n  \"version\": \"\{{ element.data.version \}}\",\n  \"layer\": \{{ getOrCreate \"Layer\" element.data.layer \"Exchange Orgnization\" \}},\n  \"domain\": \{{ getOrCreate \"Domain\" element.data.domain \"TEST\" \}},\n  \"environments\": [\n    \{{ getOrCreate \"Environment\" element.data.environment \"Production\" \}}\n ]\n}\n",
        "id": -189,
        "identifier": "urn:stackpack:{{StackPackName}}:shared:component-template-function:exchange-service-template",
        "parameters": [{
          "_type": "Parameter",
          "name": "element",
          "system": true,
          "id": -215,
          "multiple": false,
          "type": "STRUCT_TYPE",
          "required": true
        }]
      },
      {
      "_type": "ComponentType",
      "name": "exchange_server",
      "id": -147,
      "identifier": "urn:stackpack:{{StackPackName}}:shared:component-type:exchange-server",
      "iconbase64": "{{ include "./icons/resource.png" "base64" }}"
    }, {
      "_type": "ComponentType",
      "name": "exchange_service",
      "id": -31,
      "identifier": "urn:stackpack:{{StackPackName}}:shared:component-type:exchange-service",
      "iconbase64": "{{ include "./icons/generic_resource.png" "base64" }}"
    },{
      "_type": "RelationTemplateFunction",
      "handlebarsTemplate": "{\n  \"_type\": \"Relation\",\n  \"checks\": [],\n  \"streams\": [],\n  \"labels\": [],\n  \"name\": \"\{{ element.name \}}\",\n  \"description\": \"\{{ element.description \}}\",\n  \"type\": \{{ getOrCreate \"RelationType\" element.type.name \"test-generic-relation\" \}},\n  \"dependencyDirection\": \"ONE_WAY\",\n  \"source\": \{{ element.sourceId \}},\n  \"target\": \{{ element.targetId \}}\n}\n",
      "id": -17,
      "identifier": "urn:stackpack:{{StackPackName}}:shared:relation-template-function:relation-template",
      "name": "TEST Relation Template",
      "parameters": [
        {
          "_type": "Parameter",
          "id": -18,
          "multiple": false,
          "name": "element",
          "required": true,
          "system": false,
          "type": "STRUCT_TYPE"
        }
      ]
    },
    {
        "_type": "Layer",
        "name": "Management Pack",
        "id": -114,
       "identifier": "urn:stackpack:{{StackPackName}}:shared:layer:management_pack",
        "order": 703.0
      }, {
        "_type": "Layer",
        "name": "Test Server",
        "id": -127,
        "identifier": "urn:stackpack:{{StackPackName}}:shared:layer:_server",
        "order": 704.0
      },
      {
      "_type": "RelationType",
      "name": "hosted_on",
      "id": -121,
      "identifier": "urn:stackpack:{{StackPackName}}:shared:relation-type:hosted_on",
      "dependencyDirection": "ONE_WAY"
    }
    ],
    "timestamp": "2019-05-31T18:03:38Z",
    "version": "0.1"
  }

  ```
</details>


The next step is: [Prepare an instance template file](/develop/stackpack/prepare_instance_template_file/)
