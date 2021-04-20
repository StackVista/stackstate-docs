---
stackpack-name: Splunk events, metrics and topology
---

# Splunk

## Overview

The StackState Splunk integration synchronizes events, metrics and topology data from Splunk to StackState. The integration uses the [API Integration StackPack](/stackpacks/integrations/api-integration.md) for events and metrics data, and the Splunk Topology StackPack for topology data.

![Data flow](/.gitbook/assets/stackpack-splunk.svg)

* StackState Agent V1 periodically connects to the configured Splunk instance to execute Splunk saved searches:
  * If the Splunk Topology StackPack is installed, topology data is retrieved using the Splunk saved search configured in the Splunk topology Agent check.
  * Metrics data is retrieved using the Splunk saved search configured in the Splunk metrics Agent check.
  * Events data is retrieved using the Splunk saved search configured in the Splunk events Agent check.
* StackState Agent V1 pushes retrieved data and events to StackState:
  * Topology data requires the Splunk Topology StackPack.
  * Metrics data and events require the API Integration StackPack.
* StackState translates incoming data:
  * [Topology data](#topology) is translated into components and relations.
  * [Metrics data](#metrics) is ???.
  * [Events](#events) are



## Setup

### Prerequisites


### Install


### Configure


### Status



## Integration details

### Data retrieved

#### Events



#### Metrics



#### Topology


#### Traces

The StackState Splunk integration does not retrieve any trace data.

### REST API endpoints

StackState Agent v1 connects to the Splunk API at the endpoints listed below. The same endpoints are used to retrieve events, metrics and topology data.

| Endpoint | Description |
|:--- |:--- |
| `/services/auth/login?output_mode=json` | Auth login |
| `/services/authorization/tokens?output_mode=json` | Create token |
| `/services/saved/searches?output_mode=json&count=-1` | List of saved searches |
| `/servicesNS/<user>/<app>/saved/searches/<saved_search_name>/dispatch` | Dispatch the saved search |
| `/services/search/jobs/<saved_search_id>/control` | Finalize the saved search |

For further details, see the [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog).

### Open source

The Splunk Topology StackPack and he Agent checks for Splunk events, metrics and topology are open source and available on GitHub at the links below:

* [Splunk Topology StackPack \(github.com\)](https://github.com/StackVista/stackpack-splunk)
* [Splunk events check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_event)
* [Splunk metrics check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_metric)
* [Splunk topology check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_topology)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=Splunk).

## Uninstall


## Release notes

The [Splunk Topology StackPack release notes](https://github.com/StackVista/stackpack-splunk/blob/master/RELEASE.md) are available on GitHub.

For the Splunk events and metrics synchronizations, see the [API Integration StackPack release notes](/stackpacks/integrations/api-integration.md#release-notes).

## Further information

Configure the StackState Splunk checks:
* [The Splunk Topology check](/stackpacks/integrations/new_splunk/splunk_topology.md)
* [The Splunk events check](/stackpacks/integrations/new_splunk/splunk_event.md)
* [The Splunk metrics check](/stackpacks/integrations/new_splunk/splunk_metric.md)

Other resources:
* [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog)