---
description: StackState Self-hosted v5.1.x 
---

# Synchronizations and templated files

To obtain the `.stj` Templated file for your StackPack you need to perform a few steps in StackState Settings page and then edit the template file by hand.

Every .stj template is filled with information about the hosts and environments that StackState collects data from. Example of this information looks like this:

{% code lineNumbers="true" %}
```text
{
  "nodes": [
    {
      "_type": "Layer",
      "description": "Some layer",
      "id": -1,
      "identifier": "urn:stackpack:dummy:layer:a",
      "name": "A",
      "order": 1.0
    },
    {
      "_type": "Layer",
      "description": "Some other layer",
      "id": -2,
      "identifier": "urn:stackpack:dummy:layer:b",
      "name": "B",
      "order": 2.0
    }
  ],
  "timestamp": "2019-05-31T18:36:35Z",
  "version": "0.1"
}
```
{% endcode %}

## How to get a templated file for your StackPack

Preparing a templated file is a process that requires some configuration of StackState. To get the above file in a structure that can be used to create a StackPack, follow the below route:

### 1. Prepare a check in StackState Agent

The first step is to prepare a check using the Agent V2 StackPack. This step allows for getting data from synchronizations that you configure in the next steps. Find out more about [Agent V2 checks](../../setup/agent/about-stackstate-agent.md).

### 2. Install Custom Synchronization StackPack

To install this StackPack go to StackState's StackPacks section and locate the "Custom Synchronization" in Other StackPacks. During the installation process, you need to provide the following information:

* Instance type \(source identifier\) - this is the identifier for the resource that you want to integrate with StackState, for example, AWS, Azure and Zabbix.
* Instance URL - The URL of the instance the data is being reported for.

When the above information is provided click the "Install" button and if Agent V2 checks are working you should start to see the topology coming in for your integration and the "Custom Synchronization" should become enabled.

### 3. Configure Layers, Domains, and Environments

Once you have installed Custom Synchronization StackPack, you need to start preparing the configuration that's needed for your integration.

There are some default Layers, Domains, and Environments created by StackState. Layers are used for vertical separation between components; Domains are used for horizontal separation between components; Environments are grouping components. You can add custom Layers, Domains, and Environments in the Settings pages to match your StackPack needs.

These can also be created automatically by StackState using the `getOrCreate` functionality described [a little further in this document](../reference/stj/stj_reference.md).

### 4. Configure Component and Relation types

There are some default component and relation types in StackState. Component types are used to visualize components with a given icon; [relation types](/use/concepts/relations.md) describe relations between components.

Component types and Relation types can also be created automatically by StackState using the `getOrCreate` functionality described in the `Component + Relation Templates` section. Auto-generated components types will be created without an icon.

### 5. Prepare ID Extractor Functions

When creating a StackPack, it's important to have a `component` and `relation` identity extractor function. There are a few default ID Extractor Functions present in StackState. The `Auto sync component id extractor` and `Auto sync relation id extractor` are good starting points for your StackPack. You can go ahead and rename these, add a description if needed, and confirm the popup dialog to unlock these ID Extractor Functions from the `Custom Synchronization` StackPack.

➡️ [Learn more about ID Extractors](custom-functions/id-extractor-functions.md)

### 6. Prepare Component and Relation Mapping Functions

Component Mapping Functions are used by StackState to do some translation of incoming component data. They are applied in the Synchronization for a given source/component type.

Mapping functions are an optional step in the Synchronization flow. [Find out more about Mapping Functions](custom-functions/mapping-functions.md).

### 7. Configure Component and Relation Templates

Once you have installed the `Custom Synchronization` StackPack, it creates a Component Template called `autosync-component-template`. Similarly, `Custom Synchronization` StackPack, creates a Relation Template called `autosync-relation-template`.

You can go ahead and rename it, add a description if needed. It's recommended to change the default value of the `ComponentType` from `Auto-synced Component` to something that represents a generic component in your data source. The same goes for `Layer`, `Domain` and `Environment` which defaults to `Auto-synced Components`, `Auto-synced Domain`,`Auto-synced Environment` respectively. As this template is using the `getOrCreate` functionality, these values are auto-created by StackState if they don't already exist. Find more on Templates [here](../reference/stj/using_stj.md).

Once you have completed all the changes, you can click **UPDATE** and confirm the popup dialog to unlock this Template from the `Custom Synchronization` StackPack.

### 8. Configure Sts Sources - Topology Sources

Once you have installed the `Custom Synchronization` StackPack, it creates a StackState DataSource called `Internal kafka`. This data source is a good starting point for your StackPack. You can change the name of it, add a description if needed. You can observe the `Integration Type` and `Kafka Topic` are a representation of the information you supplied in the `Custom Synchronization` StackPack instance details. More on Topology Sources [here](../../configure/topology/topology_sources.md)

Once you have completed all the changes, you can click **UPDATE** and confirm the popup dialog to unlock this StackState DataSource from the `Custom Synchronization` StackPack.

### 9. Configure Synchronizations

Synchronizations are defined by a data source and several mappings from the external system topology data into StackState topology elements using Component and Relation Mapping Functions, as well as Component and Relation Templates. `Custom Synchronization` StackPack delivers a Synchronization called `default auto synchronization`. You can [find more on Synchronizations](../../configure/topology/send-topology-data.md) or proceed to edit this synchronization with the instructions below:

#### Step 1

We recommend that you change the `Synchronization Name` and add a `Description` if needed. There is no action required on `Plugin`, it uses the `Sts` plugin to synchronize data from StackState Agent V2.

#### Step 2

There is no action needed here. However, you can observe the data source, component, and relation identity extractor, as well as whether this synchronization processes historical data. The recommended setting here is to keep this setting off.

#### Step 3

This is where the Component Mappings are defined. The `Custom Synchronization` StackPack defines a `default component mapping` which can be seen at the bottom of the wizard for all "Other Sources".

Here you can define all your own components mappings for different resources.

#### Step 4

This is where the Relation Mappings are defined. The `Custom Synchronization` StackPack defines a `default relation mapping` which can be seen at the bottom of the wizard for all `Other Sources`.

Here you can define all your own relation mappings for different sources.

#### Step 5

Verify all the changes and click "Save". On the popup dialog that appears right after saving click "Confirm" to unlock this synchronization from the `Custom Synchronizations` StackPacks.

### 10. Export the StackState Configuration

When your integration is working and has a shape that you expect, you can convert StackState's configuration into a StackPack template file. To do this go to the **Settings** page and at the bottom of the left menu, you can find an Import/Export section. Click on the `STS-EXPORT-ALL-{Date}.conf` button on the main screen. This exports all of StackState's configuration into a config file format.

The configuration file has the following format:

```text
{
  "_version": "1.0.5",
  "timestamp": "export_timestamp_here",
  "nodes": [{
      ...
  }]
}
```

### 11. Convert your StackState configuration file to the `.stj` template

Each of the node elements represents a configuration item in StackState. This config file contains all of the configuration of your StackState instance, which means you have to take out unnecessary configuration node objects. Take the steps below to convert your configuration file into an `.stj` template file:

* Remove all configuration `node` objects that are owned by another StackPack. They all have a field called `ownedBy`.
* StackState uses an urn-based identifiers, you can go ahead and define an urn for each of your configuration objects.
* Items that are extended from the `Custom Synchronization` StackPack, will have their urn `identifier` field with the following structure: `urn:stackpack:autosync:{type_name}:{object_name}`.
* Typical `identifier` pattern that you can find across our StackPacks configuration is: `urn:stackpack:{stackpack_name}:{type_name}:{object_name}`
* For StackPacks that can have multiple instances the identifier has a slightly different pattern: `urn:stackpack:{stackpack_name}:instance:{{instanceId}}:{type_name}:{object_name}` where `{{instanceId}}` is uniquely genrated for every instance of the StackPack.

The only way to add/modify the identifiers is the manual edit of the configuration file. This option will be available also through UI in the upcoming releases.

After cleaning up the configuration file it's time to template out the variables exposed by your StackPack. As explained in the [Configuration input](stackpack/prepare_package.md) documentation section, it's possible to define some input fields that your StackPack requires to authenticate against some external sources and to differentiate between instances. To generalize the configuration, it's needed to inject the configuration file with some template parameters which is provided by the [Provisioning Script](stackpack/prepare_stackpack_provisioning_script.md). Any parameters or configuration item can be passed down to the `.stj` template file.

One common example is to create the topic name required by the data source for a given instance. To ensure data received from the StackState Agent Check ends up in your StackPack's data source, make sure that you create the same topic in the provisioning script. Following code snippet shows how to create a function called `topicName` that generates a topic name for this instance based on the data provided by the user in the StackPack installation step.

```text
@Override
ProvisioningIO<scala.Unit> install(Map<String, Object> config) {
    def templateArguments = [
        'topicName': topicName(config),
        ... more template variables here ...
    ]
    // we place all the config variables in our template arguments as well.
    templateArguments.putAll(config)

    return context().sts().importSnapshot(context().stackPack().namespacePrefix(), "templates/{stackpack}.stj", templateArguments)
}

private def topicName(Map<String, Object> stackpackConfig) {
    def instance_url = stackpackConfig.instance_url
    def topic = instance_url.replace("/", "_").replace(":", "_")
    return context().sts().createTopologyTopicName("your_instance_type", topic)
}
```

It is possible now to reference any of the above `templateArguments` in your `.stj` template file. In case of the `topicName` you can replace the `topic` value in the `config` section of your StackState DataSource with this parameter:

```text
{
    "_type": "DataSource",
    "name": "StackPack Data Source",
    "identifier": "urn:stackpack:stackpack_name:datasource:stackpack_data_source",
    "config": {
      ...
      "topic": "{{ topicName }}"
    },
    ...
}
```

