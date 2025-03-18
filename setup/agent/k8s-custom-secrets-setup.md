## Custom Secret Management


### Overview

The SUSE Observability Agent supports specifying the name of a custom secret that contains the API key and cluster authorization token. This feature is useful for users who wish to manage their own secrets and avoid the automatic creation of secrets by the Helm chart.

{% hint style="info" %}
**There was a previous method of specifying this that is now deprecated, see the [deprecated method](./k8s-custom-secrets-setup-deprecated.md) .**
{% endhint %}

### Regarding the Helm Chart

#### Configuration Options

- `global.apiKey.fromSecret`: Specify a pre-existing secret name residing in the same namespace which contains an `STS_API_KEY` field containing the api key.
- `global.clusterAgentAuthToken.fromSecret`: Specify a pre-existing secret name residing in the same namespace which contains an `STS_CLUSTER_AGENT_AUTH_TOKEN` field containing a token for securing connections between the cluster and node agents.

#### Behavior Description

- **Automatic Secret Creation**: By default, the chart requires an `stackstate.apiKey` to be specified and will create a secret by itself. The `STS_CLUSTER_AGENT_AUTH_TOKEN` is generated automatically.
- **Custom Secret Management**: When overriding the `fromSecret` fields, the api key and cluster auth token will be taken from those secrets. 
- **Implied Omission**: When specifying that you would like to manage your own secrets, the chart will ignore values for `stackstate.apiKey` and `stackstate.cluster.authToken`.

### How to Use in values.yaml

1. **Using Automatic Secret Creation (Default)**:
    ```yaml
    stackstate:
      apiKey: "<your api key>"
    ```

2. **Managing Own Secrets**:
    ```yaml
    global:
      apiKey:
        fromSecret: "name-of-my-api-key-secret"
      clusterAgentAuthToken:
        fromSecret: "name-of-my-cluster-agent-auth-token-secret"
    ```