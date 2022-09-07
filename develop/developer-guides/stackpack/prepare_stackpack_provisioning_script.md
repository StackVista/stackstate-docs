---
description: StackState Self-hosted v5.0.x 
---

# Prepare a StackPack provisioning script

{% hint style="warning" %}
**This page describes StackState version 5.0.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/develop/developer-guides/stackpack/prepare_stackpack_provisioning_script).
{% endhint %}

The provisioning script that is used for provisioning the StackPack should extend from `com.stackstate.stackpack.ProvisioningScript`. The provisioning script can be split into multiple groovy scripts. The `provisioning` directory inside the StackPack is part of the classpath, so any groovy script referred to inside the `provisioning` directory is also loaded.

A provisioning script is provided with a set of capabilities that it can execute in the `StackState` environment. The capabilities are restricted to those that are defined as part of `com.stackstate.stackpack.ProvisioningContext` which is passed as a constructor parameter for the `ProvisioningScript`.

Here is an example of a provisioning script:

```text
import com.stackstate.stackpack.ProvisioningContext
import com.stackstate.stackpack.ProvisioningIO
import com.stackstate.stackpack.ProvisioningScript
import com.stackstate.stackpack.ProvisioningIO$
import com.stackstate.stackpack.Version

class SomeProvisioningScript extends ProvisioningScript {
  SomeProvisioningScript(ProvisioningContext context) {
      super(context)
  }

  @Override
  ProvisioningIO<scala.Unit> preInstall(Map<String, Object> config) {
    // Return any action that needs to run globally for this StackPack.
  }

  @Override
  ProvisioningIO<scala.Unit> install(Map<String, Object> config) {
    // Return any action that needs to run per StackPack instance.
  }

  @Override
  ProvisioningIO<scala.Unit> upgrade(Map<String, Object> config, Version previousVersion) {
    // Return any action that needs to be done when upgrading each instance from `previousVersion` to the latest.
  }

  @Override
  ProvisioningIO<scala.Unit> uninstall(Map<String, Object> config) {
    // Return any action that needs to run per StackPack instance.
  }

  @Override
  ProvisioningIO<scala.Unit> postUninstall(Map<String, Object> config) {
    // Return any action that needs to run globally for this StackPack.
  }

  @Override
  void waitingForData(Map<String, Object> config) {
    // Determine wether sufficient data has reached StackState.
  }
}
```

The supported actions are:

* `preInstall` - this action is run when installing the very first instance of a StackPack - it is meant to install all the objects that each of the instances will share.
* `install` - this action is run for every installed instance of a StackPack - it is meant to install instance-specific objects, that will be of use for this instance only.
* `waitingForData` - this action allows the StackPack creator to check wether any external service that this StackPack communicates with is properly sending data that this StackPack can process. By default it just transitions to the `INSTALLED` state.
* `upgrade` - this action is run for every installed instance of a StackPack when the user upgrades their StackPack version.
* `uninstall` - this action is run for every instance when it is being uninstalled - it is meant to clean up all the instance-specific objects.
* `postUninstall` - this action is run when uninstalling the very last instance of a StackPack - it is meant to clean up all the StackPack-shared objects.

## Provisioning script context

A set of useful objects for the above actions are exposed via the provisioning context accessible via the `context()` function.

The provisioning script can interact with the provisioning via the `context()` function:

```text
context()
```

The `context()` function returns an object that provides the following functions:

* `scriptsDirectory()` - returns the path to the directory where this script resides.
* `fail(errorMessage)` - marks this StackPack instance as broken \(StackPack is in `ERROR` state\) with `errorMessage` error message.

### The StackState \(`sts`\) object

The provisioning script can interact with the StackState instance it is running in via the `sts()` function:

```text
context().sts()
```

The `sts()` function returns an object that provides the following functions:

* `intakeApi()` - returns an object representing the StackState Receiver API that receives incoming data. The object supplies the following functions:
  * `apiKey()` - returns the `API_KEY`, this is the API key for the StackState Receiver API. Also referred to as the `<STACKSTATE_RECEIVER_API_KEY>` for clarity in the docs.
  * `baseUrl()` - returns the `RECEIVER_BASE_URL`, this is the base URL for the StackState Receiver API. Also referred to as the `<STACKSTATE_RECEIVER_API_ADDRESS>` for clarity in the docs.
* `log()` - allows logging to be done in the provisioning script. Example: `context().sts().log().debug("Installing test StackPack")`.
* `install(stackpackName, parameters)` - triggers installation of StackPack `stackpackName` with parameters `parameters`.
* `onDataReceived(topic, callback)` - runs a `callback` function whenever data is received by the StackState API on topic `topic`.
* `provisioningComplete()` - called when provisioning is done, marks this StackPack instance state as `INSTALLED`.
* `createTopologyTopicName(sourceType, sourceId)` - formats a StackState Kafka topic name using `sourceType` and `sourceId` parameters.

### The StackPack \(`stackPack`\) object

The provisioning script can interact with the StackPack being installed via the `stackPack()` function:

```text
context().stackPack()
```

The `stackPack()` function returns an object that provides the following functions:

* `importSnapshot(filename, parameters)` - imports a template from `filename` in the StackPack's namespace, filling in the optional `parameters` substitutions.

### The StackPack instance \(`instance`\) object

The provisioning script can interact with the StackPack instance being installed via the `instance()` function:

```text
context().instance()
```

The `instance()` function returns an object that provides the following functions:

* `id()` - returns the current StackPack instance id.
* `importSnapshot(filename, parameters)` - imports a template from `filename` in the StackPack's namespace, filling in the optional `parameters` substitutions.

### The environment \(`env`\) object

The provisioning script can interact with the StackState environment via the `env()` function:

```text
context().env()
```

The `env()` function returns an object that provides the following functions:

* `execute(commandLine, directory, environment)` - runs a shell script command `commandLine` in `directory` with `environment` setup.

## How to ensure consistency between the provisioning script and the template file

It is time to template out the variables exposed by your StackPack. It is possible to define some input fields that your StackPack requires to authenticate against some external sources and to differentiate between instances. To generalize the configuration, it is needed to inject the configuration file with some template parameters which are provided by the provisioning script. Any parameters or configuration item can be passed down to the `.stj` template file.

One common example is to create the topic name required by the data source for a given instance. To ensure data received from the StackState Agent Check ends up in your StackPack's data source, make sure that you create the same topic in the provisioning script. The following code snippet shows how to create a function called `topicName` that generates a topic name for this instance, based on the data provided by the user in the StackPack installation step.

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
    "identifier": "urn:stackpack:stackpack_name:data-source:stackpack_data_source",
    "config": {
      ...
      "topic": "{{ topicName }}"
    },
    ...
}
```

