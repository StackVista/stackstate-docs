---
description: StackState Self-hosted v5.1.x
---

# Agent V1 \(Legacy\) to Agent V2 Migration

## Overview

A few steps is required to successfully migrate from Agent v1 to Agent v2 including the Agent v1 cache.

These steps **must be done in order** to prevent any Agent v1 to Agent v2 problems, either caused by the upgrade process or missing Agent v2 cache files.


## Impact Analysis

### Downtime
- When swapping between Agent v1 and Agent v2, there will be some downtime for the StackState Agent to allow a successful migration process.
- The length the Agent will be down for all depends on how fast the process below happens.

### Performance
- The exact performance impact of switching from Agent v1 to Agent v2 can increase or decrease the amount of resources used on the environments.
- Agent v2 is more synchronise than Agent v1 allowing a better StackState experience but may trigger more services as it is non-blocking.


## Migration Process

### 1. Stop Agent v1

Stop the currently running v1 Agent. If the Agent is still running, it might interfere with the installation process of Agent v2 or, even worse, break the agent cache.

This can be done by following [Agent v1 - Start and Stop](/setup/agent/agent-v1.md#start-stop-restart-the-agent).

### 2. Prepare a list of conf.d check docker volumes

For this step you will not physically run or create any docker volumes, but you need to compile a list of docker
volumes that will be appended inside your docker deployment command.

To compile a list of the docker volumes do the following:
- Head over to the `/etc/sts-agent/conf.d/` folder.
- For each of the files inside the folder compile a list of volumes. For example, if you see the files `check_1.yaml` and `check_2.yaml` the volume command will look as follows.
  - For a Docker Single Container (Remember the \ at the end of each line)
    ```
    -v /etc/sts-agent/conf.d/check_1.yaml:/etc/stackstate-agent/conf.d/check_1.d/check_1.yaml \
    -v /etc/sts-agent/conf.d/check_2.yaml:/etc/stackstate-agent/conf.d/check_2.d/check_2.yaml \
    ```
  - Or a Docker Compose File
    ```
    volumes:
      - "/etc/sts-agent/conf.d/check_1.yaml:/etc/stackstate-agent/conf.d/check_1.d/check_1.yaml"
      - "/etc/sts-agent/conf.d/check_2.yaml:/etc/stackstate-agent/conf.d/check_2.d/check_2.yaml"
    ```
Keep the above command in a note for later use.

### 3. Add the Agent v1 state directory to your list of volumes

With the list of volumes you created in step 2, add one additional line for the Agent State.

- For a Docker Single Container (Remember the \ at the end of each line)
  ```
  -v /opt/stackstate-agent/run:/opt/stackstate-agent/run/ \
  ```
  The full example will look as follows:
  ```
  -v /etc/sts-agent/conf.d/check_1.yaml:/etc/stackstate-agent/conf.d/check_1.d/check_1.yaml \
  -v /etc/sts-agent/conf.d/check_2.yaml:/etc/stackstate-agent/conf.d/check_2.d/check_2.yaml \
  -v /opt/stackstate-agent/run:/opt/stackstate-agent/run/ \
  ```

- Or a Docker Compose File
  ```
  volumes:
    - "/opt/stackstate-agent/run:/opt/stackstate-agent/run/"
  ```
  The full example will look as follows:
  ```
  volumes:
    - "/opt/stackstate-agent/run:/opt/stackstate-agent/run/"
    - "/etc/sts-agent/conf.d/check_1.yaml:/etc/stackstate-agent/conf.d/check_1.d/check_1.yaml"
    - "/etc/sts-agent/conf.d/check_2.yaml:/etc/stackstate-agent/conf.d/check_2.d/check_2.yaml"
  ```

Keep the above command in a note for later use.

### 5. Migrate the Agent v1 Cache

Migrating the Agent v1 cache requires a cache conversion process, and this is a manual process that StackState will assist you with.
Contact StackState to assist with this process.

A breakdown of the steps that will happen in the cache migration is as follows:

- Backing up the Agent v1 cache folder from the following location `/opt/stackstate-agent/run/`.
- Run the Agent v1 cache migration process.
   - The output of the cache migration process will either be manually moved into the Agent v2 cache directory or automatically, depending on the conversion process used for Agent v2 (Some steps depending on the installation can only be done manually).

### 6. Install and Start Agent v2

While installing the StackState Agent v2 Docker instance remember to add the list
of volume you previously compiled inside the docker run command or docker compose file.

- To install a docker single instance use the following documentation and add your previously compiled volumes inside the `docker run -d` command.
  - [Docker Single Instance](/setup/agent/docker.md#single-container)

- To install a docker compose instance use the following documentation and add your previously compiled volumes inside the `volumes:` path (Do not remove the existing volumes):
  - [Docker Compose Instance](/setup/agent/docker.md#docker-compose)

