---
title: Troubleshooting
kind: Documentation
---

# Troubleshooting

## Starting StackState

### Quick troubleshooting guide

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
{% endtab %}

{% tab title="Linux" %}
1. Check that the systemd services StackGraph and StackState are running:

   ```text
   sudo systemctl status stackgraph
   sudo systemctl status stackstate
   ```

2. Check connection to StackState's user interface, default listening on TCP port 7070.
3. Check log files for errors, located at `/opt/stackstate/var/log/`
{% endtab %}
{% endtabs %}

### Linux - Error: `illegal reflective access`

**Symptom**: When starting any component of StackState, the log shows a message similar to the following:

```text
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/opt/stackstate/stackgraph/lib/groovy-2.4.8-indy.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
```

**Cause**: This warning is the result of restrictions imposed by JDK 11 on certain operations.

**Solution**: JDK versions 9 or higher are not currently supported. See the StackState [Requirements for Linux servers](requirements.md#linux).

### Linux - Error: `/opt/stackstate/*/bin/*.sh: line 45: /opt/stackstate/var/log/*/*.log: Permission denied`

**Symptom**: When starting any component of StackState, the log shows a message similar to the following:

```text
/opt/stackstate/*/bin/*.sh: line 45: /opt/stackstate/var/log/*/*.log: Permission denied
```

**Cause**: StackState has been started using `root` or other user credentials followed by starting StackState as a service.

**Solution**: Remove the contents of `/opt/stackstate/var/log/stackstate` and `/opt/stackstate/var/log/stackgraph` directories and restart StackState.

### Linux - Error: `/opt/stackstate/var/log/license-check/license-app.log: Permission denied`

**Symptom**: When starting any component of StackState, the log shows a message similar to the following:

```text
/opt/stackstate/var/log/license-check/license-app.log: Permission denied
```

**Cause**: The license key registration command was executed as `root` or other user followed by starting StackState as a service.

**Solution**: Remove the contents of `/opt/stackstate/var/log/license-check` and restart StackState.

## Install

### Kubernetes - `helm list` does not show the StackState release

**Symptom**: After install, the StackState release is not shown in `helm list`. Attempting to re-run the installation fails.

**Cause**: StackState was only partially deployed during the initial install.

**Solution**: Run `helm uninstall <release-name>` where `<release-name>` should be the same as that used in the initial installation command. Helm will clean up the initial install and, after that, installation can be run again.

## Upgrade

### Kubernetes - `helm upgrade` fails

**Symptom**: Running `helm upgrade` on Kubernetes fails.

**Cause**:

**Solution**: First run `helm uninstall <release-name>` and then run `helm upgrade` again. This will cause \(more\) down-time, but will preserve all data.

{% hint style="danger" %}
NEVER delete the namespace or persistent volumes - that will remove all data.
{% endhint %}

### Error: `java.lang.IllegalStateException: Requested index specs do not match the catalog.`

**Symptom**: StackState will not start after upgrading to a newer version. StackState.log reflects:

```text
2019-07-31 13:14:27,139 [main] INFO  com.stackstate.StackStateMainContext - StackState starting with graph database: default
2019-07-31 13:14:41,577 [main] WARN  com.stackstate.WebApp$ - Unexpected error:
java.lang.IllegalStateException: Requested index specs do not match the catalog.
Either enable automaticReIndexOnStartup feature or apply the offline reindex command.
Diff (this = Requested; that = Catalog):
>> Only in this Spec:
  - IndexSpecification(selectors=[SelectorSpecification(property=~label, value=ComponentType)], property=identifier, normalized=false, uniqueConstrained=true)
  - IndexSpecification(selectors=[SelectorSpecification(property=~label, value=RelationMappingFunction)], property=identifier, normalized=false, uniqueConstrained=true)
  ...
```

**Cause**: Introduced index changes.

**Solution**: Follow the [reindex process](troubleshooting.md#reindex-stackstate)

## StackPacks and integrations

### Timeout notification when uninstalling or upgrading a StackPack

Please be aware that when uninstalling or upgrading a StackPack, it can fail with a timeout message. This happens due to a high load on StackState, or high amounts of data related to this StackPack. We are working on solving this issue; however, for the time being, the solution is to retry the uninstall or upgrade operation until it succeeds.

### Error: `InvalidSchema("No connection adapters were found for '%s' % url")`

**Symptom**: No data received in StackState from the AWS source that has access to StackState receiver service, the CloudWatch log stream related to the AWS lambda function StackState-Topo-Cron shows a message similar to the following:

```text
InvalidSchema("No connection adapters were found for 'stackstate.acme.com:7077/stsAgent/'")
```

**Cause**: Environment variable 'STACKSTATE\_BASE\_URL' for lambda function is not correct.

**Solution**: Check if the URL provided for the `STACKSTATE_BASE_URL` environment variable on AWS Lambda function is correct. Be sure that protocol is specified, e.g., `http://`, and that it points to a proper port. Read more:

* [Kubernetes - base URL](kubernetes_install/install_stackstate.md#generate-values-yaml)
* [Linux - receiver base URL](linux_install/install_stackstate.md#configuration-options-required-during-install)

### Error: `ERROR | dd.collector | checks.splunk_topology(__init__.py:1002) | Check 'splunk_topology' instance #0 failed`

**Symptom**: The Splunk saved search configured in the Agent with SID \(Splunk job id\) results in `ERROR: CheckException: Splunk topology failed with message: 400 Client Error: Bad Request for url:` message. The StackState log in `/var/log/stackstate/collector.log` shows the following:

```text
2019-08-06 15:50:41 CEST | ERROR | dd.collector | checks.splunk_topology(__init__.py:1002) | Check 'splunk_topology' instance #0 failed
Traceback (most recent call last):
  File "/opt/stackstate-agent/agent/checks/__init__.py", line 985, in run
    self.check(copy.deepcopy(instance))
  File "/opt/stackstate-agent/agent/checks.d/splunk_topology.py", line 115, in check
    all_success &= self._dispatch_and_await_search(instance, saved_searches)
  File "/opt/stackstate-agent/agent/checks.d/splunk_topology.py", line 155, in _dispatch_and_await_search
    all_success &= self._process_saved_search(sid, saved_search, instance, start_time)
  File "/opt/stackstate-agent/agent/checks.d/splunk_topology.py", line 162, in _process_saved_search
    responses = self._search(search_id, saved_search, instance)
  File "/opt/stackstate-agent/agent/checks.d/splunk_topology.py", line 198, in _search
    return instance.splunkHelper.saved_search_results(search_id, saved_search)
  File "/opt/stackstate-agent/agent/utils/splunk/splunk_helper.py", line 82, in saved_search_results
    response = self._search_chunk(saved_search, search_id, offset, saved_search.batch_size)
  File "/opt/stackstate-agent/agent/utils/splunk/splunk_helper.py", line 60, in _search_chunk
    response = self._do_get(search_path, saved_search.request_timeout_seconds, self.instance_config.verify_ssl_certificate)
  File "/opt/stackstate-agent/agent/utils/splunk/splunk_helper.py", line 136, in _do_get
    response.raise_for_status()
  File "/opt/stackstate-agent/embedded/lib/python2.7/site-packages/requests/models.py", line 862, in raise_for_status
    raise HTTPError(http_error_msg, response=self)
CheckException: Splunk topology failed with message: 400 Client Error: Bad Request for url: https://splunkapidev.tooling.domain.org:8089/services/-/-/search/jobs/srvc_stackstate_dta__nobody__stackstate__RMD58e4feb463ac11e00_at_1565099425_16190_89DA7433-D1EE-4944-9376-2FE48FCA08B6/results?output_mode=json&offset=0&count=1000
```

**Cause**: Saved search definition contains an error, or the job id \(SID\) is not available anymore in Splunk. Jobs in Splunk expire, and they are no longer available from jobs/activity screen and saved search.

**Solution**: Check the status of the Splunk job using SID in Splunk Activity Screen. To do this, you need to extract the job id from the URL provided in the error message. SID is located in the URL right after `/jobs/` - `.../search/jobs/{SID}/...`. Now you can check this job in Splunk Activity menu.

## Using StackState

### Linux - No topology results shown in any view

**Symptom**: Going to any view will show no topology results. A long error appears in the `stackstate.log`, beginning with:

```text
[StackStateGlobalActorSystem-akka.actor.default-dispatcher-92] ERROR com.stackstate.plugins.sts.topology.StsTopologyService - Error in identity extractor
com.stackstate.domain.script.ScriptExecutionException: Script threw error. null. Script: '
...
```

**Cause**: StackState v4.1.0 installed in a Linux environment running JDK 11.

**Solution**: JDK versions 9 or higher are not currently supported. See the StackState [Requirements for Linux servers](requirements.md#linux).

### Error: `InterruptedException` when opening a view

**Symptom**: Opening a view that is expected to contain a large topology results in an error and the `/opt/stackstate/var/log/stackstate.log` log shows an exception similar to:

```text
... Starting ViewEventSummaryStream web socket stream failed.
com.stackvista.graph.hbase.StackHBaseException: Error while accessing HBase
...
Caused by: java.io.InterruptedIOException: Origin: InterruptedException
```

**Cause**: Topology elements that are not cached are not fully retrieved from StackGraph within a certain period of time before a timeout, `InterruptedException`, is triggered.

**Possible solution**: Increase the cache size by editing StackState's configuration.

In `/opt/stackstate/etc/application_stackstate.conf` add the following configuration `stackgraph.vertex.cache.size = <size>` where `<size>` is the number of Graph vertices. An initial cache size can be obtained by adding:

* number of components \* 10,
* number of relations \* 10,
* number of checks \* 5.

The default cache size is set to 8191. Make sure the cache size is defined as a power of two minus one, e.g. `2^13-1 = 8191`.

Make sure that StackState has enough memory available, the available memory can be configured by editing: `/opt/stackstate/etc/processmanager/processmanager.conf`. Under process named `stackstate-server`, change `-Xmx1G` to `-Xmx<N>G` where `<N>` is the number of desired GBs of memory. For example, change the setting to `-Xmx8G` to have 8 GBs of memory available to StackState.

Restart StackState, by `sudo systemctl restart stackstate.service`, for the changes to be effective.

## Reindex StackState

{% hint style="danger" %}
It is not advised to reindex StackState unless this was explicitly recommended by [StackState support](https://www.stackstate.com/contact/).
{% endhint %}

For search and querying purposes, StackState builds an index out of data in the graph database. It is possible to initiate a rebuild of this index from StackState's graph database. Note that under normal circumstances you will never need to do this.

1. Make sure that StackState is not running with the following command: `systemctl stop stackstate`
2. Make sure that StackGraph is running with the following command: `systemctl start stackgraph`
3. Execute the reindex command: `sudo -u stackstate /opt/stackstate/bin/sts-standalone.sh reindex --graph default`

{% hint style="danger" %}
**Do not kill the reindex process while it is running.**  
The reindex process will take some time to complete. You can monitor progress in the StackState logs.
{% endhint %}

