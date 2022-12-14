---
description: StackState Self-hosted v5.1.x 
---

# Packaging

## What is a StackPack package?

StackPacks are essentially `.zip` archives that contain a file structure allowing for StackPack presentation in StackState, installation, provisioning and configuration of StackState. The `.zip` extension must be changed to `.sts` to make the archive visible as a StackPack in StackState. A StackPack archive has the following structure:

```text
<your-stackpack>
    ├── provisioning
    │   ├── icons
    │   |   └── icon.png
    │   ├── scripts
    │   │     └── ExampleProvision.groovy
    │   └── templates
    │       ├── instance template.json.handlebar
    │       └── application template.json.handlebar
    ├── resources
    │   ├── logo.png
    │   └── overview.md
    └── stackpack.conf
```

## What is inside the StackPack package?

Inside the `.sts` archive you can find the provisioning directory, resources directory and a configuration file. Provisioning directory is prepared for provision groovy scripts, and Templates.

* `provisioning` directory is where all icons, templates, and `groovy` scripts used for provisioning the StackPack are stored. The provisioning can also be split into multiple groovy scripts, and the `provisioning` directory is part of the `classpath` while provisioning the StackPack. Find more on [Groovy in StackState](../../reference/scripting/).
* `resources` directory has all the static resources and contents for the StackPack. They're available in the Groove code through `/stackpack/{stackpack-name}/resources/{resource}`.
* `stackpack.conf` is where the StackPack is configured. See the section below for more details.
* `Templates` - these files are StackState Templated JSON handlebar files that reflect StackState configuration; it may contain `ComponentTypes`, `Id Extractors` and component/relations templates. Find more details on the [templates page](how_to_get_a_template_file.md)  

## The StackPack configuration file

A StackPack should have a [HOCON](https://github.com/lightbend/config/blob/master/HOCON.md) configuration file named `stackpack.conf` in the root directory. The structure of the file should look like this:

```text
name = example
displayName = Example stackpack
version = "1.0.0"
isNew = yes
logoUrl = "http://url.to.the.logo"
categories = ["Infrastructure"]
overviewUrl = "overview.md"
detailedOverviewUrl = "detailed-overview.md"
configurationUrls = {
    INSTALLED = "installed.md"
    NOT_INSTALLED = "notinstalled.md"
    ERROR = "error.md"
    PROVISIONING = "provisioning.md"
    DEPROVISIONING = "deprovisioning.md"
    WAITING_FOR_DATA = "waitingfordata.md"
}
faqs = []
steps = [
  {
    name = "text"
    display = "Text"
    value {
      type = "text"
      default = "value"
    }
  },
  {
    name = "password"
    display = "Password"
    value {
      type = "password"
    }
  }
]
provision = "ExampleProvision"
releaseNotes = "releaseNotes.md"
upgradeInstructions = "upgrading.md"
```

* `name` - Name of the StackPack. This is what is used to uniquely identify the StackPack. \(Required\)
* `displayName` - Name that's displayed on both the StackPack listing page and on the title of the StackPack page. \(Required\)
* `version` - [Semantic version](https://semver.org/) of the StackPack. StackPacks with the same major version are considered compatible. \(Required\)
* `isNew` - This specifies whether the StackPack is new, as in the StackPack version is the first publicly available version. The values can be `yes`/`no`/`true`/`false`. By default, it's considered `false`.
* `logoUrl` - Specifies the logo used as a badge for the StackPack. It could be any of the resource URL as defined [here](how_to_customize_a_stackpack.md). \(Required\)
* `categories` - These are keywords using which the StackPacks can be filtered. Any list of relevant labels can be passed here. It's recommended to keep labels in capitalized letters.
* `overviewUrl`- Markdown resource with general information about the StackPack. By default, it's assumed to be `/overview.md`.
* `detailedOverviewUrl` - Optional Markdown resource that described the StackPack in a bit more detailed fashion. This is displayed in two columns below the installed instances section in the StackPack page. Markdown comment,  `[comment]: # (split)` is used to delimit the two columns in the markdown.
* `configurationUrls` - Contains the Markdown resources relevant for various states of StackPack provisioning.
* `faqs` - Frequently asked questions concerning the StackPack or its installation. A list with each element having the format:

  ```text
  {
    question = "question"
    answer = "answer"
  }
  ```

* `steps` - Describes the configuration fields. See [Configuration input](stackpack_resources.md).
* `provision` - Defines the provisioning script. For example, if the script is `ExampleProvision` then, `provisioning/ExampleProvision.groovy` is looked up to see if there is a groovy class named `ExampleProvision` which extends `com.stackstate.stackpack.ProvisioningScript` from `stackpack-sdk`.
* `releaseNotes` - Markdown file containing release notes for the current StackPack release. Shown when installing the StackPack.
* `upgradeInstructions` - Markdown file containing upgrade instructions for the current StackPack release. Shown when upgrading the StackPack.

