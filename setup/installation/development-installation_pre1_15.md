---
title: Development Installation before 1.15.0
kind: Documentation
---

# development-installation\_pre1\_15

## Requirements

Before starting the installation, ensure your system\(s\) meet StackState's [installation requirements](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/requirements/README.md).

## Installing StackState in a single-node configuration

For a basic single-node setup of StackState, simply follow the instructions for [Installing StackState](https://github.com/mpvvliet/stackstate-docs/tree/0f69067c340456b272cfe50e249f4f4ee680f8d9/setup/installation/install_stackstate/README.md).

## Starting and Stopping

### SystemD service

The RPM and DEB packages install SystemD services for StackState and StackGraph. StackState can be started with `sudo systemctl start stackstate.service` this will also start service StackGraph. Starting StackState can take some time.

After starting processes are complete, the service is available at `http://<stackstate_hostname>:7070`.

### Stopping StackState

StackState can be stopped by `sudo systemctl stop stackstate.service`. StackGraph is not automatically stopped when stopping StackState, StackGraph can be stopped by `sudo systemctl stop stackgraph.service`.

### StackState Status

Checking the service status can be done with `sudo systemctl status stackstate.service` and `sudo systemctl status stackgraph.service`.

