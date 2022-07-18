
# Page name from SUMMARY.md

## Overview

The ??? StackPack creates a synchronization between a ??? instance and StackState. When the integration is enabled, ???.

![Data flow](../../.gitbook/assets/stackpack-???.svg)

* ??? what
* ??? happens
* ??? in the diagram

## Setup

### Pre-requisites

To set up the ??? integration you will need to have:

* [StackState Agent V2](agent.md) installed on a machine that can connect to both ??? and StackState.
* A running ??? instance.
* ???

### Install

Install the ??? StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **???** - ???.
* **???** - ???.

### Configure

To enable the ??? check and begin collecting data from ???, add the following configuration to StackState Agent V2:

1.  Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/???/conf.yaml` to include details of your ??? instance:
   * **???** - ???.
   * **???** - ???.

     ```text
     ???
     ```
2. ???
3. [Restart the StackState Agent\(s\)](/setup/agent/about-stackstate-agent.md#deployment) to apply the configuration changes.
4. Once the Agent has restarted, wait for data to be collected from ??? and sent to StackState.

### Status

To check the status of the ??? integration, run the status subcommand and look for ??? under `Running Checks`:

```text
sudo stackstate-agent status
```

### Upgrade

When a new version of the ??? StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **???**. For an overview of recent StackPack updates, check the [StackPack versions](../../setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

For considerations and instructions on upgrading a StackPack, see [how to upgrade a StackPack](../about-stackpacks.md#upgrade-a-stackpack).

## Integration details

### REST API endpoints

### Data retrieved

#### Events

The ??? check does not retrieve any event data.

#### Metrics

The ??? check does not retrieve any metrics data.

#### Tags

All tags defined in Dynatrace will be retrieved and added to the associated components and relations in StackState. The Dynatrace integration also understands [common tags](../../configure/topology/tagging.md#common-tags) and applies these to topology in StackState.

#### Topology

The ??? check retrieves the following topology data from ???:

| Data | Description |
| :--- | :--- |
| Components | ???. |
| Relations | ???. |

#### Traces

The ??? check does not retrieve any traces data.

### ??? views in StackState

When the ??? integration is enabled, the following views are available in the StackState UI:

* ???
* ???


### Open source

The code for the ??? check is open source and available on GitHub at: [???](???)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=???).

## Uninstall

To uninstall the ??? StackPack and disable the Dynatrace check:

1. Go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **???** screen and click **UNINSTALL**.
   * All ??? specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv ???.d/conf.yaml ???.d/conf.yaml.bak
   ```

3. [Restart the StackState Agent\(s\)](/setup/agent/about-stackstate-agent.md#deployment) to apply the configuration changes.

## Release notes


## See also

* [StackState Agent V2](/setup/agent/about-stackstate-agent.md)

