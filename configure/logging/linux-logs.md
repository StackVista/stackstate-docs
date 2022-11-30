---
description: StackState Self-hosted v5.1.x 
---

# Linux logs

## Overview

In a Linux setup, StackState keeps all log files in the `var/log` subdirectory of the StackState installation directory. By default, this is `/opt/stackstate/var/log`. In case of a two-node installation, logs are kept in the `var/log` directory on each node. Note that the logs are node-specific - the StackState node keeps StackState related logs and the StackGraph node keeps logs related to StackGraph.

## `var/log` details

Inside `var/log`, there is a subdirectory for each type of logs kept by StackState. By default, each subdirectory has a size cap of 2 GB; when exceeded, the oldest files are deleted. Example of `var/log` contents:

```text
.:
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 18 00:00 correlate
drwxr-xr-x. 2 stackstate stackstate     4096 Oct 23 00:00 elasticsearch
drwxr-xr-x. 2 stackstate stackstate    12288 Dec 18 00:00 elasticsearch7
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 18 00:00 kafka
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 18 00:20 kafka-to-es
drwxr-xr-x. 2 stackstate stackstate     4096 Nov 14 12:35 license-check
-rw-r--r--. 1 stackstate stackstate     2987 Dec 17 13:43 processmanager.2019-12-16.0.log
-rw-r--r--. 1 stackstate stackstate    65240 Dec 17 23:55 processmanager.2019-12-17.0.log
-rw-r--r--. 1 stackstate stackstate    10656 Dec 18 12:03 processmanager.log
drwxr-xr-x. 2 stackstate stackstate     4096 Oct 15 15:25 stackgraph
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 16 09:03 stackpack
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 17 13:21 stackstate
-rw-r--r--. 1 stackstate stackstate  6136841 Dec 16 23:59 stackstate.2019-12-16.11.log
-rw-r--r--. 1 stackstate stackstate 52429560 Dec 17 12:02 stackstate.2019-12-17.0.log
-rw-r--r--. 1 stackstate stackstate 52429586 Dec 17 20:39 stackstate.2019-12-17.1.log
-rw-r--r--. 1 stackstate stackstate 20252875 Dec 17 23:59 stackstate.2019-12-17.2.log
-rw-r--r--. 1 stackstate stackstate 52449712 Dec 18 00:37 stackstate.2019-12-18.0.log
-rw-r--r--. 1 stackstate stackstate 52441741 Dec 18 06:22 stackstate.2019-12-18.10.log
-rw-r--r--. 1 stackstate stackstate 52450906 Dec 18 07:27 stackstate.2019-12-18.11.log
-rw-r--r--. 1 stackstate stackstate 52478100 Dec 18 08:33 stackstate.2019-12-18.12.log
-rw-r--r--. 1 stackstate stackstate 52490055 Dec 18 09:37 stackstate.2019-12-18.13.log
-rw-r--r--. 1 stackstate stackstate 52428811 Dec 18 10:42 stackstate.2019-12-18.14.log
-rw-r--r--. 1 stackstate stackstate 52496521 Dec 18 11:48 stackstate.2019-12-18.15.log
-rw-r--r--. 1 stackstate stackstate 52445570 Dec 18 12:54 stackstate.2019-12-18.16.log
-rw-r--r--. 1 stackstate stackstate 52435555 Dec 18 01:10 stackstate.2019-12-18.1.log
-rw-r--r--. 1 stackstate stackstate 52453947 Dec 18 01:44 stackstate.2019-12-18.2.log
-rw-r--r--. 1 stackstate stackstate 52449896 Dec 18 02:19 stackstate.2019-12-18.3.log
-rw-r--r--. 1 stackstate stackstate 52429347 Dec 18 02:54 stackstate.2019-12-18.4.log
-rw-r--r--. 1 stackstate stackstate 52435159 Dec 18 03:29 stackstate.2019-12-18.5.log
-rw-r--r--. 1 stackstate stackstate 52486191 Dec 18 04:03 stackstate.2019-12-18.6.log
-rw-r--r--. 1 stackstate stackstate 52440210 Dec 18 04:38 stackstate.2019-12-18.7.log
-rw-r--r--. 1 stackstate stackstate 52436912 Dec 18 05:13 stackstate.2019-12-18.8.log
-rw-r--r--. 1 stackstate stackstate 52432884 Dec 18 05:47 stackstate.2019-12-18.9.log
-rw-r--r--. 1 stackstate stackstate   469460 Dec 18 12:54 stackstate.log
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 18 00:00 stackstate-receiver
-rw-r--r--. 1 stackstate stackstate  1067419 Nov 20 10:04 stackstate-service.log
drwxr-xr-x. 2 stackstate stackstate     4096 Dec 18 12:49 sync
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 13:27 transaction.metrics.0.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 12:38 transaction.metrics.1.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 11:48 transaction.metrics.2.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 10:52 transaction.metrics.3.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 10:01 transaction.metrics.4.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 09:11 transaction.metrics.5.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 08:21 transaction.metrics.6.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 07:28 transaction.metrics.7.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 06:28 transaction.metrics.8.log
-rw-r--r--. 1 stackstate stackstate    50.0M Jan 11 05:32 transaction.metrics.9.log
-rw-r--r--. 1 stackstate stackstate     9.2M Jan 11 13:38 transaction.metrics.log

./correlate:
-rw-r--r--. 1 stackstate stackstate 10389822 Dec 18 12:54 correlate.log
-rw-r--r--. 1 stackstate stackstate  3913232 Dec 18 12:54 worker.correlateConnections-1.log
-rw-r--r--. 1 stackstate stackstate  2629015 Dec 18 12:54 worker.correlateConnections-2.log
-rw-r--r--. 1 stackstate stackstate  3731346 Dec 18 12:54 worker.correlateConnections-3.log

./elasticsearch:
-rw-r--r--. 1 stackstate stackstate   3401 Oct 15 15:46 stackstate-2019-10-15.log
-rw-r--r--. 1 stackstate stackstate   3484 Oct 16 08:27 stackstate-2019-10-16.log
-rw-r--r--. 1 stackstate stackstate  50560 Oct 17 08:24 stackstate-2019-10-17.log
-rw-r--r--. 1 stackstate stackstate   3678 Oct 18 07:01 stackstate-2019-10-18.log
-rw-r--r--. 1 stackstate stackstate  32024 Oct 21 21:05 stackstate-2019-10-21.log
-rw-r--r--. 1 stackstate stackstate 129371 Oct 22 23:19 stackstate-2019-10-22.log
-rw-r--r--. 1 stackstate stackstate      0 Oct 15 15:46 stackstate_deprecation.log
-rw-r--r--. 1 stackstate stackstate      0 Oct 15 15:46 stackstate_index_indexing_slowlog.log
-rw-r--r--. 1 stackstate stackstate      0 Oct 15 15:46 stackstate_index_search_slowlog.log
-rw-r--r--. 1 stackstate stackstate   4664 Oct 23 10:29 stackstate.log

./elasticsearch7:
-rw-r--r--. 1 stackstate stackstate    75279 Dec 18 00:00 stackstate-2019-12-17-1.json.gz
-rw-r--r--. 1 stackstate stackstate    70897 Dec 18 00:00 stackstate-2019-12-17-1.log.gz
-rw-r--r--. 1 stackstate stackstate  2941900 Dec 18 10:27 stackstate_deprecation.json
-rw-r--r--. 1 stackstate stackstate  1932090 Dec 18 10:27 stackstate_deprecation.log
-rw-r--r--. 1 stackstate stackstate   145330 Dec 18 12:54 stackstate.log
-rw-r--r--. 1 stackstate stackstate   344879 Dec 18 12:54 stackstate_server.json

./kafka:
-rw-r--r--. 1 stackstate stackstate        0 Oct 15 15:46 authorizer.log
-rw-r--r--. 1 stackstate stackstate   538780 Dec 18 12:50 controller.log
-rw-r--r--. 1 stackstate stackstate 11640758 Nov 20 10:04 kafka-gc.log
-rw-r--r--. 1 stackstate stackstate    15856 Dec 17 16:02 log-cleaner.log
-rw-r--r--. 1 stackstate stackstate        0 Oct 15 15:46 request.log
-rw-r--r--. 1 stackstate stackstate   397450 Dec 18 12:45 server.log
-rw-r--r--. 1 stackstate stackstate   204722 Dec 17 13:45 state-change.log

./kafka-to-es:
-rw-r--r--. 1 stackstate stackstate   180046 Dec 18 12:54 kafkaEventsToES.log
-rw-r--r--. 1 stackstate stackstate   202857 Dec 17 23:58 kafkaEventsToES.log.2019-12-17.0
-rw-r--r--. 1 stackstate stackstate    13164 Dec 18 12:23 kafkaMultiMetricsToES.log
-rw-r--r--. 1 stackstate stackstate    81363 Dec 17 23:55 kafkaMultiMetricsToES.log.2019-12-17.0
-rw-r--r--. 1 stackstate stackstate    19358 Dec 18 12:18 kafkaStsEventsToES.log
-rw-r--r--. 1 stackstate stackstate   141928 Dec 17 23:52 kafkaStsEventsToES.log.2019-12-17.0

./license-check:
-rw-r--r--. 1 stackstate stackstate 4928 Nov 14 12:39 license-app.log

./stackgraph:

./stackpack:
-rw-r--r--. 1 stackstate stackstate   906 Dec 13 13:57 agent-common.2019-12-13.0.log
-rw-r--r--. 1 stackstate stackstate  4990 Dec 16 09:11 agent-common.log
-rw-r--r--. 1 stackstate stackstate  1818 Dec 16 09:03 aws.log
-rw-r--r--. 1 stackstate stackstate  3161 Dec 13 14:02 common.2019-12-13.0.log
-rw-r--r--. 1 stackstate stackstate  5418 Dec 16 09:11 common.log
-rw-r--r--. 1 stackstate stackstate  1354 Dec 13 14:02 k8s-common.log
-rw-r--r--. 1 stackstate stackstate  4274 Dec 13 14:03 kubernetes.log
-rw-r--r--. 1 stackstate stackstate   533 Oct 21 09:26 stackstate-agent-v2.2019-10-21.0.log
-rw-r--r--. 1 stackstate stackstate 72850 Dec 16 09:11 stackstate-agent-v2.log

./stackstate:

./stackstate-receiver:
-rw-r--r--. 1 stackstate stackstate 29430771 Dec 17 23:59 stackstate-receiver.2019-12-17.0.log
-rw-r--r--. 1 stackstate stackstate 11586394 Dec 18 12:54 stackstate-receiver.log

./sync:
total 1043088
-rw-r--r--. 1 stackstate stackstate 24768357 Dec 17 23:59 sync.Agent.2019-12-17.9.log
-rw-r--r--. 1 stackstate stackstate 52430757 Dec 18 02:31 sync.Agent.2019-12-18.0.log
-rw-r--r--. 1 stackstate stackstate 52428990 Dec 18 05:11 sync.Agent.2019-12-18.1.log
-rw-r--r--. 1 stackstate stackstate 52430847 Dec 18 07:48 sync.Agent.2019-12-18.2.log
-rw-r--r--. 1 stackstate stackstate 52430381 Dec 18 10:26 sync.Agent.2019-12-18.3.log
-rw-r--r--. 1 stackstate stackstate 45954315 Dec 18 12:54 sync.Agent.log
-rw-r--r--. 1 stackstate stackstate   383053 Dec 17 23:13 sync.AWS Sync for Account - 508573134510.2019-12-17.0.log
-rw-r--r--. 1 stackstate stackstate   160967 Dec 18 12:13 sync.AWS Sync for Account - 508573134510.log
-rw-r--r--. 1 stackstate stackstate   248557 Dec 17 23:30 sync.AWS Sync for Account - 766509113410.2019-12-17.0.log
-rw-r--r--. 1 stackstate stackstate   120016 Dec 18 12:30 sync.AWS Sync for Account - 766509113410.log
-rw-r--r--. 1 stackstate stackstate 52494635 Dec 18 05:12 sync.Kubernetes - stseuw1-preprod-dev-eks-dev.2019-12-18.1.log
-rw-r--r--. 1 stackstate stackstate 52490024 Dec 18 07:48 sync.Kubernetes - stseuw1-preprod-dev-eks-dev.2019-12-18.2.log
-rw-r--r--. 1 stackstate stackstate 52450773 Dec 18 10:22 sync.Kubernetes - stseuw1-preprod-dev-eks-dev.2019-12-18.3.log
-rw-r--r--. 1 stackstate stackstate 52478535 Dec 18 12:49 sync.Kubernetes - stseuw1-preprod-dev-eks-dev.2019-12-18.4.log
-rw-r--r--. 1 stackstate stackstate  2014902 Dec 18 12:54 sync.Kubernetes - stseuw1-preprod-dev-eks-dev.log
-rw-r--r--. 1 stackstate stackstate 52438711 Dec 17 20:39 sync.Kubernetes - stseuw1-sandbox-main-eks-sandbox.2019-12-17.5.log
-rw-r--r--. 1 stackstate stackstate 50769208 Dec 17 23:59 sync.Kubernetes - stseuw1-sandbox-main-eks-sandbox.2019-12-17.6.log
-rw-r--r--. 1 stackstate stackstate 52497481 Dec 18 03:26 sync.Kubernetes - stseuw1-sandbox-main-eks-sandbox.2019-12-18.0.log
-rw-r--r--. 1 stackstate stackstate 52530973 Dec 18 06:53 sync.Kubernetes - stseuw1-sandbox-main-eks-sandbox.2019-12-18.1.log
-rw-r--r--. 1 stackstate stackstate 52539980 Dec 18 10:20 sync.Kubernetes - stseuw1-sandbox-main-eks-sandbox.2019-12-18.2.log
-rw-r--r--. 1 stackstate stackstate 39488493 Dec 18 12:54 sync.Kubernetes - stseuw1-sandbox-main-eks-sandbox.log
-rw-r--r--. 1 stackstate stackstate 52435381 Dec 17 15:23 sync.Kubernetes - stseuw1-tooling-main-eks-tooling.2019-12-17.2.log
-rw-r--r--. 1 stackstate stackstate 52429788 Dec 17 20:32 sync.Kubernetes - stseuw1-tooling-main-eks-tooling.2019-12-17.3.log
-rw-r--r--. 1 stackstate stackstate 35254609 Dec 17 23:59 sync.Kubernetes - stseuw1-tooling-main-eks-tooling.2019-12-17.4.log
-rw-r--r--. 1 stackstate stackstate 52435568 Dec 18 05:08 sync.Kubernetes - stseuw1-tooling-main-eks-tooling.2019-12-18.0.log
-rw-r--r--. 1 stackstate stackstate 52456809 Dec 18 10:14 sync.Kubernetes - stseuw1-tooling-main-eks-tooling.2019-12-18.1.log
-rw-r--r--. 1 stackstate stackstate 27479646 Dec 18 12:54 sync.Kubernetes - stseuw1-tooling-main-eks-tooling.log
-rw-r--r--. 1 stackstate stackstate      800 Dec 16 09:19 sync.Mysql.2019-12-16.0.log
-rw-r--r--. 1 stackstate stackstate      798 Dec 17 13:52 sync.Mysql.log
-rw-r--r--. 1 stackstate stackstate      805 Dec 16 09:19 sync.Postgresql.2019-12-16.0.log
-rw-r--r--. 1 stackstate stackstate      805 Dec 17 13:52 sync.Postgresql.log
```

{% hint style="info" %}
From StackState v1.15.0, the version of Elasticsearch used by StackState changed. Elasticsearch logs are now saved in `./elasticsearch7`. You can remove the old `./elasticsearch` subdirectory to free some disk space.
{% endhint %}

## Log files

StackState keeps logs in files that have a maximum size of 50 MB. When a log file exceeds 50 MB size cap, it's divided into ordered parts, as in the below example:

```text
./sync:
total 1043088
-rw-r--r--. 1 stackstate stackstate 52430757 Dec 18 02:31 sync.Agent.2019-12-18.0.log
-rw-r--r--. 1 stackstate stackstate 52428990 Dec 18 05:11 sync.Agent.2019-12-18.1.log
-rw-r--r--. 1 stackstate stackstate 52430847 Dec 18 07:48 sync.Agent.2019-12-18.2.log
-rw-r--r--. 1 stackstate stackstate 52430381 Dec 18 10:26 sync.Agent.2019-12-18.3.log
```

## Default log pattern

StackState builds log files using the following default log pattern: `"%date [%thread] %-5level %logger{60} - %msg%n"`