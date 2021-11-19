---
description: Build topology out of Splunk data
---

# Splunk topology

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The StackState Agent can execute Splunk queries and convert the result to topology elements, which are then synchronized to StackState. The StackState Agent expects the `saved searches` to return the latest snapshot of the topology.

In order for the StackState Agent to be able to convert the results to topology elements, the output of the query has to be according to the format below. The format describes specific columns in the output that, when present, are used for the topology element. Other columns that are present in the output format, not defined in the query format, are available as key-value-pairs in StackState inside the `data` map. The column names are used as keys and the content as value. Splunk internal fields are filtered out by the StackState Agent\)

### Components Query Format

| **id** | string | The unique identifier for this component. |
| :--- | :--- | :--- |
| **type** | string | The type of the component. |
| **name** | string | The value will be used as component name. |
| **identifier.&lt;identifier name&gt;** | string | The value will be included as identifier of the component. |
| **label.&lt;label name&gt;** | string | The value will appear as label of the component. |

\* This format assumes you use the default Splunk mapping function and identity extractor in StackState. By customizing these you can create your own format.

Example Splunk query:

```text
| loadjob savedsearch=:servers
| search OrganizationPart="*" OrgGrp="*" company="*"
| table name | dedup name
| eval name = upper(name)
| eval id = 'name', type="vm"
| table id type name
```

### Relations Query Format

| **type** | string | The type of the relation. |
| :--- | :--- | :--- |
| **sourceId** | string | The id of the component that is the source of this relation. |
| **targetId** | string | The id of the component that is the target of this relation. |

Example Splunk query:

```text
index=cmdb_icarus source=cmdb_ci_rel earliest=-3d
| eval VMName=lower(VMName)
| rename Application as sourceId, VMName as targetId
| eval type="is-hosted-on"
| table sourceId targetId type
```

## Authentication

The Splunk integration provides various authentication mechanisms to connect to your Splunk instance.

### HTTP Basic Authentication

With HTTP basic authentication, the `username` and `password` specified in the `splunk_topology.yaml` can be used to connect to Splunk. These parameters are available in `basic_auth` parameter under the `authentication` section. Credentials under the root of the configuration file are deprecated and credentials provided in the new `basic_auth` section will override the root credentials.

_As an example, see the below config :_

```text
instances:
    - url: "https://localhost:8089"

    # username: "admin" ## deprecated; use basic_auth.username under authentication section
    # password: "admin" ## deprecated; use basic_auth.password under authentication section

    # verify_ssl_certificate: false

    ## Integration supports either basic authentication or token based authentication.
    ## Token based authentication is preferred before basic authentication.
    authentication:
      basic_auth:
        username: "admin"
        password: "admin"
```

### Token-based Authentication

Token-based authentication mechanism supports Splunk authentication tokens. An initial Splunk token is provided to the integration with a short expiration date. The integration's authentication mechanism will request a new token before expiration, respecting the `renewal_days` setting, with an expiration of `token_expiration_days` days.

Token-based authentication information overrides basic authentication in case both are configured.

The following new parameters are available:

* `name` - Name of the user who will be using this token.
* `initial_token` - First initial valid token which will be exchanged with new generated token in the integration.
* `audience` - JWT audience name which is purpose of token.
* `token_expiration_days` - Validity of the newly requested token after first initial token and by default it's 90 days.
* `renewal_days` - Number of days before when token should refresh, by default it's 10 days.

_As an example, see the below config :_

```text
instances:
    - url: "https://localhost:8089"

    # username: "admin" ## deprecated; use basic_auth.username under authentication section
    # password: "admin" ## deprecated; use basic_auth.password under authentication section

    # verify_ssl_certificate: false

    ## Integration supports either basic authentication or token based authentication.
    ## Token based authentication is preferred before basic authentication.
    authentication:
      # basic_auth:
        # username: "admin"
        # password: "admin"

      token_auth:
        ## Token for the user who will be using it
        name: "api-user"

        ## The initial valid token which will be exchanged with new generated token as soon as the check starts
        ## first time and in case of restart, this token will not be used anymore
        initial_token: "my-initial-token-hash"

        ## JWT audience used for purpose of token
        audience: "search"

        ## When a token is about to expire, a new token is requested from Splunk. The validity of the newly requested
        ## token is requested to be `token_expiration_days` days. After `renewal_days` days the token will be renewed
        ## for another `token_expiration_days` days.
        token_expiration_days: 90

        ## the number of days before when token should refresh, by default it's 10 days.
        renewal_days: 10
```

The above authentication configuration are part of the [conf.d/splunk\_topology.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_topology/conf.yaml.example) file.

## Configuration

There is an attribute `ignore_saved_search_errors` inside the `Splunk_topology.yaml` which is set to `true` by default. This flag makes the agent less strict and allows for saved searches which might be missing or fail when running. If this flag is set to `false` and one of the saved searches don't exist, it will produce an error.

1. Edit your `conf.d/Splunk_topology.yaml` file.
2. Restart the agent

