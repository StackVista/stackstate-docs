---
description: StackState core integration | StackState curated integration | Community integration ???
stackpack-name:  ???
---

# Same as title in SUMMARY.md

## Overview

This is an empty template for a StackPack docs page. Make sure to have removed all ??? lines/text. For the "data retrieved" section, give as much detail as possible. Current drawio files for stackpack diagrams can be found in the docs github repo at https://github.com/StackVista/stackstate-docs/tree/master/resources/drawio.


![Data flow](../../.gitbook/assets/stackpack-???.png)

* What???
* Happens in the???
* Data flow diagram???

## Setup

### Prerequisites

To set up the StackState ??? integration, you need to have:

* [StackState Agent V2](agent.md) installed on a machine that can connect to both ServiceNow \(via HTTPS\) and StackState.
* A running ??? instance.
* ???

### Install

Install the ??? StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* ???
* ???

### Configure

To enable the ??? check and begin collecting data from ???, add the following configuration to StackState Agent V2:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/???.d/conf.yaml` to include details of your ??? instance:
   * ???
   * ???

     ```text
      config file with mandatory configuration???
     ```
2. You can also add optional configuration and filters:
   * ???
   * ???
3. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.
4. Once the Agent has restarted, wait for the Agent to collect data from ??? and send it to StackState.

#### Any addition configuration (optional)

### Status

To check the status of the ??? integration, run the status subcommand and look for ??? under `Running Checks`:

```text
sudo stackstate-agent status
```

### Upgrade

When a new version of the ??? StackPack is available in your instance of StackState, you will be prompted to upgrade in the StackState UI on the page **StackPacks** &gt; **Integrations** &gt; **???**. For an overview of recent StackPack updates, check the [StackPack versions](../../setup/upgrade-stackstate/stackpack-versions.md) shipped with each StackState release.

For considerations and instructions on upgrading a StackPack, see [how to upgrade a StackPack](../about-stackpacks.md#upgrade-a-stackpack).

## Integration details

### Data retrieved

#### Events

The ??? check retrieves the following events data from ServiceNow:

| Data | Description |
| :--- | :--- |
| ??? |  |

#### Metrics

The ??? check does not retrieve any metrics data.

#### Tags

All tags defined in ??? will be retrieved and added to the associated components and relations in StackState. The ??? integration also understands [common tags](../../configure/topology/tagging.md#common-tags) and applies these to topology in StackState.

#### Topology

The ??? check retrieves the following topology data:

| Data | Description |
| :--- | :--- |
| Components |  |
| Relations |  |

#### Traces

The ??? check does not retrieve any traces data.

### REST API endpoints


### ??? views in StackState

When the ??? integration is enabled, the following ??? specific views are available in StackState:

* ???
* ???

### Open source

The code for the StackState ??? check is open source and available on GitHub at: [???](???)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=???).

## Uninstall

To uninstall the ??? StackPack and disable the ??? check:

1. Go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **???** screen and click UNINSTALL.
   * All ??? specific configuration will be removed from StackState.
2. Remove or rename the Agent integration configuration file, for example:

   ```text
    mv ???.d/conf.yaml ???.d/conf.yaml.bak
   ```

3. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to apply the configuration changes.

## Release notes



## See also

* [StackState Agent V2](agent.md) 
* [Secrets management](../../configure/security/secrets_management.md)
* ???

