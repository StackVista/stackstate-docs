---
description: Configure StackState to match your data volume
---

# Limits

## Overview

In an installation of StackState, some features are subject to limits in terms of data volume. Some of these can be tweaked when increased volume is required.

## Amount of running checks

A production setup on kubernetes or linux will support at least 40.000 running checks. The exact amount is logged at startup as the following logline:

```text
2020-12-02 10:22:56,905 [StackStateGlobalActorSystem-akka.actor.default-dispatcher-25] INFO  c.s.domainactors.DomainActorPoolImpl$DomainActorPoolActor - Starting domainActorPool with limit <limit> for Check
```

For different setups this resides in different logs:

{% tabs %}
{% tab title="Kubernetes > 4.2" %}
This is reported at the start of the podlogs of the `stackstate-checks` pod.
{% endtab %}

{% tab title="Kubernetes < 4.2" %}
This is reported at the start of the podlogs of the `stackstate-server` pod.
{% endtab %}

{% tab title="Linux" %}
This is reported at the start of the logfile `/opt/stackstate/var/log/stackstate.log`.
{% endtab %}
{% endtabs %}

If the amount of checks is not sufficient, the check limit can be increased by increasing the memory of the process the checks run in. Because StackState is a java-based application there is
a limit to how much memory a process should have (around 8GB) for it to function proper. Bigger processors will cause too long Garbage Collection runs.

{% tabs %}
{% tab title="Kubernetes > 4.2" %}
Add to `values.yaml`

stackstate.components.checks.resources.limits.memory = "<memory>"
stackstate.components.checks.resources.requests.memory = "<memory>"
{% endtab %}

{% tab title="Kubernetes < 4.2" %}
Add to `values.yaml`

```text
stackstate.components.server.resources.limits.memory = "<memory>"
stackstate.components.server.resources.requests.memory = "<memory>"
```
{% endtab %}

{% tab title="Linux" %}
Add to `/opt/stackstate/etc/processmanager/processmanager-properties-overrides.conf`

```text
properties.sts-memory = "<memory>"
```
{% endtab %}
{% endtabs %}
