# Use an HTTP/HTTPS proxy

## Overview

The Agent can be configured to use a proxy for HTTP and HTTPS requests. A proxy can be configured in two ways:

* [Environment variables](#environment-variables) - use a proxy for all Agent communication (Agent checks and communication with StackState) with `HTTPS_PROXY` / `HTTP_PROXY` or only for communication with StackState using `STS_PROXY_HTTPS` / `STS_PROXY_HTTP`.
* [Agent configuration file](#agent-configuration) - use a proxy for communication with StackState only.

Configured proxy settings will be used by the Agent in the following sequence:

1. Environment variables: `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` 
2. Environment variables: `HTTPS_PROXY` / `HTTP_PROXY`
3. Proxy settings in the Agent configuration file.

For example, if the environment variable `STS_PROXY_HTTPS=""` is set and the Agent configuration file contains the proxy setting `https: https://example.com:1234`, the Agent will use the proxy `""` for HTTPS requests.

It is also possible to specify a list of hosts for which no proxy should be used.

## Environment variables

{% tabs %}
{% tab title="Linux" %}
**To add environment variables to the StackState Agent systemd service:**

1. Stop the service:
   ```yaml
   sudo systemctl stop stackstate-agent.service  
   ```

2. Edit the service:
   ```yaml
   sudo systemctl edit stackstate-agent.service
   ```

3. Add the environment variables to use a proxy:
   * To use a proxy for communication with StackState only - note that this setting takes precedence over all other Agent proxy settings:
     ```yaml
     [Service]
     Environment="STS_PROXY_HTTP=http://example.com:1234"
     Environment="STS_PROXY_HTTPS=https://example.com:1234"
     ```
     
   * To use a proxy for Agent checks and communication with StackState - note that this setting will be overridden by the environment variables: `STS_PROXY_HTTPS` / `STS_PROXY_HTTP`:
     ```yaml
     [Service]
     Environment="HTTP_PROXY=http://example.com:1234"
     Environment="HTTPS_PROXY=https://example.com:1234"
     ```

4. Optionally specify a list of hosts for which a proxy should NOT be used:
   * To NOT use a proxy for communication with StackState at a specified host - note that this setting takes precedence over all other Agent no proxy settings:
     ```yaml
     [Service]
     Environment="STS_PROXY_NO_PROXY=http://example.com:1234 http://anotherexample.com:1234"
     ```

   * To NOT use a proxy for Agent checks and communication with StackState at a specified host - note that this setting will be overridden by the environment variable: `STS_PROXY_NO_PROXY`:
     ```yaml
     [Service]
     Environment="NO_PROXY=http://example.com:1234 http://anotherexample.com:1234"
     ``` 
    
5. Restart the service:
   ```yaml
   sudo systemctl start stackstate-agent.service
   ```

**To remove environment variables from the StackState Agent systemd service:**

1. Stop the service:
   ```yaml
   sudo systemctl stop stackstate-agent.service
   ```

3. Delete the settings file:
   ```yaml
   sudo rm /etc/systemd/system/stackstate-agent.service.d/override.conf 
   ```

5. Restart the service:
   ```yaml
   sudo systemctl daemon-reload
   sudo systemctl start stackstate-agent.service
   ```
{% endtab %}
{% tab title="Docker" %}
second tab text
{% endtab %}
{% tab title="Windows" %}
second tab text
{% endtab %}
{% endtabs %}

## Agent configuration


