---
description: StackState Self-hosted v4.5.x
---

{% hint style="info" %}
These are the docs for the StackState Self-hosted product. [Go to the StackState SaaS docs site](https://docs.stackstate.com/v/stackstate-saas/).
{% endhint %}

# Java APM

## Overview

The Java APM Integration of the Agent V2 StackPack provides tracing support for Java JVM based systems. With this Agent you will get:

* All services which can be discovered by our Agent as components
* All relations between the different services
* Latency, Throughput and Error metric streams on all relations between service components
* Heap usage, etc. for all services

This integration will be a part of the Agent V2 StackPack which should be installed as the first step; the rest of the installation instructions will follow soon.

The traces collected by the java trace client are forwarded to the StackState Trace Agent, which in turn forwards it to StackState. This also means that port `7077` should be opened for communication from the StackState Trace Agent.

## Automatic Instrumentation

Automatic instrumentation for Java uses the `java-agent` instrumentation capabilities provided by the JVM. When the `java-agent` is registered, it has the ability to modify class files at the load time. The `java-agent` uses the Byte Buddy framework to find the classes defined for instrumentation and modify those class bytes accordingly.

Instrumentation may come from an auto-instrumentation, the OpenTracing api, or a mixture of both. Instrumentation generally captures the following info:

* Timing duration is captured using the JVM's nanotime clock unless a timestamp is provided from the OpenTracing api
* Key/value tag pairs
* Errors and stacktraces which are unhandled by the application
* A total count of traces \(requests\) flowing through the system

## Traces Installation

To enable tracing and sending it to Stackstate Trace Agent, you need to follow the below steps to get started.

Download the [java trace client](https://github.com/StackVista/sts-trace-java/releases/download/v0.31.0/sts-java-agent-0.31.0.jar) and follow the steps below for the different environments.

### Traces Installation - VM

* Set the following jvm arguments when running your java application
  * -Dsts.service.name=`{{service-name}}`
  * -Dsts.agent.host=`{{host-of-the-stackstate-agent}}`
  * -Dsts.agent.port=`8126 {the default port for the trace agent api}`
  * -javaagent:`{path/of/downloaded-jar.jar}`  
* Once above steps are done,the java trace client will start sending collected traces to the StackState Trace Agent which will then be forwarded to StackState.

### Traces Installation - Docker

* Set the following jvm arguments in your `environment` variables when running your container
  * -Dsts.service.name=`{{service-name}}`
  * -Dsts.agent.host=`{{host-of-the-stackstate-agent}}`
  * -Dsts.agent.port=`8126 {the default port for the trace agent api}`
  * -javaagent:`{path/of/downloaded-jar.jar}` 

Eg. running a container, setting the jvm arguments as part of `MAVEN_OPTS`.

```text
  ...
  application-name:
    image: my/docker/image:version
    environment:
      MAVEN_OPTS: |
        -Dsts.service.name=`{{service-name}}`
        -Dsts.agent.host=`{{host-of-the-stackstate-agent}}`
        -Dsts.agent.port=`8126 {the default port for the trace agent api}`
        -javaagent:`{path/of/downloaded-jar.jar}`
```

### Traces Installation - Kubernetes

* Set the following jvm arguments in your `env` variables for the container when running your pod
  * -Dsts.service.name=`{{service-name}}`
  * -Dsts.agent.host=`{{host-of-the-stackstate-agent}}`
  * -Dsts.agent.port=`8126 {the default port for the trace agent api}`
  * -javaagent:`{path/of/downloaded-jar.jar}`

Eg. running a container in a pod, setting the jvm arguments as part of `MAVEN_OPTS`.

```text
  - name: application-name
    image: my/docker/image:version
    env:
      - name: MAVEN_OPTS
        value: |
        -Dsts.service.name=`{{service-name}}`
        -Dsts.agent.host=`{{host-of-the-stackstate-agent}}`
        -Dsts.agent.port=`8126 {the default port for the trace agent api}`
        -javaagent:`{path/of/downloaded-jar.jar}`
```

## Compatibility

StackState officially supports the Java JRE 1.7 and higher versions of both Oracle JDK and OpenJDK. StackState does not officially support any early-access versions of Java.

### Web Framework Compatibility

`stackstate-java-agent` includes support for automatically tracing the following web frameworks.

| Server | Versions | Support Type | Instrumentation Names \(used for configuration\) |
| :--- | :--- | :--- | :--- |
| Akka-Http Server | 10.0+ | Fully Supported | `akka-http`, `akka-http-server` |
| Java Servlet Compatible | 2.3+, 3.0+ | Fully Supported | `servlet`, `servlet-2`, `servlet-3` |
| Jax-RS Annotations | JSR311-API | Fully Supported | `jax-rs`, `jaxrs`, `jax-rs-annotations` |
| Jetty \(non-Servlet\) | 8+ | Beta | `jetty`, `jetty-8` |
| Netty Http Server and Client | 4.0+ | Fully Supported | `netty`, `netty-4.0`, `netty-4.1` |
| Play | 2.4-2.6 | Fully Supported | `play` |
| Ratpack | 1.4+ | Beta | `ratpack` |
| Spark Java | 2.3+ | Beta | `sparkjava` \(requires `jetty`\) |
| Spring Web \(MVC\) | 4.0+ | Fully Supported | `spring-web` |
| Spring WebFlux | 5.0+ | Fully Supported | `spring-webflux` |
| Vert.x-Web | 4.1.0+ | Fully Supported | \(requires `netty`\) |

**Web Framework tracing provides:** timing HTTP request to response, tags for the HTTP request \(status code, method, etc\), error and stacktrace capturing, linking work created within a web request and Distributed Tracing.

_Note:_ Many application servers are Servlet compatible and are automatically covered by that instrumentation, such as Tomcat, Jetty, Websphere, Weblogic, etc. Also, frameworks like Spring Boot inherently work because it uses a Servlet compatible embedded application server.

Don't see your desired web frameworks? StackState is continuously adding additional support. Contact our support if you need help.

### Networking Framework Compatibility

The `stackstate-java-agent` includes support for automatically tracing the following networking frameworks:

| Framework | Versions | Support Type | Instrumentation Names \(used for configuration\) |
| :--- | :--- | :--- | :--- |
| Apache HTTP Client | 4.0+ | Fully Supported | `httpclient` |
| Apache HTTP Async Client | 4.0+ | Fully Supported | `httpasyncclient`, apache-httpasyncclient |
| AWS Java SDK | 1.11+, 2.2+ | Fully Supported | `aws-sdk` |
| gRPC | 1.5+ | Fully Supported | `grpc`, `grpc-client`, `grpc-server` |
| HttpURLConnection | all | Fully Supported | `httpurlconnection`, `urlconnection` |
| Kafka-Clients | 0.11+ | Fully Supported | `kafka` |
| Kafka-Streams | 0.11+ | Fully Supported | `kafka`, `kafka-streams` |
| Jax RS Clients | 2.0+ | Fully Supported | `jax-rs`, `jaxrs`, `jax-rs-client` |
| JMS | 1 and 2 | Fully Supported | `jms` |
| Rabbit AMQP | 2.7+ | Fully Supported | `amqp`, `rabbitmq` |
| OkHTTP | 3.0+ | Fully Supported | `okhttp`, `okhttp-3` |

**Networking tracing provides:** timing request to response, tags for the request \(e.g. response code\), error and stacktrace capturing, and distributed tracing.

Don't see your desired networking framework? StackState is continuously adding additional support. Contact our support if you need help.

### Data Store Compatibility

`stackstate-java-agent` includes support for automatically tracing the following database frameworks/drivers:

| Database | Versions | Support Type | Instrumentation Names \(used for configuration\) |
| :--- | :--- | :--- | :--- |
| Couchbase | 2.0+ | Fully Supported | `couchbase` |
| Cassandra | 3.X | Fully Supported | `cassandra` |
| Elasticsearch Transport | 2.0+ | Fully Supported | `elasticsearch`, `elasticsearch-transport`, `elasticsearch-transport-{2,5,6}` \(pick one\) |
| Elasticsearch Rest | 5.0+ | Fully Supported | `elasticsearch`, `elasticsearch-rest`, `elasticsearch-rest-5`, `elasticsearch-rest-6` |
| Hibernate | 3.5+ | Fully Supported | `hibernate` |
| JDBC | N/A | Fully Supported | `jdbc` |
| Jedis | 1.4+ | Fully Supported | `redis` |
| Lettuce | 5.0+ | Fully Supported | `lettuce` |
| MongoDB | 3.0+ | Fully Supported | `mongo` |
| SpyMemcached | 2.12+ | Fully Supported | `spymemcached` |

`stackstate-java-agent` is also compatible with common JDBC drivers including:

* Apache Derby
* Firebird SQL
* H2 Database Engine
* HSQLDB
* IBM DB2
* MariaDB
* MSSQL \(Microsoft SQL Server\)
* MySQL
* Oracle
* Postgres SQL

**Datastore tracing provides:** timing request to response, query info \(e.g. a sanitized query string\), and error and stacktrace capturing.

Don't see your desired datastores? StackState is continuously adding additional support. Contact our support if you need help.

### Other Framework Compatibility

`stackstate-java-agent` includes support for automatically tracing the following other frameworks:

| Framework | Versions | Support Type | Instrumentation Names \(used for configuration\) |
| :--- | :--- | :--- | :--- |
| Slf4J MDC | 1+ | Fully Supported | `mdc` \(See also `dd.logs.injection` config\) |
| JSP Rendering | 2.3+ | Fully Supported | `jsp`, `jsp-render` |
| Dropwizard Views | 0.7+ | Fully Supported | `dropwizard`, `dropwizard-view` |
| Hystrix | 1.4+ | Fully Supported | `hystrix` |
| Twilio SDK | 0+ | Fully Supported | `twilio-sdk` |

Don't see your desired framework? StackState is continuously adding additional support. Contact our support if you need help.

To improve visibility into applications using unsupported frameworks, consider:

* Adding custom instrumentation \(with OpenTracing or the `@Trace` annotation\).
* Submitting a pull request with the instrumentation for inclusion in a future release.
* Contacting our support and submitting a feature request.

## Troubleshooting

To troubleshoot the java trace client add the following jvm arguments:

```text
-Dstackstate.slf4j.simpleLogger.defaultLogLevel=debug
```

You can also verify whether the StackState Trace Agent has received the traces, by setting the logging level to debug and checking the `trace-agent.log`:

stackstate.yaml

```text
log_level: debug
```

In Docker or Kubernetes, set the following environment variable for the StackState Agent

```text
STS_LOG_LEVEL: "DEBUG"
```

