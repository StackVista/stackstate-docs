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
  * The API Integration StackPack is required for all Splunk data.
  * Splunk topology data also requires the Splunk Topology StackPack to be installed.
* StackState translates incoming data:
  * [Topology data](#topology) from the Splunk saved searches configured in the Splunk topology Agent check is translated into components and relations.
  * [Metrics data](#metrics) from the Splunk saved search(es) configured in the Splunk metrics Agent check is available in StackState as a metrics telemetry stream.
  * [Events](#events) from the Splunk saved search(es) configured in the Splunk events Agent check is available in StackState as a log telemetry stream.

## Setup

### Prerequisites

* Agent V1 installed on a machine that can connect to both Splunk and StackState.
* A running Splunk instance.
* A Splunk user account with access to Splunk saved searches. The user should have the capability `search` to dispatch and read Splunk saved searches.

### Install

#### Splunk metrics and events

To retrieve data from Splunk, the [API Integration StackPack](/stackpacks/integrations/api-integration.md) must be installed in your StackState instance. This is required for StackState to communicate with Agent V1 and, once the required Splunk Agent checks have been configured, will directly make Splunk metrics and events available in StackState.

#### Splunk topology

To retrieve topology data from Splunk, in addition to the [API Integration StackPack](/stackpacks/integrations/api-integration.md), which is required to communicate with Agent V1, you will also need to install the **Splunk Topology StackPack**. 

Install the Splunk Topology StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Splunk instance name** - A unique name to identify the Splunk instance in StackState. 
* **Splunk API URL** - The URL where the Splunk API can be reached. For example: `http://splunk.network.local:8089`.

### Configure

StackState Agent V1 must be configured with a Splunk Agent check for each type of data you want to retrieve from Splunk (topology, metrics and events). 

Details of how to configure each of these checks can be found on the pages listed below:

* [Splunk topology check configuration](/stackpacks/integrations/splunk/splunk_topology.md)
* [Splunk metrics check configuration](/stackpacks/integrations/splunk/splunk_metrics.md)
* [Splunk events check configuration](/stackpacks/integrations/splunk/splunk_events.md)

### Authentication

Each Splunk Agent check must include authentication details to allow the Agent to connect to your Splunk instance and execute the configured Splunk saved searches. Authentication details are added to the [Agent check configuration file](#configure). 

Two authentication mechanisms are available:

- [Token-based authentication \(recommended\)](#token-based-authentication)
- [HTTP basic authentication](#http-basic-authentication)

#### Token-based Authentication

Token-based authentication supports Splunk authentication tokens. An initial Splunk token is provided to the integration with a short expiration date. Before the configured token expires, a new token with an expiration of `token_expiration_days` days will be requested. For details on using token based authentication with Splunk, see the [Splunk documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/Security/Setupauthenticationwithtokens).

Token-based authentication is preferred over HTTP basic authentication and will override basic authentication in case both are configured.

To enable token-based authentication, the following parameters should be configured in the `authentcation.token_auth` section of each Agent Splunk check configuration file:

* **name** - Name of the user who will be using this token.
* **initial_token** - An initial, valid token. This token will be used once only and then replaced with a new generated token requested by the integration.
* **audience** - The Splunk token audience.
* **token_expiration_days** - Validity of the newly requested token. Default 90 days.
* **renewal_days** - Number of days before a new token should be refreshed. Default 10 days.

The first time the check runs, the configured `initial_token` will be exchanged for a new token. After the configured `renewal_days` days, a new token will be requested from Splunk with a validity of `token_expiration_days`.

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

{% hint style="info" %}
It is recommended to use [token-based authentication](#token-based-authentication).
{% endhint %}

With HTTP basic authentication, the `username` and `password` specified in the Agent V1 check configuration files are used to connect to Splunk. These parameters are specified in `authentication.basic_auth`.

{% tabs %}
{% tab title="Example check configuration with HTTP basic authentication" %}
```text
instances:
    - url: "https://localhost:8089"

    # username: "admin" ## deprecated - do not use
    # password: "admin" ## deprecated - do not use

    # verify_ssl_certificate: false

    authentication:
      basic_auth:
        username: "admin"
        password: "admin"
```
{% endtab %}
{% endtabs %}

### Status

To check the status of the Splunk integration, run the status subcommand and look for Splunk under `Running Checks`:

```text
sudo stackstate-agent status
```

## Integration details

### Data retrieved

The Splunk integration can retrieve the following data:

* [Events](#events)
* [Metrics](#metrics)
* [Topology](#topology)

#### Events

When the Splunk events Agent check is configured, events will be retrieved from the configured Splunk saved search or searches. Events retrieved from splunk are available in StackState as a log telemetry stream, which can be [mapped to associated components](/use/health-state-and-event-notifications/add-telemetry-to-element.md).

For details of the events retrieved, see the [Splunk events check configuration](/stackpacks/integrations/splunk/splunk_events.md).

#### Metrics

When the Splunk metrics Agent check is configured, metrics will be retrieved from the configured Splunk saved search or searches. Metrics retrieved from splunk are available in StackState as a metrics telemetry stream, which can be [mapped to associated components](/use/health-state-and-event-notifications/add-telemetry-to-element.md).

For details of the metrics retrieved, see the [Splunk metrics check configuration](/stackpacks/integrations/splunk/splunk_metrics.md).

#### Topology

When the Splunk Topology StackPack is installed and the Splunk topology Agent check is configured, topology will be retrieved from the configured Splunk saved search or searches.

For details of the components and relations retrieved, see the [Splunk topology check configuration](/stackpacks/integrations/splunk/splunk_topology.md).

#### Traces

The StackState Splunk integration does not retrieve any trace data.

### REST API endpoints

StackState Agent V1 connects to the Splunk API at the endpoints listed below. The same endpoints are used to retrieve events, metrics and topology data.

| Endpoint | Description |
|:--- |:--- |
| `/services/auth/login?output_mode=json` | Auth login |
| `/services/authorization/tokens?output_mode=json` | Create token |
| `/services/saved/searches?output_mode=json&count=-1` | List of saved searches |
| `/servicesNS/<user>/<app>/saved/searches/<saved_search_name>/dispatch` | Dispatch the saved search |
| `/services/search/jobs/<saved_search_id>/control` | Finalize the saved search |

For further details, see the [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog).

### Open source

The Splunk Topology StackPack and the Agent checks for Splunk events, metrics and topology are open source and available on GitHub at the links below:

* [Splunk Topology StackPack \(github.com\)](https://github.com/StackVista/stackpack-splunk)
* [Splunk topology check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_topology)
* [Splunk metrics check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_metric)
* [Splunk events check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_event)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=Splunk).

## Uninstall

To uninstall the Splunk topology StackPack, go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **Splunk topology** screen and click UNINSTALL. All Splunk topology specific configuration will be removed from StackState.

For instructions on how to disable the Splunk Agent checks, see:

* [Disable the Splunk topology Agent check]()
* [Disable the Splunk metrics Agent check]()
* [Disable the Splunk events Agent check]()

## Release notes

The [Splunk Topology StackPack release notes](https://github.com/StackVista/stackpack-splunk/blob/master/RELEASE.md) are available on GitHub.

For the Splunk events and metrics synchronizations, see the [API Integration StackPack release notes](/stackpacks/integrations/api-integration.md#release-notes).

## Further information

Configure the StackState Agent V1 Splunk checks:
* [Splunk topology check configuration](/stackpacks/integrations/splunk/splunk_topology.md)
* [Splunk events check configuration](/stackpacks/integrations/splunk/splunk_events.md)
* [Splunk metrics check configuration](/stackpacks/integrations/splunk/splunk_metrics.md)

Other resources:
* [Set up Splunk authentication with tokens \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/Security/Setupauthenticationwithtokens).
* [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog)