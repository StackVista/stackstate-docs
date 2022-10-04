---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(Legacy\) to Agent V2 Migration

## Overview

The steps below will assist you in successfully migrating from Agent v1 to Agent v2.
This migration process will also migrate your existing Agent v1 state allowing checks like Splunk to continue from its previous state.

{% hint style="warning" %}
These steps **must be done in the correct order** to prevent any Agent v1 to Agent v2 issues.

Problems like invalid Agent state files, overwritten state files or even a broken Agent v2 instance can occur when the order is broken.
{% endhint %}

{% hint style="warning" %}
**If possible, it's highly recommended to run this migration in a Test Environment, It may affect some steps below but reduce the initial impact if something does not work**
{% endhint %}

{% hint style="warning" %}
## Impact Analysis

### Downtime
- When swapping between Agent v1 and Agent v2, there will be some downtime for the StackState Agent to allow a successful migration process.
- The length the Agent will be down for depends on how fast the process below happens.

### Performance
- The exact performance impact of switching from Agent v1 to Agent v2 can increase or decrease the number of resources used in the environments.
- Agent v2 is more synchronized than Agent v1, allowing a better StackState experience but may trigger more services as it is non-blocking.
  {% endhint %}


## Migration Process - Docker-Compose

### 1. Stop Agent v1

Agent v1 will have to be stopped before proceeding with the **Agent v2 install** and **Agent v1 state** migration.

{% hint style="warning" %}
**If Agent v1 is still running, it might interfere with the installation process of Agent v2 or, even worse, break the Agent v2 state.**
{% endhint %}

You can stop Agent v1 with the following command:

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
This will break the splunk_topology.yaml conf for Agent v1
{% endhint %}

- Edit the check configuration file `/etc/sts-agent/conf.d/splunk_topology.yaml` and replace all occurrences of the following items
  - `default_polling_interval_seconds` replace with `collection_interval`
  - `polling_interval_seconds` replace with `collection_interval`


### 3. Add the Agent State directory into your volume snippet

With the list of volumes you created in step 2, add one additional line for the Agent State, This will allow us to migrate the existing Agent v1 State to the Agent v2 Docker Container.

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


### 4. Migrate the Agent v1 Cache

Migrating the Agent v1 cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent v1 cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent v1 cache migration process.
  - The output of the cache migration process will either be manually moved into the Agent v2 cache directory or automatically, depending on the conversion process used for Agent v2 (Some steps, depending on the installation, can only be done manually).


### 5. Install and Start Agent v2

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

Example with Splunk Included and the Agent v1 State Directory
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

### 1. Stop Agent v1

Agent v1 will have to be stopped before proceeding with the **Agent v2 install** and **Agent v1 state** migration.

{% hint style="warning" %}
**If Agent v1 is still running, it might interfere with the installation process of Agent v2 or, even worse, break the Agent v2 state.**
{% endhint %}

You can stop Agent v1 with the following command:

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
This will break the splunk_topology.yaml conf for Agent v1
{% endhint %}

- Edit the check configuration file `/etc/sts-agent/conf.d/splunk_topology.yaml` and replace all occurrences of the following items
  - `default_polling_interval_seconds` replace with `collection_interval`
  - `polling_interval_seconds` replace with `collection_interval`


### 3. Add the Agent State directory into your volume snippet

With the list of volumes you created in step 2, add one additional line for the Agent State, This will allow us to migrate the existing Agent v1 State to the Agent v2 Docker Container.

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


### 4. Migrate the Agent v1 Cache

Migrating the Agent v1 cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent v1 cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent v1 cache migration process.
  - The output of the cache migration process will either be manually moved into the Agent v2 cache directory or automatically, depending on the conversion process used for Agent v2 (Some steps, depending on the installation, can only be done manually).


### 5. Install and Start Agent v2

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

Example with Splunk Included and the Agent v1 State Directory
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
