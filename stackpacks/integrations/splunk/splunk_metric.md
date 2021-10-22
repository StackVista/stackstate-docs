---
description: Retrieve metrics from Splunk
---

# Splunk metrics

{% hint style="warning" %}
**This page describes StackState version 4.2.**

The StackState 4.2 version range is End of Life (EOL) and no longer supported. We encourage customers still running the 4.2 version range to upgrade to a more recent release.

Go to the [documentation for the latest StackState release](https://docs.stackstate.com/).
{% endhint %}

## Overview

The StackState Agent can be configured to execute Splunk saved searches and provide the results as metrics to the StackState receiver API. It will dispatch the saved searches periodically, specifying last metric timestamp to start with up until now.

The StackState Agent expects the results of the saved searches to contain certain fields, as described below in the Metric Query Format. If there are other fields present in the result, they will be mapped to tags, where the column name is the key, and the content the value. The Agent will filter out Splunk default fields \(except `_time`\), like e.g. `_raw`, see the [Splunk documentation](https://docs.splunk.com/Documentation/Splunk/6.5.2/Data/Aboutdefaultfields) for more information about default fields.

The agent check prevents sending duplicate metrics over multiple check runs. The received saved search records have to be uniquely identified for comparison. By default, a record's identity is composed of Splunk's default fields `_bkt` and `_cd`. The default behavior can be changed for each saved search by setting the `unique_key_fields` in the check's configuration. Please note that the specified `unique_key_fields` fields become mandatory for each record. In case the records cannot be uniquely identified by a combination of fields, then the whole record can be used by setting `unique_key_fields` to `[]`, i.e. empty list.

### Required fields

All fields described below are required in a Splunk query:

| Field | Type | Description |
| :--- | :--- | :--- |
| **\_time** | long | Data collection timestamp, millis since epoch. |
| **metric%** | string | Name of the metric. This is the `metric_name_field` configured in [conf.d/splunk\_metric.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example). |
| **value%** | numeric | The value of the metric. |

Example Splunk query:

```text
index=vms MetricId=cpu.usage.average
| table _time VMName Value    
| eval VMName = upper(VMName)
| rename VMName as metricCpuUsageAverage, Value as valueCpuUsageAverage
| eval type = "CpuUsageAverage"
```

## Authentication

The Splunk integration provides various authentication mechanisms to connect to your Splunk instance.

### HTTP Basic Authentication

With HTTP basic authentication, the `username` and `password` specified in the `splunk_metric.yaml` can be used to connect to Splunk. These parameters are available in `basic_auth` parameter under the `authentication` section. Credentials under the root of the configuration file are deprecated and credentials provided in the new `basic_auth` section will override the root credentials.

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
* `initial_token` - First initial valid token which will be exchanged with new generated token in the integration..
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

The above authentication configuration are part of the [conf.d/splunk\_metric.yaml](https://github.com/StackVista/sts-agent-integrations-core/blob/master/splunk_metric/conf.yaml.example) file.

## Configuration

1. Edit your `conf.d/splunk_metric.yaml` file.
2. Restart the agent

