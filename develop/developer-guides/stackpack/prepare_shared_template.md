# Prepare a shared template

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

Shared template file contains information that is going to be used across instances, like: Component Types, IdExtractor functions for components and relations, Component Template functions, Relation Template functions, or Layers. They can be derived from the exported `.stj` file, by exporting configuration nodes with `shared` in their identifiers, for example `"identifier": "urn:stackpack:{StackPackName}:shared:relation-template-function:test-relation-template",`.

Shared template file contains information that is going to be used across instances, like:

## Component Types

Component Type in a template file contains an icon image that is coded in `png;base64` as in the example below:

```javascript
{
"_type": "ComponentType", 
"name": "exchange_server", 
"id": -147, 
"identifier": "urn:stackpack:{{StackPackName}}:shared:component-type:exchange-server", 
"iconbase64": "{{ include "./icons/icon.png" "base64" }}" 
},
```

## Relation Types

Contains Relation name and direction.

```javascript
  {
  "_type": "RelationType",
  "name": "hosted_on",
  "id": -121,
  "identifier": "urn:stackpack:{{StackPackName}}:shared:relation-type:hosted_on",
  "dependencyDirection": "ONE_WAY"
  }
```

## Component Template functions

```javascript
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

## Relation Template functions

```javascript
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

## Component IdExtractor functions

```javascript
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

## Relation IdExtractor functions

```javascript
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

## Layers

```javascript
  {
      "_type": "Layer",
      "name": "Management Pack",
      "id": -114,
     "identifier": "urn:stackpack:{{StackPackName}}:shared:layer:management_pack",
      "order": 703.0
    },
```

## Domains

```javascript
  {
      "_type": "Domain",
      "name": "Management Pack",
      "id": -114,
     "identifier": "urn:stackpack:{{StackPackName}}:shared:domain:management_pack",
      "order": 703.0
    },
```

## Environments

```javascript
  {
      "_type": "Environment",
      "name": "Test",
      "id": -114,
     "identifier": "urn:stackpack:{{StackPackName}}:shared:environment:test",
      "order": 703.0
    },
```

The next step is: [Prepare an instance template file](prepare_instance_template_file.md)

