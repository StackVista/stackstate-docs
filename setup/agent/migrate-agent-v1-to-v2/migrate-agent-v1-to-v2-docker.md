---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(legacy\) to Agent V2 Migration

### Overview

This page will walk you through the steps required to successfully migrate from Agent V1 (legacy) to Agent V2.  This migration process will also migrate the  existing Agent V1 (legacy) state. This will allow Agent checks, such as Splunk topology, metrics or event checks, to continue on Agent V2 from their previous state.

{% hint style="warning" %}
**The migration process steps detailed below must be carried out in the correct order**.

Problems can occur if any of the steps is completed out of order. This could result in overwritten Agent state files, invalid Agent state files or a broken Agent V2 instance.
{% endhint %}

{% hint style="warning" %}
**It is highly recommended to run this migration in a test environment.** 

It may affect some steps below, but will reduce the initial impact if something does not run to plan.
{% endhint %}

## Impact analysis

### Downtime

Running Agent V1 (legacy) and Agent V2 at the same time on a single machine will result in missing data. For this reason, StackState Agent will need to be down for the entire of the migration process. The exact length of time required to complete the migration process will vary depending on your specific environment and the number of Agent checks that need to be migrated.

### Performance

Switching from Agent V1 (legacy) to Agent V2 can either increase or decrease the number of resources used. Unlike Agent V1 (legacy), Agent V2 allows for synchronous execution of checks. This provides a better StackState experience, but may result in increased resource requirements.


## Migration process - Docker-Compose

### 1. Stop Agent V1 (legacy)

Agent V1 (legacy) will have to be stopped before proceeding with the **Agent V2 install** and **Agent V1 state** migration.

{% hint style="warning" %}
**If Agent V1 (legacy) is still running, it might interfere with the installation process of Agent V2 or, even worse, break the Agent V2 state.**
{% endhint %}

You can stop Agent V1 (legacy) with the following command:

```shell
sudo /etc/init.d/stackstate-agent stop
```

After the Agent has been stopped, verify its status with:

```shell
sudo /etc/init.d/stackstate-agent status
```

### 2. Create a Docker-Compose volume snippet of the conf.d files

For this step, you will not physically run or create any docker volumes, but you need to create a snippet of docker volumes that will be appended inside your docker-compose file.

To compile a list of all the conf.d docker volumes, do the following:

- Head over to the `/etc/sts-agent/conf.d/` folder.
- For each file inside the folder, compile a list of volumes. For example, if we use Splunk as the example:
  - File 1: `/etc/sts-agent/conf.d/splunk_topology.yaml`
    ```
    - "/etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml"
    ```
  - File 2: `/etc/sts-agent/conf.d/splunk_event.yaml`  
    **Add to the existing list**
    ```
    - "/etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml"
    - "/etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml"
    ```
  - File 3: `/etc/sts-agent/conf.d/splunk_metric.yaml`  
    **Add to the existing list**
    ```
    - "/etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml"
    - "/etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml"
    - "/etc/sts-agent/conf.d/splunk_metric.yaml:/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml"
    ```

Now that you have the snippet above keep it on the side, we will use it in the Docker-Compose file


### 2B. **This part is only required if you have Splunk Topology Check enabled**

{% hint style="warning" %}
**This will break the `splunk_topology.yaml` configuration for Agent V1 (legacy)**
{% endhint %}

- Edit the check configuration file `/etc/sts-agent/conf.d/splunk_topology.yaml` and replace all occurrences of the following items
  - `default_polling_interval_seconds` replace with `collection_interval`
  - `polling_interval_seconds` replace with `collection_interval`


### 3. Add the Agent State directory into your volume snippet

With the list of volumes you created in step 2, add one additional line for the Agent State, This will allow us to migrate the existing Agent V1 (legacy) State to the Agent V2 Docker Container.

Add the following line
```
- "/opt/stackstate-agent/run:/opt/stackstate-agent/run/"
```

If we look at the splunk example from the previous step, it will look as follows:
```
- "/opt/stackstate-agent/run:/opt/stackstate-agent/run/"
- "/etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml"
- "/etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml"
- "/etc/sts-agent/conf.d/splunk_metric.yaml:/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml"
```

Now that you have the snippet above keep it on the side, we will use it in the Docker-Compose file


### 4. Migrate the Agent V1 (legacy) cache

Migrating the Agent V1 (legacy) cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Back up the Agent V1 (legacy) cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent V1 (legacy) cache migration process.
  - The output of the cache migration process will either be manually moved into the Agent V2 cache directory or automatically, depending on the conversion process used for Agent V2 (Some steps, depending on the installation, can only be done manually).


### 5. Install and Start Agent V2

To run StackState Agent V2 with Docker compose

1. Add the following configuration to the compose file on each node where the Agent will run.  
   * `<STACKSTATE_RECEIVER_API_KEY>` is set during StackState installation.
   * `<STACKSTATE_RECEIVER_API_ADDRESS>` is specific to your installation of StackState.
   * `<ADD_YOUR_VOLUME_SNIPPET_YOU_CREATED_HERE>` this is the volume snippet you created in step 2 and 3.
```dockerfile
stackstate-agent:
 image: docker.io/stackstate/stackstate-agent-2:2.17.2
 network_mode: "host"
 pid: "host"
 privileged: true
 volumes:
   - "/var/run/docker.sock:/var/run/docker.sock:ro"
   - "/proc/:/host/proc/:ro"
   - "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
   - "/etc/passwd:/etc/passwd:ro"
   - "/sys/kernel/debug:/sys/kernel/debug"
   <ADD_YOUR_VOLUME_SNIPPET_YOU_CREATED_HERE>
 environment:
   STS_API_KEY: "<STACKSTATE_RECEIVER_API_KEY>"
   STS_STS_URL: "<STACKSTATE_RECEIVER_API_ADDRESS>"
   STS_PROCESS_AGENT_URL: "<STACKSTATE_RECEIVER_API_ADDRESS>"
   STS_PROCESS_AGENT_ENABLED: "true"
   STS_NETWORK_TRACING_ENABLED: "true"
   STS_PROTOCOL_INSPECTION_ENABLED: "true"
   STS_APM_URL: "<STACKSTATE_RECEIVER_API_ADDRESS>"
   STS_APM_ENABLED: "true"
   HOST_PROC: "/host/proc"
   HOST_SYS: "/host/sys"
```

Example with Splunk Included and the Agent V1 (legacy) State Directory
```dockerfile
stackstate-agent:
 image: docker.io/stackstate/stackstate-agent-2:2.17.2
 network_mode: "host"
 pid: "host"
 privileged: true
 volumes:
   - "/var/run/docker.sock:/var/run/docker.sock:ro"
   - "/proc/:/host/proc/:ro"
   - "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
   - "/etc/passwd:/etc/passwd:ro"
   - "/sys/kernel/debug:/sys/kernel/debug"
   - "/opt/stackstate-agent/run:/opt/stackstate-agent/run/"
   - "/etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml"
   - "/etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml"
   - "/etc/sts-agent/conf.d/splunk_metric.yaml:/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml"
 environment:
   STS_API_KEY: "<STACKSTATE_RECEIVER_API_KEY>"
   STS_STS_URL: "<STACKSTATE_RECEIVER_API_ADDRESS>"
   STS_PROCESS_AGENT_URL: "<STACKSTATE_RECEIVER_API_ADDRESS>"
   STS_PROCESS_AGENT_ENABLED: "true"
   STS_NETWORK_TRACING_ENABLED: "true"
   STS_PROTOCOL_INSPECTION_ENABLED: "true"
   STS_APM_URL: "<STACKSTATE_RECEIVER_API_ADDRESS>"
   STS_APM_ENABLED: "true"
   HOST_PROC: "/host/proc"
   HOST_SYS: "/host/sys"
```

2. Run the command
   ```
   docker-compose up -d
   ```




## Migration Process - Docker Single Container

### 1. Stop Agent V1 (legacy)

Agent V1 (legacy) will have to be stopped before proceeding with the **Agent V2 install** and **Agent V1 state** migration.

{% hint style="warning" %}
**If Agent V1 (legacy) is still running, it might interfere with the installation process of Agent V2 or, even worse, break the Agent V2 state.**
{% endhint %}

You can stop Agent V1 (legacy) with the following command:

```shell
sudo /etc/init.d/stackstate-agent stop
```

After the Agent has been stopped, verify its status with:

```shell
sudo /etc/init.d/stackstate-agent status
```

### 2. Create a Docker-Compose volume snippet of the conf.d files

For this step, you will not physically run or create any docker volumes, but you need to create a snippet of docker volumes that will be appended inside your docker run command.

To compile a list of all the conf.d docker volumes, do the following:

- Head over to the `/etc/sts-agent/conf.d/` folder.
- For each file inside the folder, compile a list of volumes. For example, if we use Splunk as the example **(Remember to add a \ on the ending of each line)**:
  - File 1: `/etc/sts-agent/conf.d/splunk_topology.yaml`
    ```
    -v /etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml \
    ```
  - File 2: `/etc/sts-agent/conf.d/splunk_event.yaml`  
    **Add to the existing list**
    ```
    -v /etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml \
    -v /etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml \
    ```
  - File 3: `/etc/sts-agent/conf.d/splunk_metric.yaml`  
    **Add to the existing list**
    ```
    -v /etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml \
    -v /etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml \
    -v /etc/sts-agent/conf.d/splunk_metric.yaml:/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml \
    ```

Now that you have the snippet above keep it on the side, we will use it in the docker run command


### 2B. **This part is only required if you have Splunk Topology Check enabled**

{% hint style="warning" %}
**This will break the `splunk_topology.yaml` conf for Agent V1 (legacy)**
{% endhint %}

- Edit the check configuration file `/etc/sts-agent/conf.d/splunk_topology.yaml` and replace all occurrences of the following items
  - `default_polling_interval_seconds` replace with `collection_interval`
  - `polling_interval_seconds` replace with `collection_interval`


### 3. Add the Agent State directory into your volume snippet

With the list of volumes you created in step 2, add one additional line for the Agent State, This will allow us to migrate the existing Agent V1 (legacy) State to the Agent V2 Docker Container.

Add the following line **(Remember to add a \ on the ending of each line)**
```
-v /opt/stackstate-agent/run:/opt/stackstate-agent/run/ \
```

If we look at the splunk example from the previous step, it will look as follows:
```
-v /opt/stackstate-agent/run:/opt/stackstate-agent/run/  \
-v /etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml  \
-v /etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml  \
-v /etc/sts-agent/conf.d/splunk_metric.yaml:/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml  \
```

Now that you have the snippet above keep it on the side, we will use it in the docker run command


### 4. Migrate the Agent V1 (legacy) cache

Migrating the Agent V1 (legacy) cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Back up the Agent V1 (legacy) cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent V1 (legacy) cache migration process.
  - The output of the cache migration process will either be manually moved into the Agent V2 cache directory or automatically, depending on the conversion process used for Agent V2 (Some steps, depending on the installation, can only be done manually).


### 5. Install and Start Agent V2

To start a single Docker container with StackState Agent V2, run the command below.

1. Add the following configuration to the compose file on each node where the Agent will run.
  * `<STACKSTATE_RECEIVER_API_KEY>` is set during StackState installation.
  * `<STACKSTATE_RECEIVER_API_ADDRESS>` is specific to your installation of StackState.
  * `<ADD_YOUR_VOLUME_SNIPPET_YOU_CREATED_HERE>` this is the volume snippet you created in step 2 and 3.
```shell
docker run -d \
    --name stackstate-agent \
    --privileged \
    --network="host" \
    --pid="host" \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /proc/:/host/proc/:ro \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v /sys/kernel/debug:/sys/kernel/debug \
    <ADD_YOUR_VOLUME_SNIPPET_YOU_CREATED_HERE>
    -e STS_API_KEY="<STACKSTATE_RECEIVER_API_KEY>" \
    -e STS_STS_URL="<STACKSTATE_RECEIVER_API_ADDRESS>" \
    -e STS_PROCESS_AGENT_URL="<STACKSTATE_RECEIVER_API_ADDRESS>" \
    -e STS_PROCESS_AGENT_ENABLED="true" \
    -e STS_NETWORK_TRACING_ENABLED="true" \
    -e STS_PROTOCOL_INSPECTION_ENABLED="true" \
    -e STS_APM_URL="<STACKSTATE_RECEIVER_API_ADDRESS>" \
    -e STS_APM_ENABLED="true" \
    -e HOST_PROC="/host/proc" \
    -e HOST_SYS="/host/sys" \
    docker.io/stackstate/stackstate-agent-2:2.17.2
```

Example with Splunk Included and the Agent V1 (legacy) State Directory
```dockerfile
docker run -d \
    --name stackstate-agent \
    --privileged \
    --network="host" \
    --pid="host" \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /proc/:/host/proc/:ro \
    -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v /sys/kernel/debug:/sys/kernel/debug \
    -v /opt/stackstate-agent/run:/opt/stackstate-agent/run/  \
    -v /etc/sts-agent/conf.d/splunk_topology.yaml:/etc/stackstate-agent/conf.d/splunk_topology.d/splunk_topology.yaml  \
    -v /etc/sts-agent/conf.d/splunk_event.yaml:/etc/stackstate-agent/conf.d/splunk_event.d/splunk_event.yaml  \
    -v /etc/sts-agent/conf.d/splunk_metric.yaml:/etc/stackstate-agent/conf.d/splunk_metric.d/splunk_metric.yaml  \
    -e STS_API_KEY="<STACKSTATE_RECEIVER_API_KEY>" \
    -e STS_STS_URL="<STACKSTATE_RECEIVER_API_ADDRESS>" \
    -e STS_PROCESS_AGENT_URL="<STACKSTATE_RECEIVER_API_ADDRESS>" \
    -e STS_PROCESS_AGENT_ENABLED="true" \
    -e STS_NETWORK_TRACING_ENABLED="true" \
    -e STS_PROTOCOL_INSPECTION_ENABLED="true" \
    -e STS_APM_URL="<STACKSTATE_RECEIVER_API_ADDRESS>" \
    -e STS_APM_ENABLED="true" \
    -e HOST_PROC="/host/proc" \
    -e HOST_SYS="/host/sys" \
    docker.io/stackstate/stackstate-agent-2:2.17.2
```

### 6. Add Splunk Health State

Agent V2 Supports a new Splunk check called Splunk Health state.

You can follow the docs [Splunk Health](/stackpacks/integrations/splunk/splunk_health.md) to enable this check.