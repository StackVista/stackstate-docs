## Custom Secret Management

### Overview

The stackstate/stackstate-k8s-agent (starting from version 1.0.79) supports specifying the name of a custom secret that contains the API key and cluster authorization token. This feature is useful for users who wish to manage their own secrets and avoid the automatic creation of secrets by the Helm chart. 

### Regarding the Helm Chart

#### Configuration Options

- `stackstate.manageOwnSecrets`: A boolean flag that determines whether the user wishes to manage their own secrets. Default value is `false`.
- `stackstate.customSecretName`: (Optional) Name of the custom secret to be created by the user. Required if `stackstate.manageOwnSecrets` is set to `true`.
- `stackstate.customApiKeySecretKey`: (Optional) Key name for the API key within the custom secret. Required if `stackstate.manageOwnSecrets` is set to `true`.
- `stackstate.customClusterAuthTokenSecretKey`: (Optional) Key name for the cluster authorization token within the custom secret. Required if `stackstate.manageOwnSecrets` is set to `true`.

#### Behavior Description

- **Automatic Secret Creation**: By default, the chart continues to automatically create secrets as before if `stackstate.manageOwnSecrets` is set to `false`.
- **Custom Secret Management**: If `stackstate.manageOwnSecrets` is set to `true`, the chart expects the user to provide the name of the custom secret (`stackstate.customSecretName`) along with the keys for the API key and authorization token (`stackstate.customApiKeySecretKey` and `stackstate.customClusterAuthTokenSecretKey`, respectively).
- **Implied Omission**: When specifying that you would like to manage your own secrets, the chart will ignore values for `stackstate.apiKey` and `stackstate.cluster.authToken`.
### How to Use in values.yaml

1. **Using Automatic Secret Creation (Default)**:
    ```yaml
    stackstate:
      manageOwnSecrets: false
      apiKey: "<your api key>"
    ```

2. **Managing Own Secrets**:
    ```yaml
    stackstate:
      manageOwnSecrets: true
      customSecretName: my-custom-secret
      customApiKeySecretKey: api-key
      customClusterAuthTokenSecretKey: auth-token
    ```