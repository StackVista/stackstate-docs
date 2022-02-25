---
description: StackState Self-hosted v4.5.x
---

# Splunk

{% hint style="warning" %}
**This page describes StackState version 4.5.**

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/stackpacks/integrations/splunk/splunk_stackpack).
{% endhint %}

## Overview

The StackState Splunk integration synchronizes events, metrics, health and topology data from Splunk to StackState. The integration uses StackState Agent V1 and StackState Agent V2:

* [StackState Agent V1](../../../setup/agent/agent-v1.md) is used to collect Splunk events and metrics data. It can also be used to collect topology data when the Splunk topology V1 integration is configured.
* [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) is used to collect health data. It can also be used to collect topology data when the Splunk topology V2 integration is configured.

Splunk is a [StackState core integration](/stackpacks/integrations/about_integrations.md#stackstate-core-integrations "StackState Self-Hosted only").

![Data flow](../../../.gitbook/assets/stackpack-splunk.svg)

* StackState Agent V1 periodically connects to the configured Splunk instance to execute Splunk saved searches and retrieve data:
  * Topology data from the searches configured in the Splunk topology V1 Agent check.
  * Metrics data from the searches configured in the Splunk metrics Agent check.
  * Events data from the searches configured in the Splunk events Agent check.
* StackState Agent V2 periodically connects to the configured Splunk instance to execute Splunk saved searches and retrieve data:
  * Topology data from the searches configured in the Splunk topology V2 Agent check.
  * Health data from the searches configured in the Splunk health Agent check.
* The Agents push retrieved data to StackState.
* StackState translates incoming data:
  * [Topology data](splunk_stackpack.md#topology) is translated into components and relations.
  * [Metrics data](splunk_stackpack.md#metrics) is available in StackState as a metrics telemetry stream.
  * [Events](splunk_stackpack.md#events) is available in StackState as a log telemetry stream.
  * [Health](splunk_stackpack.md#health) information is added to associated components and relations.

## Setup

### Prerequisites

* A running Splunk instance.
* A Splunk user account with access to Splunk saved searches. The user should have the capability `search` to dispatch and read Splunk saved searches.
* A compatible StackState Agent installed on a machine that can connect to both Splunk and StackState:
  * Metrics and events data: [StackState Agent V1](../../../setup/agent/agent-v1.md)
  * Health data: [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md)
  * Topology data: [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) or [StackState Agent V1](../../../setup/agent/agent-v1.md)

### Install

#### Splunk metrics and events

To retrieve metrics and events data from Splunk, [StackState Agent V1](../../../setup/agent/agent-v1.md) must be installed. Once the required Splunk Agent checks have been configured, Splunk metrics and events will directly be available in StackState.

#### Splunk health

To retrieve health data from Splunk, [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) must be installed. Once the Splunk health Agent check has been configured, Splunk health data will directly be available in StackState.

#### Splunk topology

To retrieve topology data from Splunk, [StackState Agent V2](../../../setup/agent/about-stackstate-agent.md) or [StackState Agent V1](../../../setup/agent/agent-v1.md) must be installed.

The Splunk StackPack provides all the necessary configuration to easily work with Splunk topology data in StackState. Install the Splunk StackPack from the StackState UI **StackPacks** &gt; **Integrations** screen. You will need to provide the following parameters:

* **Splunk instance name** - A unique name to identify the Splunk instance in StackState. 
* **Splunk API URL** - The URL where the Splunk API can be reached. For example: `http://splunk.network.local:8089`.

### Configure

StackState Agent V2 and/or StackState Agent V1 must be configured with a Splunk Agent check for each type of data you want to retrieve from Splunk \(topology, metrics and/or events\).

Details of how to configure each of these checks can be found on the pages listed below:

* [Splunk topology V2 check with StackState Agent V2](splunk_topology_v2.md)
* [Splunk topology V1 check with StackState Agent V1](splunk_topology.md)
* [Splunk metrics check configuration](splunk_metrics.md)
* [Splunk events check configuration](splunk_events.md)
* [Splunk health check configuration](splunk_health.md)

### Authentication

Each Splunk check configured on StackState Agent V1 must include authentication details to allow the Agent to connect to your Splunk instance and execute the configured Splunk saved searches.

Two authentication mechanisms are available:

* [Token-based authentication \(recommended\)](splunk_stackpack.md#token-based-authentication)
* [HTTP basic authentication](splunk_stackpack.md#http-basic-authentication)

#### Token-based Authentication

Token-based authentication supports Splunk authentication tokens. An initial Splunk token is provided in the Splunk check configuration. This initial token is used the first time the check starts, it is then exchanged for a new token. For details on using token based authentication with Splunk, see the [Splunk documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/Security/Setupauthenticationwithtokens).

Token-based authentication is preferred over HTTP basic authentication and will override basic authentication in case both are configured.

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

To enable token-based authentication, the following parameters should be included in the section `authentcation.token_auth` of each StackState Agent V1 Splunk check configuration file:

* **name** - Name of the user who will use this token.
* **initial\_token** - An initial, valid token. This token will be used once only and then replaced with a new generated token requested by the integration.
* **audience** - The Splunk token audience.
* **token\_expiration\_days** - Validity of the newly requested token. Default 90 days.
* **renewal\_days** - Number of days before a new token should be refreshed. Default 10 days.

The first time the check runs, the configured `initial_token` will be exchanged for a new token. After the configured `renewal_days` days, another new token will be requested from Splunk with a validity of `token_expiration_days`.

#### HTTP basic authentication

{% hint style="info" %}
It is recommended to use [token-based authentication](splunk_stackpack.md#token-based-authentication).
{% endhint %}

With HTTP basic authentication, the `username` and `password` specified in the StackState Agent V1 check configuration files are used to connect to Splunk. These parameters are specified in the section `authentication.basic_auth` of each StackState Agent V1 Splunk check configuration file.

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

To check the status of the Splunk integration, run the status subcommand and look for `splunk_topology`, `splunk_metrics` and/or `splunk_events` under `Running Checks`:

```text
sudo stackstate-agent status
```

## Integration details

### Data retrieved

The Splunk integration can retrieve the following data:

* [Events](splunk_stackpack.md#events)
* [Metrics](splunk_stackpack.md#metrics)
* [Topology](splunk_stackpack.md#topology)
* [Health](splunk_stackpack.md#health)

#### Events

When the Splunk events Agent check is configured, events will be retrieved from the configured Splunk saved search or searches. Events retrieved from splunk are available in StackState as a log telemetry stream in the `stackstate-generic-events` data source. This can be [mapped to associated components](../../../use/metrics-and-events/add-telemetry-to-element.md).

For details on how to configure the events retrieved, see the [Splunk events check configuration](splunk_events.md).

#### Metrics

When the Splunk metrics Agent check is configured, metrics will be retrieved from the configured Splunk saved search or searches. One metric can be retrieved from each saved search. Metrics retrieved from splunk are available in StackState as a metrics telemetry stream in the `stackstate-metrics` data source. This can be [mapped to associated components](../../../use/metrics-and-events/add-telemetry-to-element.md).

For details on how to configure the metrics retrieved, see the [Splunk metrics check configuration](splunk_metrics.md).

#### Topology

When the Splunk StackPack is installed, and a Splunk topology Agent check is configured, topology will be retrieved from the configured Splunk saved searches. The check that you should configure depends on the StackState Agent that you will use to retrieve topology data. The Splunk topology V1 check uses StackState Agent V1 to retrieve data from Splunk, while the Splunk topology V2 check uses StackState Agent V2.

For details on how to configure the components and relations retrieved, see:

* [Splunk topology V1 check configuration](splunk_topology.md) \(StackState Agent V1\).
* [Splunk topology V2 check configuration](splunk_topology_v2.md) \(StackState Agent V2\).

If you have an existing Splunk topology integration configured to use StackState Agent V1 and would like to upgrade to use StackState Agent V2, refer to the [Splunk topology check upgrade instructions](splunk_topology_upgrade_v1_to_v2.md).

#### Health

When the Splunk health Agent check is configured, health check states will be retrieved from the configured Splunk saved searches. Retrieved health check states are mapped to the associated components and relations in StackState.

For details on how to configure the health retrieved, see the [Splunk health check configuration](splunk_health.md).

#### Traces

The StackState Splunk integration does not retrieve any trace data.

### REST API endpoints

StackState Agent V1 connects to the Splunk API at the endpoints listed below. The same endpoints are used to retrieve events, metrics and topology data.

| Endpoint | Description |
| :--- | :--- |
| `/services/auth/login?output_mode=json` | Auth login |
| `/services/authorization/tokens?output_mode=json` | Create token |
| `/services/saved/searches?output_mode=json&count=-1` | List of saved searches |
| `/servicesNS/<user>/<app>/saved/searches/<saved_search_name>/dispatch` | Dispatch the saved search |
| `/services/search/jobs/<saved_search_id>/control` | Finalize the saved search |

For further details, see the [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog).

### Open source

The Splunk StackPack and the Agent checks for Splunk events, metrics and topology are open source and available on GitHub at the links below:

* [Splunk StackPack \(github.com\)](https://github.com/StackVista/stackpack-splunk)
* [Splunk topology V1 check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_topology)
* [Splunk topology V2 check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/splunk_topology)
* [Splunk metrics check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_metric)
* [Splunk events check \(github.com\)](https://github.com/StackVista/sts-agent-integrations-core/tree/master/splunk_event)
* [Splunk health check \(github.com\)](https://github.com/StackVista/stackstate-agent-integrations/tree/master/splunk_health)

## Troubleshooting

Troubleshooting steps for any known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/search?category=360002777619&filter_by=knowledge_base&query=Splunk).

## Uninstall

To uninstall the Splunk StackPack, go to the StackState UI **StackPacks** &gt; **Integrations** &gt; **Splunk** screen and click **UNINSTALL**. All Splunk topology specific configuration will be removed from StackState.

For instructions on how to disable the Splunk Agent checks, see:

* [Disable the Splunk topology V2 Agent check](splunk_topology_v2.md#disable-the-agent-check)
* [Disable the Splunk topology V1 Agent check](splunk_topology.md#disable-the-agent-check)
* [Disable the Splunk metrics Agent check](splunk_metrics.md#disable-the-agent-check)
* [Disable the Splunk events Agent check](splunk_events.md#disable-the-agent-check)
* [Disable the Splunk health Agent check](splunk_health.md#disable-the-agent-check)

## Release notes

The [Splunk StackPack release notes](https://github.com/StackVista/stackpack-splunk/blob/master/src/main/stackpack/resources/RELEASE.md) are available on GitHub.

## See also

Configure the StackState Agent Splunk checks:

* [Splunk topology V2 check configuration - StackState Agent V2](splunk_topology_v2.md)
* [Splunk topology V1 check configuration - StackState Agent V1](splunk_topology.md)
* [Splunk events check configuration - StackState Agent V1](splunk_events.md)
* [Splunk metrics check configuration - StackState Agent V1](splunk_metrics.md)
* [Splunk health check configuration - StackState Agent V2](splunk_health.md)

Other resources:

* [Set up Splunk authentication with tokens \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/Security/Setupauthenticationwithtokens).
* [Splunk API documentation \(docs.splunk.com\)](https://docs.splunk.com/Documentation/Splunk/8.1.3/RESTREF/RESTprolog)

