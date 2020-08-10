---
title: Production Installation before 1.15.0
kind: Documentation
---

# Production installation pre 1.15

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's [installation requirements](requirements.md).

## Two-node deployment architecture

To improve the performance of the StackState installation, it can be split over two nodes with each node performing a different function. The first node will run StackState itself, including Kafka and ElasticSearch. The second node will run the StackGraph data store.

## Installing StackState in a two-node configuration

To improve the performance of the StackState installation, it can be split over two nodes with each node performing a different function. The first node will run StackState itself, including Kafka and ElasticSearch. The second node will run the StackGraph data store.

Configure StackState to run in the two-node setup requires the following steps:

### Preparing the StackGraph node

1. Install the package using the instruction for [Installing StackState](install_stackstate.md).
2. Run `systemctl disable stackstate`
3. Add `Environment=STACKGRAPH_NODE_NAME=<stackgraph-host-name>` to /lib/systemd/system/stackgraph.service
4. Reload systemd daemon: `systemctl daemon-reload`
5. Start the StackGraph process as described in [Starting / Stopping](production-installation_pre1_15.md#starting-and-stopping).

### Preparing the StackState node

To prepare an additional node for running a StackState component, follow these steps:

1. Install the package using the instruction for [Installing StackState](install_stackstate.md).
2. Run `systemctl disable stackgraph`
3. Modify the provided SystemD configuration files as follows:
   * Edit the file `/lib/systemd/system/stackstate.service`:
     * Remove the `stackgraph.service` from the `Requires` and `After` sections
     * Define the environment variable `ZOOKEEPER_QUORUM` by adding the line `Environment=ZOOKEEPER_QUORUM=<your-stackgraph-server>` under the `[Service]` section, with the hostname of your StackGraph server as the value.
     * Reload systemd daemon: `systemctl daemon-reload`

After these changes the `stackstate.service` file should look approximately like this:

```text
    [Unit]
    Description=StackState System monitor Service
    After=syslog.target network.target

    [Service]
    LimitNOFILE=131072
    Type=forking
    User=stackstate
    Group=stackstate
    PIDFile=/opt/stackstate/var/run/stackstate.pid
    ExecStart=/opt/stackstate/bin/sts-service.sh start
    ExecReload=/opt/stackstate/bin/sts-service.sh reload
    ExecStop=/opt/stackstate/bin/sts-service.sh stop
    Environment=ZOOKEEPER_QUORUM=<your-stackgraph-server>

    [Install]
    Alias=stackstate.service
    WantedBy=multi-user.target
```

### Configuration files

The main configuration file for StackState server is `application_stackstate.conf` located in the `STACKSTATE_HOME/etc` directory. This file can be manipulated directly to alter the StackState configuration. Secondly, to manipulate the running of stackstate processes, a `STACKSTATE_HOME/etc/processmanager/processmanager-properties-overrides.conf` file can be created, to override the properties exposed by `STACKSTATE_HOME/etc/processmanager/processmanager-properties.conf`.

### Configuring StackState

After you have installed StackState, refer to the following pages for configuration instructions:

* [Configuring authentication](authentication.md)
* [Reverse Proxy](reverse_proxy.md)

### Starting and Stopping

Note that the StackGraph node always needs to be running before starting StackState

### Starting and Stopping StackGraph

On the StackGraph node, the following commands will start/stop StackGraph:

`sudo systemctl start stackgraph.service`

`sudo systemctl stop stackgraph.service`

### Starting and Stopping StackState

On the StackState node, the following commands will start/stop StackState:

`sudo systemctl start stackstate.service`

`sudo systemctl stop stackstate.service`

