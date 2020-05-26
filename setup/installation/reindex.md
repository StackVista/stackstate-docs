---
title: Reindex
kind: Documentation
---

# reindex

StackState depends on a data model. When data model changes for any reason \(e.g., upgrade to a new version\) there is a need to run a reindexing process.

Reindex needs to be run in Terminal \(or other CLI\) on the machine that hosts StackState \(for the [production setup](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/production-installation/README.md)\).

First, make sure that StackState is not running with the following command:

`systemctl stop stackstate`

Then, make sure that StackGraph is running with the following command:

`systemctl start stackgraph`

Then execute the reindex command:

`sudo -u stackstate /opt/stackstate/bin/sts-standalone.sh reindex --graph default`

Please note that this is a long-running process - monitoring progress in StackState logs is advised.

