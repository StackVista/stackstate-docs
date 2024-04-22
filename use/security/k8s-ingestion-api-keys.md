---
description: StackState Kubernetes Troubleshooting
---

# Ingestion API Keys

## Overview

Ingestion API Keys are used by external tools to ingest data (like metrics, events, traces and so on) to the StackState cluster. 
These tools can be STS Agent or/and OTel Collector.

## Manage Ingestion API Keys

Keys can be managed via the `sts` CLI. The following commands are available:

```sh
> sts ingestion-api-key --help
Manage API Keys used by ingestion pipelines, means data (spans, metrics, logs an so on) send by STS Agent, OTel and so on.

Usage:
  sts ingestion-api-key [command]

Available Commands:
  create      Create a new Ingestion Api Key
  delete      Delete an Ingestion Api Key
  list        List Ingestion Api Keys

Use "sts ingestion-api-key [command] --help" for more information about a command.
```

### Create Ingestion API Keys

To create a Key in your instance of StackState, you can use the `sts` CLI.

```sh
> sts ingestion-api-key create --name {NAME}
```

{% hint style="info" %}
Note that the Key will only be displayed once. It isn't possible to see the token again.
{% endhint %}

This command takes the following command line arguments:

| Flag            | Description                                                                           |
|:----------------|:--------------------------------------------------------------------------------------|
| `--name`        | The name of the Key.                                                                  |
| `--description` | Optional description of the API Key.                                                  |
| `--expiration`  | The expiration date of the Key, the format is yyyy-MM-dd. The expiration is optional. |

For example, the command below will create a Key with the name `my-ingestion-api-key`:

```sh
> sts ingestion-api-key create --name my-ingestion-api-key
✅ Ingestion API Key generated: iapikeyok-aaaaa-bbbb-ccccc-ddddd
```

### List Ingestion API Keys

The ID, name, expiration date and description of all created Ingestion API Keys can be seen using the `sts` CLI. For example:

```bash
> sts ingestion-api-key list                              
ID              | NAME                 | EXPIRATION | DESCRIPTION                                                                                                                                                                             
250558013078953 | my-ingestion-api-key |            | - 
```

### Delete Ingestion API Keys

An Ingestion API Key can be deleted using the `sts` CLI. Pass the ID of the Key as an argument. For example:

```sh
> sts ingestion-api-key delete  --id 250558013078953
✅ Ingestion Api Key deleted: 250558013078953
```

## Authenticating using service tokens

Once created, an Ingestion API Key can be used to authenticate:
- stackstate-k8s-agent
- OTel Collector


### stackstate-k8s-agent

The StackState agent requires an API key for communication, historically known as the Receiver API Key. StackState now offers two options for authentication:
- Receiver API Key: This key is typically generated during the initial installation of your StackState instance,
- Ingestion API Key: You can create Ingestion API Keys using the StackState CLI (STS). These keys offer expiration dates, requiring periodic rotation for continued functionality.

### OTel Collector

When using the StackState collector, you'll need to include an `Authorization` header in your configuration. The collector accepts either a Receiver API Key or an Ingestion API Key for authentication. 
The following code snippet provides an example configuration:
```yaml
  extensions:
    bearertokenauth:
      scheme: StackState
      token: "${env:API_KEY}"
  
  ...
  
  exporters:
    otlp/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: <otlp-stackstate-endpoint>:443
```