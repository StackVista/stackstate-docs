---
title: Troubleshooting
kind: Documentation
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
3. [Check the logs](../configure/stackstate_log_files.md) for errors.
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

Details of troubleshooting known issues can be found in the [StackState support Knowledge base](https://support.stackstate.com/hc/en-us/sections/360004684540-Known-issues).

## Reindex StackState

{% hint style="danger" %}
It is not advised to reindex StackState unless this was explicitly recommended by [StackState support](https://www.stackstate.com/company/contact/).
{% endhint %}

For search and querying purposes, StackState builds an index out of data in the graph database. It is possible to initiate a rebuild of this index from StackState's graph database. Note that under normal circumstances you will never need to do this.

1. Make sure that StackState is not running with the following command: `systemctl stop stackstate`
2. Make sure that StackGraph is running with the following command: `systemctl start stackgraph`
3. Execute the reindex command: `sudo -u stackstate /opt/stackstate/bin/sts-standalone.sh reindex --graph default`

{% hint style="danger" %}
**Do not kill the reindex process while it is running.**  
The reindex process will take some time to complete. You can monitor progress in the StackState logs.
{% endhint %}
