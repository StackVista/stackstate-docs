---
description: StackState Self-hosted v4.5.x
---

# Traefik

The StackState Agent V2 Traefik integration provides the following functionality:

* Reporting Traefik frontends and backends as topology elements.   
* Reporting all network connections between services, including network traffic telemetry.

## Setup

### Installation

The StackState Traefik integration is included in the [Agent V2 StackPack](agent.md). Currently this integration supports tracing of Traefik requests using the Datadog tracing backend supported by Traefik.

### Configuration

Configure your Traefik instance to report [Datadog tracing data](https://doc.traefik.io/traefik/observability/tracing/datadog/) to the StackState Agent. Your Traefik.toml configuration file must include the following parameters:

```text
# Tracing definition
[tracing]
  # Use the Datadog backend to send the Datadog Tracing format to StackState Agent
  backend = "datadog"

  # Component name used for your Traefik instance in StackState
  serviceName = "traefik"

  # Span name limit allows for name truncation in case of very long Frontend/Backend names
  # This can prevent certain tracing providers to drop traces that exceed their length limits
  spanNameLimit = 100

  [tracing.datadog]
    # StackState Agent Host Port instructs reporter to send spans to the StackState Agent at this address
    localAgentHostPort = "agentHost:8126"

    # Applies a shared tag in a form of source:traefik to all the spans of the trace
    globalTag = "source:traefik"
```

### Integrate with Java traces

When using Traefik in conjunction with one of our language specific trace clients, eg. [StackState Java Trace Client - Java APM](java-apm.md) it is important to note that you should use the `backend` name of your Traefik service as the `service-name` for the trace client to allow automatic merging of the service components within StackState.

Eg. for the following `Traefik.toml`:

```text
...
[frontends]
  [frontends.stackstate-demo-frontend]
  backend = "stackstate-demo-backend"
    [frontends.stackstate-demo-frontend.routes.test_1]
    rule = "Host:test.stackstate-demo-backend.localhost"
[backends]
  [[backends.stackstate-demo-backend]]
    # ...
    [[backends.stackstate-demo-backend].servers.server1]
    url = "..."
    ...
...
```

you should pass the following jvm argument when starting your java application: `-Dsts.service.name=stackstate-demo-backend`

or for a similar docker-compose configuration:

```text
  stackstate-demo-app:
    image: stackstate-demo-app:latest
    pid: "host" # use pid:"host" to ensure pid's match with processes reported by the StackState process agent
    ports:
      - '8081-8091:8081'
    depends_on:
      - another_app
      - stackstate-agent
    labels:
      - "traefik.frontend.rule=Host:stackstate-demo-app.docker.localhost"
      - "traefik.backend=stackstate-demo-app"
    environment:
      MAVEN_OPTS: |
      -Dsts.service.name=stackstate-demo-app
      -Dsts.agent.host=${DOCKER_HOST_IP}
      -Dsts.agent.port=8126
      -javaagent:/sts-java-agent.jar
```

## Troubleshooting

To verify whether the StackState Trace Agent has received traces, set the logging level to debug and check the `trace-agent.log`:

{% tabs %}
{% tab title="stackstate.yaml" %}
```text
log_level: debug
```
{% endtab %}
{% endtabs %}

In Docker or Kubernetes, set the following environment variable for the StackState Agent

```text
STS_LOG_LEVEL: "DEBUG"
```

