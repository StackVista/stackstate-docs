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

For each type of data you want to retrieve from Splunk (topology, metrics and events), an associated check must be configured on StackState Agent V1. 

Details of how to configure each of these checks can be found on the pages listed below:

* [Splunk topology check configuration](/stackpacks/integrations/new_splunk/splunk_topology.md)
* [Splunk metrics check configuration](/stackpacks/integrations/new_splunk/splunk_metric.md)
* [Splunk events check configuration](/stackpacks/integrations/new_splunk/splunk_event.md)

### Authentication

The Splunk integration provides two authentication mechanisms to connect to your Splunk instance:


- [Token-based authentication \(recommended\)](#token-based-authentication)
- [HTTP basic authentication](#http-basic-authentication)

Authentication details are included in the StackState Agent V1 configuration file for each Splunk check - [conf.d/splunk\_events.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_event/conf.yaml.example), [conf.d/splunk\_metric.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example) and [conf.d/splunk\_topology.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example).

#### Token-based Authentication

Token-based authentication supports Splunk authentication tokens. An initial Splunk token is provided to the integration with a short expiration date. Before the configured token expires, a new token with an expiration of `token_expiration_days` days will be requested. 

Token-based authentication information will override basic authentication in case both are configured.

The following parameters are available:

* **name** - Name of the user who will be using this token.
* **initial_token** - An initial, valid token. This will be replaced with a new generated token requested by the integration.
* **audience** - JWT audience name, which is purpose of token.
* **token_expiration_days** - Validity of the newly requested token. Default 90 days.
* **renewal_days** - Number of days before a new token should be refreshed. Default 10 days.

        ## The provided initial token will be exchanged for a new token
        ## the first time the check runs
        ## When a token is about to expire, a new token will be requested 
        ## from Splunk with a validity of `token_expiration_days`, default 90 days.
        ## the number of days before when token should refresh, default 10 days.
        ## After the configured `renewal_days` days, the token will be renewed
        ## for another `token_expiration_days` days.

{% tabs %}
{% tab title="Example check configuration with token-based authentication" %}
```text
instances:
    - url: "https://localhost:8089"

    # username: "admin" ## deprecated
    # password: "admin" ## deprecated

    # verify_ssl_certificate: false

    authentication:
      token_auth:
        name: "api-user"
        initial_token: "my-initial-token-hash"
        audience: "search"
        token_expiration_days: 90
        renewal_days: 10
```
{% endtab %}
{% endtabs %}


#### HTTP basic authentication

With HTTP basic authentication, the `username` and `password` specified in the Agent V1 check configuration file is be used to connect to Splunk. These parameters are specified in `authentication.basic_auth`.

{% hint style="info" %}
It is recommended to use [token-based authentication](#token-based-authentication).
{% endhint %}

{% tabs %}
{% tab title="Example check configuration with HTTP basic authentication" %}
```text
instances:
    - url: "https://localhost:8089"

    # username: "admin" ## deprecated
    # password: "admin" ## deprecated

    # verify_ssl_certificate: false

    authentication:
      basic_auth:
        username: "admin"
        password: "admin"
```
{% endtab %}
{% endtabs %}



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
* [Splunk topology check configuration](/stackpacks/integrations/new_splunk/splunk_topology.md)
* [Splunk events check configuration](/stackpacks/integrations/new_splunk/splunk_event.md)
* [Splunk metrics check configuration](/stackpacks/integrations/new_splunk/splunk_metric.md)

Other resources:
* [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog)