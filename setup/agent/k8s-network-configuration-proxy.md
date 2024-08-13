# Configuring Rancher Observability Kubernetes Agent to Proxy Connections

The Rancher Observability Kubernetes Agent allows you to configure HTTP or HTTPS proxy settings for the connections it initiates.

## Proxy for communication with Rancher Observability

To configure the agent to proxy connections to the Rancher Observability backend, you can use Helm configuration.

### Helm Configuration

#### Via `values.yaml` File

1. Open your Helm chart `values.yaml` file.

2. Locate the `global.proxy.url` configuration and specify the proxy URL:

    ```yaml
    global:
      proxy:
        url: "https://proxy.example.com:8080"
    ```

3. Optionally, if the proxy does not have a signed certificate, disable SSL verification by setting `global.skipSslValidation` to `true`:

    ```yaml
    global:
      skipSslValidation: true
    ```

#### Via Command Line Flag

1. During installation of the Helm chart, use the `--set` flag to specify the proxy URL:

    ```bash
    helm install stackstate-k8s-agent stackstate/stackstate-k8s-agent --set global.proxy.url="https://proxy.example.com:8080"
    ```

2. To disable SSL validation via the command line, use:

    ```bash
    helm install stackstate-k8s-agent stackstate/stackstate-k8s-agent --set global.skipSslValidation=true
    ```