# Splunk

---
stackpack-name: Splunk events, metrics and topology
---

# Splunk

## Overview



![Data flow](/.gitbook/assets/stackpack-splunk.png)


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

The Splunk Topology StackPack is open source and available on GitHub at [https://github.com/StackVista/stackpack-splunk](https://github.com/StackVista/stackpack-splunk).

The Splunk Events, Metrics and Topology checks are open source and available on GitHub at:

* Splunk Events: [https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_event](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_event)
* Splunk Metrics: [https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_metric](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_metric)
* Splunk Topology: [https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_topology](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_topology)

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
* [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog).