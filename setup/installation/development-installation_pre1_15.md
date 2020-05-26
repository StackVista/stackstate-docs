---
title: Development Installation before 1.15.0
kind: Documentation
---

### Requirements

Before starting the installation, ensure your system(s) meet StackState's [installation requirements](/setup/installation/requirements/).

### Installing StackState in a single-node configuration

For a basic single-node setup of StackState, simply follow the instructions for
[Installing StackState](/setup/installation/install_stackstate).

### Starting and Stopping

#### SystemD service

The RPM and DEB packages install SystemD services for StackState and StackGraph. StackState can be started with
`sudo systemctl start stackstate.service` this will also start service StackGraph. Starting StackState can take some time.

After starting processes are complete, the service is available at `http://<stackstate_hostname>:7070`.

#### Stopping StackState

StackState can be stopped by `sudo systemctl stop stackstate.service`. StackGraph is not automatically stopped when stopping StackState, StackGraph can be stopped by `sudo systemctl stop stackgraph.service`.

#### StackState Status

Checking the service status can be done with `sudo systemctl status stackstate.service` and `sudo systemctl status stackgraph.service`.
