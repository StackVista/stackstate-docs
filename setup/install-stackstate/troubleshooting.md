---
description: StackState Self-hosted v4.6.x
---

# Troubleshooting

## Quick troubleshooting guide

Here is a quick guide for troubleshooting the startup of StackState on Kubernetes and Linux:

{% tabs %}
{% tab title="Kubernetes" %}
1. Check that the install completed successfully and the release is listed:

   ```text
   helm list --namespace stackstate
   ```

2. Check that all pods in the StackState namespace are running:

   ```text
   kubectl get pods
   ```

3. [Check the logs](../../configure/logging/stackstate-log-files.md) for errors.
4. Check the Knowledge base on the [StackState Support site](https://support.stackstate.com/).
{% endtab %}

{% tab title="Linux" %}
1. Check that the systemd services StackGraph and StackState are running:

   ```text
   sudo systemctl status stackgraph
   sudo systemctl status stackstate
   ```

2. Check connection to StackState's user interface, default listening on TCP port 7070.
3. Check log files for errors, located at `/opt/stackstate/var/log/`
4. Check the Knowledge base on the [StackState Support site](https://support.stackstate.com/).
{% endtab %}
{% endtabs %}

## Known issues

Check the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/sections/360004684540-Known-issues) to find troubleshooting steps for all known issues.

