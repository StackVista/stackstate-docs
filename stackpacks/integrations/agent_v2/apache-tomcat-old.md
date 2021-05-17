# Apache Tomcat

## Overview

This Apache Tomcat integration collects Tomcat metrics, including:

* Overall activity metrics: error count, request count, processing times
* Thread pool metrics: thread count, number of threads busy
* Servlet processing times

![Apache Tomcat integration](/.gitbook/assets/stackpack-agent-tomcat.png)

* 
* 
* 

## Setup

### Prerequisites

* JMX Remote should be enabled on your Tomcat servers. For details, see the [Apache Tomcat documentation \(tomcat.apache.org\)](https://tomcat.apache.org/tomcat-6.0-doc/monitoring.html).
* TODO: prereq for Agent V2 StackPack
*

### Install

The Apache Tomcat check is included in the [Agent V2 StackPack](/stackpacks/integrations/agent.md). You do not need to install anything else on your Tomcat servers.

### Configure



To enable the Apache Tomcat check and begin collecting data from your Apache Tomcat instance:

1. Edit the Agent integration configuration file `/etc/stackstate-agent/conf.d/tomcat.d/conf.yaml` to include details of your Apache Tomcat instance:
   * **host** - 
   * **port** -   
   * **username** - Optional. The username to use when connecting to Apache Tomcat.
   * **password** - Optional. Use [secrets management](/configure/security/secrets_management.md) to store passwords outside of the configuration file.
   * **name** - 

     ```text
     instances:
        - host: localhost
          port: 7199
          user: <TOMCAT_USERNAME>
          password: <PASSWORD>
          name: my_tomcat
     ```
2. To enable metrics retrieval, 
2. If required, you can customise the integration using the [advanced configuration options](#advanced-configuration).
3. [Restart the StackState Agent\(s\)](agent.md#start-stop-restart-the-stackstate-agent) to publish the configuration changes.
4. Once the Agent has restarted, wait for the Agent to collect the data and send it to StackState.

### Status

### Upgrade

[Agent V2 StackPack](/stackpacks/integrations/agent.md)

## Integration details

### Data retrieved

#### Topology

#### Metrics

#### Events

#### Traces

### Rest API endpoints

### Views in StackState

### Actions in StackState

### Tags

### Open source

## Troubleshooting

## Uninstall

To disable the Apache Tomcat check, remove or rename the Agent integration configuration file, for example:

```buildoutcfg
mv tomcat.d/conf.yaml tomcat.d/conf.yaml.bak
```

To uninstall the Agent V2 StackPack, see the [Agent V2 StackPack documentation](/stackpacks/integrations/agent.md).

## Release notes

See the release notes for the [Agent V2 StackPack](/stackpacks/integrations/agent.md).

## See also

* [Agent V2 StackPack](/stackpacks/integrations/agent.md)
* [Apache Tomcat documentation \(tomcat.apache.org\)](https://tomcat.apache.org/tomcat-6.0-doc/monitoring.html)

