# Use an HTTP/HTTPS proxy

## Overview

The Agent can be configured to use a proxy for HTTP and HTTPS requests. It is also possible to specify a list of hosts for which no proxy should be used. Proxy settings can be configured in two ways:

* [Proxy for all Agent communication](#proxy-for-all-agent-communication). This includes Agent checks and communication with StackState. Configured with:
  * Environment variables `HTTPS_PROXY` / `HTTP_PROXY` / `NO_PROXY`
* [Proxy for communication with StackState only](#proxy-for-communication-with-stackstate-only). Can be configured in 2 places: 
  * Environment variables `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`
  * Agent configuration file

Configured proxy settings will be used by the Agent in the following sequence:

1. Environment variables `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`
2. Environment variables `HTTPS_PROXY` / `HTTP_PROXY` / `NO_PROXY`
3. Proxy settings in the Agent configuration file.

For example, if the environment variable `STS_PROXY_HTTPS=""` is set and the Agent configuration file contains the proxy setting `https: https://example.com:1234`, the Agent will use the proxy `""` for HTTPS requests to StackState.

## Proxy for all Agent communication

{% hint style="info" %}
Note that these settings will be overridden by the environment variables: `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` / `STS_PROXY_NO_PROXY`. See [proxy for communication with StackState only](#proxy-for-communication-with-stackstate-only).
{% endhint %}

To use a proxy for all Agent communication including checks and communication with StackState, set the following environment variables:

* `HTTP_PROXY` - proxy to use for all HTTP communication.
* `HTTPS_PROXY` - proxy to use for all HTTPS communication.
* `NO_PROXY` - comma separated list of hosts for which the configured `HTTP_PROXY` and `HTTPS_PROXY` should not be used.

{% tabs %}
{% tab title="Linux" %}
To configure a proxy for an Agent running on Linux, add the required environment variables to the StackState Agent systemd service.

**Add environment variables to the StackState Agent systemd service:**

1. Stop the service:
   ```yaml
   sudo systemctl stop stackstate-agent.service  
   ```

2. Edit the service:
   ```yaml
   sudo systemctl edit stackstate-agent.service
   ```

3. Add the environment variables below to use a proxy for Agent checks and communication with StackState - note that this setting will be overridden by the environment variables `STS_PROXY_HTTPS` / `STS_PROXY_HTTP` if they are also set:
     ```yaml
     [Service]
     Environment="HTTP_PROXY=http://example.com:1234"
     Environment="HTTPS_PROXY=https://example.com:1234"
     ```
   You can also [use a proxy only for communication with StackState](#proxy-for-communication-with-stackstate-only).

4. Optionally specify a list of hosts for which the configured `HTTP_PROXY` and `HTTPS_PROXY` should not be used - note that this setting will be overridden by the environment variable `STS_PROXY_NO_PROXY` if it has been set:
     ```yaml
     [Service]
     Environment="NO_PROXY=http://example.com:1234,http://anotherexample.com:1234"
     ``` 
    
5. Restart the service:
   ```yaml
   sudo systemctl start stackstate-agent.service
   ```

**Remove environment variables from the StackState Agent systemd service:**

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
To configure a proxy for an Agent running in a Docker container, use one of the commands below to pass the required environment variables when starting StackState Agent.

**Single container**

Run the command:
```yaml
docker run -d \
 --name stackstate-agent \
 --privileged \
 --network="host" \
 --pid="host" \
 -v /var/run/docker.sock:/var/run/docker.sock:ro \
 -v /proc/:/host/proc/:ro \
 -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
 -e STS_API_KEY="API_KEY" \
 -e STS_STS_URL="<stackstate-receiver-api-address>" \
 -e HOST_PROC="/host/proc" \
 -e HTTP_PROXY="http://example.com:1234" \
 -e HTTPS_PROXY="https://example.com:1234" \
 -e NO_PROXY="http://example.com:1234,http://anotherexample.com:1234" \
 docker.io/stackstate/stackstate-agent-2:latest
```

**Docker compose**

1. Add the following to the `environment` section of the compose file on each node where the Agent will run and should use a proxy:
   ```yaml
   environment:
     HTTP_PROXY="http://example.com:1234"
     HTTPS_PROXY="https://example.com:1234"
     NO_PROXY="http://example.com:1234,http://anotherexample.com:1234"
   ```
    
2. Run the command:
    ```yaml
    docker-compose up -d
    ```
  
**Docker Swarm**

1. Add the following to the `environment` section of the `docker-compose.yml` file used to deploy the Agent:
   ```yaml
   environment:
     HTTP_PROXY="http://example.com:1234"
     HTTPS_PROXY="https://example.com:1234"\
     NO_PROXY="http://example.com:1234,http://anotherexample.com:1234"
   ```
    
2. Run the command:
    ```yaml
    docker stack deploy -c docker-compose.yml
    ```
{% endtab %}
{% tab title="Windows" %}
second tab text
{% endtab %}
{% endtabs %}


## Proxy for communication with StackState only

### Environment variables

{% hint style="info" %}
Note that these settings will override all other proxy settings either in environment variables or the Agent configuration file.
{% endhint %}

To use a proxy for communication with StackState only, set the following environment variables: 

* `STS_PROXY_HTTPS` - proxy to use for HTTP communication with StackState.
* `STS_PROXY_HTTP` - proxy to use for HTTPS communication with StackState.
* `STS_PROXY_NO_PROXY` - space separated list of hosts for which the configured `STS_PROXY_HTTP` and `STS_PROXY_HTTPS` should not be used.

{% tabs %}
{% tab title="Linux" %}

To configure a proxy for an Agent running on Linux, add the required environment variables to the StackState Agent systemd service.

**Add environment variables to the StackState Agent systemd service:**

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

4. Optionally specify a list of hosts for which the configured `STS_PROXY_HTTP` and `STS_PROXY_HTTPS` should not be used:
     ```yaml
     [Service]
     Environment="STS_PROXY_NO_PROXY=http://example.com:1234 http://anotherexample.com:1234"
     ```

5. Restart the service:
   ```yaml
   sudo systemctl start stackstate-agent.service
   ```

**Remove environment variables from the StackState Agent systemd service:**

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
To configure a proxy for an Agent running in a Docker container, use one of the commands below to pass the required environment variables when starting StackState Agent.

**Single container**
Run the command:
```yaml
docker run -d \
 --name stackstate-agent \
 --privileged \
 --network="host" \
 --pid="host" \
 -v /var/run/docker.sock:/var/run/docker.sock:ro \
 -v /proc/:/host/proc/:ro \
 -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
 -e STS_API_KEY="API_KEY" \
 -e STS_STS_URL="<stackstate-receiver-api-address>" \
 -e HOST_PROC="/host/proc" \
 -e STS_PROXY_HTTP="http://example.com:1234" \
 -e STS_PROXY_HTTPS="https://example.com:1234" \
 -e STS_PROXY_NO_PROXY="http://example.com:1234 http://anotherexample.com:1234" \
 docker.io/stackstate/stackstate-agent-2:latest
```

**Docker compose**
1. Add the following to the `environment` section of the compose file on each node where the Agent will run and should use a proxy:
   ```yaml
   environment:
     STS_PROXY_HTTP="http://example.com:1234"
     STS_PROXY_HTTPS="https://example.com:1234"
     STS_PROXY_NO_PROXY="http://example.com:1234 http://anotherexample.com:1234"
   ```
    
2. Run the command:
    ```yaml
    docker-compose up -d
    ```

**Docker Swarm** 
1. Add the following to the `environment` section of the `docker-compose.yml` file used to deploy the Agent:
   ```yaml
   environment:
     STS_PROXY_HTTP="http://example.com:1234"
     STS_PROXY_HTTPS="https://example.com:1234"
     STS_PROXY_NO_PROXY="http://example.com:1234 http://anotherexample.com:1234"
   ```
    
2. Run the command:
    ```yaml
    docker stack deploy -c docker-compose.yml
    ```

{% endtab %}
{% tab title="Windows" %}
second tab text
{% endtab %}
{% endtabs %}

### Agent configuration

{% hint style="info" %}

Note that proxy settings configured using an environment variable will override any proxy setting in the Agent configuration file. 

{% endhint %}

A proxy set in the Agent configuration file will be used for communication with StackState only. Checks configured on the Agent will not use this proxy for communication with external systems. To use a proxy for Agent checks and communication with StackState, see how to use a [proxy for all Agent communication](#proxy-for-all-agent-communication).

Follow the instructions below to update the Agent configuration to use a proxy for communication with StackState.

{% tabs %}
{% tab title="Linux" %}

1. Edit the Agent configuration file:
   ```yaml
   sudo vi /etc/stackstate-agent/stackstate.yaml
   ```

2. Uncomment the proxy settings:
   ```yaml
   proxy:
     https: https://example.com:1234
     http: http://example.com:1234
   ```

3. Restart the Agent.
   ```yaml
   sudo systemctl start stackstate-agent.service
   ```
{% endtab %}
{% tab title="Docker" %}
first tab text
{% endtab %}
{% tab title="Windows" %}
second tab text
{% endtab %}
{% endtabs %}


