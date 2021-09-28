# Debug topology synchronization

## Overview

This page explains several tools for debugging a custom topology synchronization. For more information on individual synchronization concepts, see [synchronization concepts](topology_synchronization.md).

## General troubleshooting steps

To verify issues follow these common steps:

1. [List all topology synchronization streams](debugging_topology_synchronization.md#list-all-topology-synchronization-streams). The topology synchronization should be included in the list and have created components and relations.
2. [Check the status of the topology synchronization stream](debugging_topology_synchronization.md#show-status-of-a-stream) for the error count. 
3. Check the logs

## Check the synchronization logs

StackState stores logs about synchronization in the following places

`<my_install_location>/var/log/sync/`

This directory contains two log files for each synchronization.

* One of the form

  `exttopo.<DataSource Name>.log`. This one contains information about identity extraction

  and the building of an external topology. This will show:

  * If a relation is connected to a non-existing component.
  * When the synchronization is slow it will discard messages
  * When the idextractor has errors

* Another of the form `sync.<Synchronization Name>.log`. This contains information about

  mapping, templates and merging. This will show:

  * Errors in template/mapping functions
  * Component types which have no mapping

## Common Issues

### Why are components/relations I expect not in my topology?

If no components appear after making changes to a synchronization, or the data is not as expected, check the synchronizations page in the StackState UI. Go to **Settings** > **Topology Synchronization** > **Synchronizations** from the main menu.

Based on the information you see here, different actions can be taken:

* If there are errors:
  * [Check the synchronization logs](#check-the-synchronization-logs) for details.
* If there are no errors, check the following:
  * Did you restart the synchronization and send new data after making changes? StackState will not retroactively apply changes.
  * Do the components/relations to be synchronized have their type mapped in the synchronization configuration?
  * Is the data arriving in StackState? The [StackState CLI](../../setup/installation/cli-install.md) contains a way to see what data ends up on the synchronization topic.

## Useful CLI commands

### List all Topology Synchronization streams

Returns a list of all current topology synchronization streams.

```javascript
# List streams
sts topology list

        Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
---------------  ---------------------------------------------------------------------------------------  --------  --------------------  --------------------  -------------------  -------------------  --------
245676427469735                                                                                           Running                      0                     0                    0                    0         0
154190823099122  urn:stackpack:stackstate-agent-v2:shared:sync:agent                                      Running                 761818                763870              1517959              1519490         0
144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329
```

### Show status of a stream 

Shows the data of a specific topology synchronization stream. The `id` might be either a `node id` or the identifier of a topology synchronization. The search gives priority to the `node id`.

```javascript
# Show a topology synchronization status
sts topology show urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate

        Node Id  Identifier                                                                               Status      Created Components    Deleted Components    Created Relations    Deleted Relations    Errors
---------------  ---------------------------------------------------------------------------------------  --------  --------------------  --------------------  -------------------  -------------------  --------
144667609743389  urn:stackpack:stackstate:instance:44a9ce1e-413c-4c4c-819d-2095c1229dda:sync:stackstate   Running                  13599                  5496                    0                    0       329
```
