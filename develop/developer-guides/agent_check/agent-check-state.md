---
description: Rancher Observability Self-hosted v5.1.x 
---

# Agent Check State

## Overview

Starting with the release of **Agent 2.18**, the Agent Check API exposes two new interfaces to allow stateful behavior in Agent Checks. More specific details of the Agent interfaces can be found in the [Agent check API](agent-check-api.md)

## When to use Agent State

Agent State is intended for Agent Checks that need to persist state in between check runs. The type of persistence model to use depends on the use case. `Stateful Agent Checks` are able to persist state to disk after each check run, **regardless of whether the check completely successfully or data was successfully sent to Rancher Observability**. `Transactional Agent Checks` have two states; Persistent state which behaves the same as state in a `Stateful Agent Check` and transactional state. Transactional state is persisted when the check **completes successfully and the data was delivered to Rancher Observability.**

State(s) are parameters to the `stateful_check` and `transactional_check` methods and the values in the return type are eventually persisted.

⚠️ **PLEASE NOTE -** State files are persisted as plain text in JSON format, therefore no passwords / secrets should ever be stored as state.

## Agent State location

{% tabs %}

{% tab title="Linux" %}
The state files are located in the `/opt/stackstate-agent/run/{check_name}` folder for each stateful / transactional check.

The root path `/opt/stackstate-agent/run` can be updated by setting:
- `check_state_root_path` in the Agent configuration file located at: `/etc/stackstate-agent/stackstate.yaml`.
- Setting `STS_CHECK_STATE_ROOT_PATH={path}` as a environment variable.
{% endtab %}

{% tab title="Docker" %}
The state files are located in the `/opt/stackstate-agent/run/{check_name}` folder for each stateful / transactional check.

The root path `/opt/stackstate-agent/run` can be updated by setting:
- `check_state_root_path` in the Agent configuration file located at: `/etc/stackstate-agent/stackstate.yaml`.
- Setting `STS_CHECK_STATE_ROOT_PATH={path}` as a environment variable.
- Alternatively mount a volume on the check state root path. For more information on mounting volumes for Docker, take a look here: https://docs.docker.com/storage/volumes/.
{% endtab %}

{% tab title="Windows" %}
The state files are located in the `c:\programdata\stackstate-agent\run\{check_name}` folder for each stateful / transactional check.

The root path `c:\programdata\stackstate-agent\run` can be updated by setting:
- `check_state_root_path` in the Agent configuration file located at: `C:\ProgramData\Rancher Observability\stackstate.yaml`.
- Setting `STS_CHECK_STATE_ROOT_PATH={path}` as a environment variable.
{% endtab %}

{% endtabs %}


⚠️ **PLEASE NOTE -** Running stateful checks in Kubernetes is currently not supported by the Rancher Observability Agent Helm Chart.

## See also

* [How to develop Agent checks](how_to_develop_agent_checks.md)
* [Agent check API](agent-check-api.md)
* [Connect an Agent check with Rancher Observability using the Custom Synchronization StackPack](connect_agent_check_with_stackstate.md)
* [Developer guide - Custom Synchronization StackPack](../custom_synchronization_stackpack/)

