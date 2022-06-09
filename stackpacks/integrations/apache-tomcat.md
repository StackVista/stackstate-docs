---
description: StackState Self-hosted v5.0.x
---

# Apache Tomcat

## Overview

This check collects Tomcat metrics, for example:

* Overall activity metrics: error count, request count, processing times
* Thread pool metrics: thread count, number of threads busy
* Servlet processing times

And more.

Apache Tomcat is a [StackState curated integration](/stackpacks/integrations/about_integrations.md#stackstate-curated-integrations).

## Setup

### Installation

The Tomcat check is included in the [Agent V2 StackPack](agent.md), so you don't need to install anything else on your Tomcat servers.

This check is JMX-based, so you need to enable JMX Remote on your Tomcat servers. Follow the instructions in the [Tomcat documentation](https://tomcat.apache.org/tomcat-6.0-doc/monitoring.html) to do that.

### Configuration

1. Edit the `tomcat.d/conf.yaml` file, in the `conf.d/` folder at the root of your Agent's configuration directory to start collecting your Tomcat metrics and logs. See the sample `tomcat.d/conf.yaml` for all available configuration options.
2. Restart the Agent

#### Metric Collection

* Add this configuration block to your `tomcat.yaml` file to start gathering your Tomcat metrics:

```text
instances:
    -   host: localhost
        port: 7199
        user: <TOMCAT_USERNAME>
        password: <PASSWORD>
        name: my_tomcat

init_config:
  conf:
    - include:
        type: ThreadPool
        attribute:
          maxThreads:
            alias: tomcat.threads.max
            metric_type: gauge
          currentThreadCount:
            alias: tomcat.threads.count
            metric_type: gauge
          currentThreadsBusy:
            alias: tomcat.threads.busy
            metric_type: gauge
    - include:
        type: GlobalRequestProcessor
        attribute:
          bytesSent:
            alias: tomcat.bytes_sent
            metric_type: counter
          bytesReceived:
            alias: tomcat.bytes_rcvd
            metric_type: counter
          errorCount:
            alias: tomcat.error_count
            metric_type: counter
          requestCount:
            alias: tomcat.request_count
            metric_type: counter
          maxTime:
            alias: tomcat.max_time
            metric_type: gauge
          processingTime:
            alias: tomcat.processing_time
            metric_type: counter
    - include:
        j2eeType: Servlet
        attribute:
          processingTime:
            alias: tomcat.servlet.processing_time
            metric_type: counter
          errorCount:
            alias: tomcat.servlet.error_count
            metric_type: counter
          requestCount:
            alias: tomcat.servlet.request_count
            metric_type: counter
    - include:
        type: Cache
        attribute:
          accessCount:
            alias: tomcat.cache.access_count
            metric_type: counter
          hitsCounts:
            alias: tomcat.cache.hits_count
            metric_type: counter
    - include:
        type: JspMonitor
        attribute:
          jspCount:
            alias: tomcat.jsp.count
            metric_type: counter
          jspReloadCount:
            alias: tomcat.jsp.reload_count
            metric_type: counter
```

See the [JMX Check documentation](jmx.md) for a list of configuration options usable by all JMX-based checks. The page also describes how the Agent tags JMX metrics.

Restart the Agent to start sending Tomcat metrics to StackState.

Configuration Options:

| Option | Required | Description |
| :--- | :--- | :--- |
| `user` and `password` | No | Username and password |
| `process_name_regex` | No | Instead of specifying a host and port or `jmx_url`, the Agent can connect using the attach api. This requires the JDK to be installed and the path to tools.jar to be set. |
| `tools_jar_path` | No | Should be set when `process_name_regex` is set. |
| `java_bin_path` | No | Should be set if the Agent cannot find your java executable. |
| `java_options` | No | Java JVM options |
| `trust_store_path` and `trust_store_password` | No | Should be set if `com.sun.management.jmxremote.ssl` is set to true on the target JVM. |
| `key_store_path` and `key_store_password` | No | Should be set if `com.sun.management.jmxremote.ssl.need.client.auth` is set to true on the target JVM. |
| `rmi_registry_ssl` | No | Should be set to true if `com.sun.management.jmxremote.registry.ssl` is set to true on the target JVM. |

The `conf` parameter is a list of dictionaries. Only 2 keys are allowed in this dictionary:

| Key | Required | Description |
| :--- | :--- | :--- |
| `include` | Yes | A dictionary of filters. Any attribute that matches these filters are collected unless it also matches the "exclude" filters. |
| `exclude` | No | A dictionary of filters. Attributes that match these filters won't be collected. |

For a given bean, metrics get tagged in the following manner:

```text
mydomain:attr0=val0,attr1=val1
```

Your metric is mydomain \(or some variation depending on the attribute inside the bean\) and has the tags `attr0:val0, attr1:val1, domain:mydomain`.

If you specify an alias in an `include` key that is formatted as _camel case_, it is converted to _snake case_. For example, `MyMetricName` is shown in StackState as `my_metric_name`.

See the sample `tomcat.yaml` for all available configuration options.

**The attribute filter**

The `attribute` filter accepts two types of values:

* A dictionary whose keys are attributes names:

```text
  conf:
    - include:
        attribute:
          maxThreads:
            alias: tomcat.threads.max
            metric_type: gauge
          currentThreadCount:
            alias: tomcat.threads.count
            metric_type: gauge
          bytesReceived:
            alias: tomcat.bytes_rcvd
            metric_type: counter
```

For the case above, the metric aliases specified become the metric name in StackState. Also, the metric type can be specified as a gauge or counter. If you choose counter, a rate per second is computed for this metric.

* A list of attributes names:

```text
  conf:
    - include:
        domain: org.apache.cassandra.db
        attribute:
          - BloomFilterDiskSpaceUsed
          - BloomFilterFalsePositives
          - BloomFilterFalseRatio
          - Capacity
          - CompressionRatio
          - CompletedTasks
          - ExceptionCount
          - Hits
          - RecentHitRate
```

In that case:

* The metric type is a gauge
* The metric name is `jmx.\[DOMAIN_NAME].\[ATTRIBUTE_NAME]`

Here is another filtering example:

```text
instances:
  - host: 127.0.0.1
    name: jmx_instance
    port: 9999

init_config:
  conf:
    - include:
        bean: org.apache.cassandra.metrics:type=ClientRequest,scope=Write,name=Latency
        attribute:
          - OneMinuteRate
          - 75thPercentile
          - 95thPercentile
          - 99thPercentile
```

```text
  conf:
    - include:
        domain: domain_name
        bean:
          - first_bean_name
          - second_bean_name
```

#### Log Collection

Tomcat uses by default the `log4j` logger. To activate the logging into a file and customize the log format edit the `log4j.properties` file in the `$CATALINA_BASE/lib` directory as follows:

```text
log4j.rootLogger = INFO, CATALINA

 # Define all the appenders
log4j.appender.CATALINA = org.apache.log4j.DailyRollingFileAppender
log4j.appender.CATALINA.File = /var/log/tomcat/catalina.log
log4j.appender.CATALINA.Append = true

 # Roll-over the log once per day
log4j.appender.CATALINA.layout = org.apache.log4j.PatternLayout
log4j.appender.CATALINA.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p [%t] %c{1}:%L - %m%n

log4j.appender.LOCALHOST = org.apache.log4j.DailyRollingFileAppender
log4j.appender.LOCALHOST.File = /var/log/tomcat/localhost.log
log4j.appender.LOCALHOST.Append = true
log4j.appender.LOCALHOST.layout = org.apache.log4j.PatternLayout
log4j.appender.LOCALHOST.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p [%t] %c{1}:%L - %m%n

log4j.appender.MANAGER = org.apache.log4j.DailyRollingFileAppender
log4j.appender.MANAGER.File = /var/log/tomcat/manager.log
log4j.appender.MANAGER.Append = true
log4j.appender.MANAGER.layout = org.apache.log4j.PatternLayout
log4j.appender.MANAGER.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p [%t] %c{1}:%L - %m%n

log4j.appender.HOST-MANAGER = org.apache.log4j.DailyRollingFileAppender
log4j.appender.HOST-MANAGER.File = /var/log/tomcat/host-manager.log
log4j.appender.HOST-MANAGER.Append = true
log4j.appender.HOST-MANAGER.layout = org.apache.log4j.PatternLayout
log4j.appender.HOST-MANAGER.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p [%t] %c{1}:%L - %m%n

log4j.appender.CONSOLE = org.apache.log4j.ConsoleAppender
log4j.appender.CONSOLE.layout = org.apache.log4j.PatternLayout
log4j.appender.CONSOLE.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %-5p [%t] %c{1}:%L - %m%n

 # Configure which loggers log to which appenders
log4j.logger.org.apache.catalina.core.ContainerBase.[Catalina].[localhost] = INFO, LOCALHOST
log4j.logger.org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager] =\
  INFO, MANAGER
log4j.logger.org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/host-manager] =\
  INFO, HOST-MANAGER
```

Check Tomcat logging documentation for more information about Tomcat logging capabilities.

* Collecting logs is disabled by default in the StackState Agent, enable it in your `stackstate.yaml` file with:

  ```text
  logs_enabled: true
  ```

* Add this configuration block to your `tomcat.d/conf.yaml` file to start collecting your Tomcat Logs:

  ```text
  logs:
    - type: file
      path: /var/log/tomcat/*.log
      source: tomcat
      service: myapp
      #To handle multi line that starts with yyyy-mm-dd use the following pattern
      #log_processing_rules:
      #  - type: multi_line
      #    name: log_start_with_date
      #    pattern: \d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])
  ```

* Change the `path` and `service` parameter values and configure them for your environment. See the sample `tomcat.yaml` for all available configuration options.
* Restart the Agent.

### Validation

Run the Agent's status subcommand and look for `tomcat` under the **Checks** section.

## Data Collected

### Metrics

See `metadata.csv` for a list of metrics provided by this check.

### Events

The Tomcat check does not include any events.

### Service Checks

**tomcat.can\_connect** Returns `CRITICAL` if the Agent is unable to connect to and collect metrics from the monitored Tomcat instance. Returns `OK` otherwise.

## Troubleshooting

### Commands to view the metrics that are available:

* List attributes that match at least one of your instance configurations:

  `sudo /etc/init.d/stackstate-agent jmx list_matching_attributes`

* List attributes that match one of your instance configurations but that are not collected because it would exceed the number of metrics that can be collected:

  `sudo /etc/init.d/stackstate-agent jmx list_limited_attributes`

* List attributes that are actually collected by your current instance configurations:

  `sudo /etc/init.d/stackstate-agent jmx list_collected_attributes`

* List attributes that don't match any of your instance configurations:

  `sudo /etc/init.d/stackstate-agent jmx list_not_matching_attributes`

* List every attribute available that has a type supported by JMXFetch:

  `sudo /etc/init.d/stackstate-agent jmx list_everything`

* Start the collection of metrics based on your current configuration and display them in the console:

  `sudo /etc/init.d/stackstate-agent jmx collect`

