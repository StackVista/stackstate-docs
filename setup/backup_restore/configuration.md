---
title: Backup and Restore StackState Configuration
kind: Documentation
---

StackState's configuration can be exported and imported. The import/export functionality can be used to automate the installation process and/or for backup purposes. An export and import can be made in the settings page of StackState's user interface by using the buttons 'Export Model' and 'Import Model'.

### Automated configuration export

The export of the configuration can be obtained by:

```
curl -X POST -H 'Content-Type: application/json;charset=UTF-8' -d '{"allNodesOfTypes":["ComponentType","RelationType","Domain","Layer","Environment","DataSource","QueryView","EventHandler","CheckFunction","BaselineFunction","PropagationFunction","EventHandlerFunction","ComponentTemplateFunction","RelationTemplateFunction","ComponentMappingFunction","RelationMappingFunction","IdExtractorFunction","ViewHealthStateConfigurationFunction","Sync"]}' "http://<host>:7070/api/export?timeoutSeconds=300" > export.stj
```

Or via the [CLI](/setup/cli) by:

```
sts graph list --ids ComponentType RelationType Domain Layer Environment DataSource QueryView EventHandler CheckFunction BaselineFunction PropagationFunction EventHandlerFunction ComponentTemplateFunction RelationTemplateFunction ComponentMappingFunction RelationMappingFunction IdExtractorFunction ViewHealthStateConfigurationFunction Sync | xargs sts graph export --ids
```

Note that the above CLI command returns output in the terminal window only. To get the `export.conf` file follow the below example:

```
sts-cli graph list --ids ComponentAction | xargs sts graph export --ids < export.conf
```

### Automated configuration export with authentication

StackState server can be configured to authenticate users when they access the application. In this case, the export CLI script is required to first obtain a token before making the export request.

Here is a sample sequence of commands to achieve this:

```
# obtain session from cookie AkkaHttpPac4jSession and token from cookie pac4jCsrfToken
curl --fail -v -d "username=<my_username>&password=<my_password>" -H "Content-Type: application/x-www-form-urlencoded" "http://<host>:7070/loginCallback"

# do actual request
SESSION=<session>; TOKEN=<token>; curl -v -X POST -H 'Content-Type: application/json;charset=UTF-8' -d '{"allNodesOfTypes":["ComponentType","RelationType","Domain","Layer","Environment","DataSource","QueryView","EventHandler","CheckFunction","BaselineFunction","PropagationFunction","EventHandlerFunction","ComponentTemplateFunction","RelationTemplateFunction","ComponentMappingFunction","RelationMappingFunction","IdExtractorFunction","ViewHealthStateConfigurationFunction","Sync"]}' -H Cookie:AkkaHttpPac4jSession=$SESSION -H X-Sts-Token:$TOKEN "http://<host>:7070/api/export?timeoutSeconds=300" > config.stj
```

### Automated configuration import

Import is intended to be a one-off action, importing multiple times might result in duplicate configuration entries. This behavior applies to importing nodes without any identifier. It is possible to clear StackState's configuration before an import. To clear StackState of any configuration use:

```
curl -X POST -f "http://<host>:7071/clear"
```

The StackState configuration file can be imported by:

```
curl -X POST -d @./export.stj -H 'Content-Type: application/json;charset=UTF-8' "http://<host>:7070/api/import?timeoutSeconds=15"
```

If authentication is needed:
```
# obtain session from cookie AkkaHttpPac4jSession and token from cookie pac4jCsrfToken
curl --fail -v -d "username=<my_username>&password=<my_password>" -H "Content-Type: application/x-www-form-urlencoded" "http://<host>:7070/loginCallback"

# do actual request
SESSION=<session>; TOKEN=<token>; curl -X POST -d @config.stj -H 'Content-Type: application/json;charset=UTF-8' -H Cookie:AkkaHttpPac4jSession=$SESSION -H X-Sts-Token:$TOKEN "http://<host>:7070/api/import?timeoutSeconds=15"
```


Or via the [CLI](/setup/cli) by:

```
sts graph import < export.stj
```

### Importing or exporting individual configuration items

It is possible to export and import individual configuration items through the StackState user interface. For example, to export a component type go to the Settings page and click on 'Component Types':

{{<img src="setup/installation/conf_export_settings_page.png" alt="Setting menu" style="width:50%">}}

To export an individual component type, click on 'Export as config':

{{<img src="setup/installation/conf_export_specific.png" alt="Export individual configuration" style="width:50%">}}

An individual configuration item can be imported through settings button 'Import Model'.

### Idempotent import/export

There is a way to use identifiers and namespaces that come with them to perform a configuration update of the specific sets of nodes idempotently. This approach does not lead to duplicates, but checks for the changes within a specified namespace and applies them to existing nodes, including removing nodes, as well as allow for creating the new ones.

Node identifiers are specified in a following pattern: `urn:stackpack:{stackpack_name}:{type_name}:{object_name}`. The namespace effectively used by this process is `urn:stackpack:{stackpack_name}:`. If every configuration node has an identifier and they are all in the same namespace, then you can perform an idempotent update using following STS CLI commands:

For export:
`sts graph export --namespace urn:stackpack:{stackpack_name}:`

For import currently we have a curl way:
`curl -XPOST http://yourInstance/api/import?namespace=urn:stackpack:{stackpack_name} --data @./filename -H 'Content-Type: application/json'`

### Configuration Export Versioning

*Available since StackState version 1.14.0*

As StackState evolves versioning of the exported Node elements is necessary. The export conf contains metadata stating the Node version (`_version`) which is useful in order to allow an autoupgrade to a more recent version of StackState and ensure compatibility.
```
{
  "_version": "1.0.0",
  "timestamp": "2018-12-06T12:30:44.148Z[Etc/UTC]",
  "nodes": [
    {
      "_type": "CheckFunction",
      "name": "Metric fixed run state",
      "returnTypes": [
        "RUN_STATE"
      ],
      "description": "This check will always return the run state that is provided when a metric has been received.",
      "id": -196,
      "script": "return metricFixedRunState;",
      "parameters": [
        {
          "_type": "Parameter",
          "name": "metrics",
          "system": false,
          "id": -194,
          "multiple": false,
          "type": "METRIC_STREAM",
          "required": true
        },
        {
          "_type": "Parameter",
          "name": "metricFixedRunState",
          "system": false,
          "id": -195,
          "multiple": false,
          "type": "RUN_STATE_VALUE",
          "required": true
        }
      ]
    }
  ]
}
```

### Supported Configuration Export version

A configuration export is supported by versions of StackState that are equal or higher than the export's version and with the same major version (see [semver](https://semver.org)).
The first configuration export version is *1.0.0*, and effectively any Node payload with a version below or missing the version field (`_version`) will be interpreted and auto-upgraded to version *1.0.0*.

#### For example: ####

Configuration export version *1.0.0* was introduced in StackState version *1.14.0*<br/>
Later configuration export version *1.1.0* was introduced in StackState version *1.14.1*<br/>
Later configuration export version *2.0.0* was introduced in StackState version *1.15.0*<br/>

This means that Nodes with Configuration version *1.0.0* will work on both StackState *1.14.0* and *1.14.1* but not in *1.15.0* as a major configuration export version (*2.0.0*) was introduced.
As well it means that configuration export version *1.1.0* can only be used from StackState version *1.14.1* but not before as in *1.14.0*

#### Configuration export versions ####
The table below displays configuration export versions version and on which StackState versions they were introduced.
<div class="table-responsive-sm">
<table class="table table-sm table-bordered">
  <tbody>
    <tr>
      <th class="text-center" scope="col">Configuration Export version</th>
      <th class="text-center" scope="col">Introduced on StackState version</th>
    </tr>
    <tr>
      <td class="text-center">1.0.0</td>
      <td class="text-center">1.14.0</td>
    </tr>
  </tbody>
</table>
</div>
