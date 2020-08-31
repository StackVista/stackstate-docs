---
title: Troubleshooting
kind: Documentation
---

# Troubleshooting StackState startup

## Issues getting StackState started

Here is a quick guide for troubleshooting the startup of StackState:

1. Check whether systemd service StackGraph is started by `sudo systemctl status stackgraph.service`
2. Check whether systemd service StackState is started by `sudo systemctl status stackstate.service`
3. Check connection to StackState's user interface, default listening on TCP port 7070.
4. Check log files for errors, located at `/opt/stackstate/var/log/`

## Known issues

### Timeout notification when uninstalling or upgrading a StackPack

Please be aware that when uninstalling or upgrading a StackPack, it can fail with a timeout message. This happens due to a high load on StackState, or high amounts of data related to this StackPack. We are working on solving this issue; however, for the time being, the solution is to retry the uninstall or upgrade operation until it succeeds.

### Error `InterruptedException` when opening a view

**Symptom**: opening a view that is expected to contain a large topology results in an error and the `/opt/stackstate/var/log/stackstate.log` log shows an exception similar to:

```text
... Starting ViewEventSummaryStream web socket stream failed.
com.stackvista.graph.hbase.StackHBaseException: Error while accessing HBase
...
Caused by: java.io.InterruptedIOException: Origin: InterruptedException
```

**Cause**: topology elements that are not cached are not fully retrieved from StackGraph within a certain period of time before a timeout, `InterruptedException`, is triggered.

**Possible solution**: increase the cache size by editing StackState's configuration.

In `/opt/stackstate/etc/application_stackstate.conf` add the following configuration `stackgraph.vertex.cache.size = <size>` where `<size>` is the number of Graph vertices. An initial cache size can be obtained by adding:

* number of components \* 10,
* number of relations \* 10,
* number of checks \* 5.

The default cache size is set to 8191. Make sure the cache size is defined as a power of two minus one, e.g. `2^13-1 = 8191`.

Make sure that StackState has enough memory available, the available memory can be configured by editing: `/opt/stackstate/etc/processmanager/processmanager.conf`. Under process named `stackstate-server`, change `-Xmx1G` to `-Xmx<N>G` where `<N>` is the number of desired GBs of memory. For example, change the setting to `-Xmx8G` to have 8 GBs of memory available to StackState.

Restart StackState, by `sudo systemctl restart stackstate.service`, for the changes to be effective.

### Error `illegal reflective access` when starting StackState

**Symptom**: when starting any component of StackState, the log shows a message similar to the following:

```text
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/opt/stackstate/stackgraph/lib/groovy-2.4.8-indy.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
```

**Cause**: running StackState on a Java version newer than JDK 8.

**Solution**:

Install JDK 8 using the following commands:

```text
# sudo apt-get install openjdk-8-jdk
# sudo update-alternatives --config java

There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1101      auto mode
  1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1101      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode

Press <enter> to keep the current choice[*], or type selection number: 2
update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java to provide /usr/bin/java (java) in manual mode
```

### Error `/opt/stackstate/*/bin/*.sh: line 45: /opt/stackstate/var/log/*/*.log: Permission denied`

**Symptom**: when starting any component of StackState, the log shows a message similar to the following:

```text
/opt/stackstate/*/bin/*.sh: line 45: /opt/stackstate/var/log/*/*.log: Permission denied
```

**Cause**: StackState has been started using `root` or other user credentials followed by starting StackState as a service.

**Solution**: Remove the contents of `/opt/stackstate/var/log/stackstate` and `/opt/stackstate/var/log/stackgraph` directories and restart StackState.

### Error `/opt/stackstate/var/log/license-check/license-app.log: Permission denied`

**Symptom**: when starting any component of StackState, the log shows a message similar to the following:

```text
/opt/stackstate/var/log/license-check/license-app.log: Permission denied
```

**Cause**: the license key registration command was executed as `root` or other user followed by starting StackState as a service.

**Solution**: Remove the contents of `/opt/stackstate/var/log/license-check` and restart StackState.

### Error `InvalidSchema("No connection adapters were found for '%s' % url")`

**Symptom**: no data received in StackState from the AWS source that has access to StackState receiver service, the CloudWatch log stream related to the AWS lambda function StackState-Topo-Cron shows a message similar to the following:

```text
InvalidSchema("No connection adapters were found for 'stackstate.acme.com:7077/stsAgent/'")
```

**Cause**: Environment variable 'STACKSTATE\_BASE\_URL' for lambda function is not correct.

**Solution**: Check if the URL provided for the `STACKSTATE_BASE_URL` environment variable on AWS Lambda function is correct. Be sure that protocol is specified, e.g., `http://`, and that it points to a proper port. Read more on [configuring the receiver base URL](https://github.com/StackVista/stackstate-docs/tree/7b63b38aa95b63faadf80045a0e41f308c239e59/setup/installation/configuration.md).

### Error `ERROR | dd.collector | checks.splunk_topology(__init__.py:1002) | Check 'splunk_topology' instance #0 failed`

**Symptom**: Splunk saved search with SID \(Splunk job id\) results in `ERROR: CheckException: Splunk topology failed with message: 400 Client Error: Bad Request for url:` message. StackState log in `/var/log/stackstate/collector.log` shows the following:

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

