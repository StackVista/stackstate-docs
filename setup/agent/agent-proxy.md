# Use an HTTP/HTTPS proxy

## Overview

The Agent can be configured to use a proxy for HTTP and HTTPS requests. It is also possible to specify a list of hosts for which no proxy should be used. Proxy settings can be configured in two ways:

* [Proxy for all Agent communication](#proxy-for-all-agent-communication). This includes Agent checks and communication with StackState. Configured with:
  * Environment variables - `HTTPS_PROXY` / `HTTP_PROXY` / `NO_PROXY`
* [Proxy for communication with StackState only](#proxy-for-communication-with-stackstate-only). Can be configured in 2 places: 
  * Environment variables - `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`
  * Agent configuration file

Configured proxy settings will be used by the Agent in the following sequence:

1. Environment variables `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`
2. Environment variables `HTTPS_PROXY` / `HTTP_PROXY` / `NO_PROXY`
3. Proxy settings in the Agent configuration file.

For example, if the environment variable `STS_PROXY_HTTPS=""` is set and the Agent configuration file contains the proxy setting `https: https://example.com:1234`, the Agent will use the proxy `""` for HTTPS requests.

## Proxy for all Agent communication

To use a proxy for all Agent communication including checks and communication with StackState, set the environment variables  `HTTPS_PROXY` / `HTTP_PROXY` / `NO_PROXY`.

{% hint style="info" %}
Note that these settings will be overridden by the environment variables: `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`. See [proxy for communication with StackState only](#proxy-for-communication-with-stackstate-only).
{% endhint %}

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

3. Add the environment variables below to use a proxy for Agent checks and communication with StackState - note that this setting will be overridden by the environment variables: `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` if they are also set:
     ```yaml
     [Service]
     Environment="HTTP_PROXY=http://example.com:1234"
     Environment="HTTPS_PROXY=https://example.com:1234"
     ```
   You can also [use a proxy only for communication with StackState](#proxy-for-communication-with-stackstate-only).

4. Optionally specify a list of hosts for which the proxy should not be used - note that this setting will be overridden by the environment variable: `STS_PROXY_NO_PROXY` if it has been set:
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


## Proxy for communication with StackState only

### Environment variables

To use a proxy for communication with StackState only, set the environment variables  `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`.

{% hint style="info" %}
Note that these settings will override all other proxy settings either in environment variables or the Agent configuration file.
{% endhint %}

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

3. Add the environment variables below to use a proxy for communication with StackState only:
     ```yaml
     [Service]
     Environment="STS_PROXY_HTTP=http://example.com:1234"
     Environment="STS_PROXY_HTTPS=https://example.com:1234"
     ```
   You can also [use a proxy for all Agent communication](#proxy-for-all-agent-communication).

4. Optionally specify a list of hosts for which a proxy should NOT be used:
     ```yaml
     [Service]
     Environment="STS_PROXY_NO_PROXY=http://example.com:1234 http://anotherexample.com:1234"
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

### Agent configuration

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
   * Proxy for communication with StackState only:
     ```yaml
     [Service]
     Environment="STS_PROXY_HTTP=http://example.com:1234"
     Environment="STS_PROXY_HTTPS=https://example.com:1234"
     ```
     
   * Proxy for Agent checks and communication with StackState - note that this setting will be overridden by the environment variables: `STS_PROXY_HTTPS` / `STS_PROXY_HTTP`:
     ```yaml
     [Service]
     Environment="HTTP_PROXY=http://example.com:1234"
     Environment="HTTPS_PROXY=https://example.com:1234"
     ```

4. Optionally specify a list of hosts for which a proxy should NOT be used:
   * No proxy for communication with StackState at a specified host only:
     ```yaml
     [Service]
     Environment="STS_PROXY_NO_PROXY=http://example.com:1234 http://anotherexample.com:1234"
     ```

   * No proxy for Agent checks and communication with StackState at a specified host - note that this setting will be overridden by the environment variable: `STS_PROXY_NO_PROXY`:
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



