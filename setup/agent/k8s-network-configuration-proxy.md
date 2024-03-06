# Configuring StackState Kubernetes Agent to Proxy Connections

The StackState Kubernetes Agent allows you to configure HTTP or HTTPS proxy settings for the connections it initiates. This can be set up in two ways:

1. **Proxy for communication with StackState only:**
   - In this mode, the agent only proxies connections made to the StackState backend.

2. **Proxy for all Agent communication:**
   - Here, the agent proxies all connections it initiates.

## 1. Proxy for communication with StackState only

To configure the agent to proxy connections only to the StackState backend, you can use either Helm configuration or environment variables.

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

### Environment Variables

The Helm chart provides a method to inject environment variables into the Agent pods. Follow these steps:

1. Open your Helm chart `values.yaml` file.

2. Set the following configurations under `global.extraEnv.open`:

    ```yaml
    global:
        extraEnv:
          open:
            STS_PROXY_HTTPS: "https://proxy.example.com:8080"
            STS_PROXY_HTTP: "http://proxy.example.com:8080"
            STS_SKIP_SSL_VALIDATION: "true"
    ```

This configuration sets both HTTPS and HTTP proxies to the specified URLs (`https://proxy.example.com:8080` for HTTPS and `http://proxy.example.com:8080` for HTTP) and skips SSL validation.

## 2. Proxy for all Agent communication

To configure the agent to proxy all connections it initiates, use environment variables.

### Environment Variables

The Helm chart provides a method to inject environment variables into the Agent pods. Follow these steps:

1. Open your Helm chart `values.yaml` file.

2. Set the following configurations under `global.extraEnv.open`:

    ```yaml
    global:
        extraEnv:
          open:
            HTTP_PROXY: "https://proxy.example.com:8080"
            HTTPS_PROXY: "https://proxy.example.com:8080"
            STS_SKIP_SSL_VALIDATION: "true"
    ```

This configuration sets both HTTP and HTTPS proxies to the specified URL (`https://proxy.example.com:8080`) and skips SSL validation.

