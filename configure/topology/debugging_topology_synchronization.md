---
title: Debugging topology synchronization
kind: Documentation
aliases:
  - /configuring/debugging_topology_synchronization/
listorder: 10
---

# Debug topology synchronization

## Overview

When customizing a synchronization the result might not be as expected: this page explains several tools for debugging. For more info on individual synchronization concepts, see [synchronization concepts](topology_synchronization.md).

## General troubleshooting steps

Some common steps to verify issues are:

1. [Verify that the Topology Synchronization is listed and has created components and relations](debugging_topology_synchronization.md#list-all-topology-synchronization-streams).
2. [Ensure if the Topology Synchronization has errors](debugging_topology_synchronization.md#show-status-of-a-stream)
3. Check the logs

## Checking the synchronization logs

StackState stores logs about synchronization in the folllowing places

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

## Why are components/elements I expect not in my topology?

If no components appear after making changes in a synchronization, or the data is not as expected, a good starting point is the synchronization main screen:

`https://<my instance>/#/settings/synchronizations`

Based on the information you see here, different actions can be taken:

* If there are errors be sure to check the synchronization logs
* If there are no errors:
  * Make sure you 'restarted' your synchronization in the synchronization screen and sent

    in new data, this is because StackState does not retroactively apply changes

  * Make sure the components/relations you want synchronized has its type mapped in the synchronization configuration
  * Make sure data is ending up in StackState. The [StackState CLI](../../setup/installation/cli-install.md) contains a way to see

    what data ends up on the synchronization topic.

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
